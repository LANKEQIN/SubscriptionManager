import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/subscription.dart';
import '../../repositories/error_handler.dart';
import '../../repositories/repository_interfaces.dart';
import '../../utils/app_logger.dart';
import '../api/subscription_api.dart';
import '../dio_client.dart';
import '../dto/subscription_requests.dart';
import '../graphql/subscription_service.dart';

/// 增强的远程订阅 Repository
/// 集成 Dio、Retrofit 和 GraphQL 技术栈
class EnhancedRemoteSubscriptionRepository 
    with ErrorHandler 
    implements SubscriptionRepository {
  
  final SubscriptionApi _api;
  final GraphQLSubscriptionService _graphqlService;
  final bool useGraphQL;
  
  EnhancedRemoteSubscriptionRepository({
    SubscriptionApi? api,
    GraphQLSubscriptionService? graphqlService,
    this.useGraphQL = true,
  }) : _api = api ?? SubscriptionApi(DioClient.instance),
        _graphqlService = graphqlService ?? GraphQLSubscriptionService();
  
  @override
  Future<List<Subscription>> getAllSubscriptions() async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        return await _getSubscriptionsWithGraphQL();
      } else {
        return await _getSubscriptionsWithREST();
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> addSubscription(Subscription subscription) async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        await _addSubscriptionWithGraphQL(subscription);
      } else {
        await _addSubscriptionWithREST(subscription);
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        await _updateSubscriptionWithGraphQL(subscription);
      } else {
        await _updateSubscriptionWithREST(subscription);
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> deleteSubscription(String id) async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        await _deleteSubscriptionWithGraphQL(id);
      } else {
        await _deleteSubscriptionWithREST(id);
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 搜索订阅（新增功能）
  @override
  Future<List<Subscription>> searchSubscriptions(String query) async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        final dtos = await _graphqlService.searchSubscriptions(
          userId: _currentUserId!,
          searchTerm: query,
          limit: 10,
          offset: 0,
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      } else {
        final dtos = await _api.searchSubscriptions(
          '*',
          _currentUserId!,
          'like.*$query*',
          'eq.true',
          'created_at.desc',
          10,
          0,
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 获取即将到期的订阅（新增功能）
  @override
  Future<List<Subscription>> getUpcomingSubscriptions({int daysAhead = 7}) async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        final dtos = await _graphqlService.getUpcomingSubscriptions(
          userId: _currentUserId!,
          daysAhead: daysAhead,
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      } else {
        final endDate = DateTime.now().add(Duration(days: daysAhead));
        final dtos = await _api.getUpcomingSubscriptions(
          '*',
          _currentUserId!,
          'lt.${endDate.toIso8601String()}',
          'eq.true',
          'next_renewal_date.asc',
        );
        return dtos.map((dto) => dto.toDomain()).toList();
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 获取订阅统计数据（新增功能）
  Future<Map<String, dynamic>> getSubscriptionStats() async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        return await _graphqlService.getSubscriptionStats(_currentUserId!);
      } else {
        final statsData = await _api.getSubscriptionStats(_currentUserId!);
        // 由于API现在返回String，我们需要解析JSON
        return json.decode(statsData) as Map<String, dynamic>;
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 批量更新订阅状态（新增功能）
  Future<void> batchUpdateSubscriptions(
    List<String> ids,
    Map<String, dynamic> updates,
  ) async {
    try {
      _ensureUserLoggedIn();
      
      if (useGraphQL) {
        await _graphqlService.batchUpdateSubscriptions(ids, updates);
      } else {
        final idFilter = 'in.(${ids.join(',')})';
        await _api.batchUpdateSubscriptions(idFilter, updates);
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 订阅实时更新（新增功能）
  Stream<List<Subscription>> subscribeToUpdates() {
    _ensureUserLoggedIn();
    
    return _graphqlService
        .subscribeToUpdates(_currentUserId!)
        .map((dtos) => dtos.map((dto) => dto.toDomain()).toList());
  }
  
  // GraphQL 实现方法
  Future<List<Subscription>> _getSubscriptionsWithGraphQL() async {
    try {
      final dtos = await _graphqlService.getSubscriptions(
        userId: _currentUserId!,
        isActive: true,
      );
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      // GraphQL 失败时降级到 REST API
      AppLogger.w('GraphQL 查询失败，降级到 REST API', e);
      return await _getSubscriptionsWithREST();
    }
  }
  
  Future<void> _addSubscriptionWithGraphQL(Subscription subscription) async {
    final input = {
      'name': subscription.name,
      'price': subscription.price,
      'currency': subscription.currency,
      'billing_cycle': subscription.billingCycle,
      'next_renewal_date': subscription.nextPaymentDate.toIso8601String(),
      'auto_renewal': subscription.autoRenewal,
      'description': subscription.notes,
      'icon_name': subscription.icon,
      'user_id': _currentUserId,
      'is_active': true,
    };
    
    await _graphqlService.createSubscription(input);
  }
  
  Future<void> _updateSubscriptionWithGraphQL(Subscription subscription) async {
    final input = {
      'name': subscription.name,
      'price': subscription.price,
      'currency': subscription.currency,
      'billing_cycle': subscription.billingCycle,
      'next_renewal_date': subscription.nextPaymentDate.toIso8601String(),
      'auto_renewal': subscription.autoRenewal,
      'description': subscription.notes,
      'icon_name': subscription.icon,
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    await _graphqlService.updateSubscription(subscription.id, input);
  }
  
  Future<void> _deleteSubscriptionWithGraphQL(String id) async {
    await _graphqlService.deleteSubscription(id);
  }
  
  // REST API 实现方法
  Future<List<Subscription>> _getSubscriptionsWithREST() async {
    final dtos = await _api.getSubscriptions(
      '*',
      _currentUserId!,
      'eq.true',
      'created_at.desc',
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }
  
  Future<void> _addSubscriptionWithREST(Subscription subscription) async {
    final request = CreateSubscriptionRequest(
      name: subscription.name,
      price: subscription.price,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextRenewalDate: subscription.nextPaymentDate,
      autoRenewal: subscription.autoRenewal,
      description: subscription.notes,
      iconName: subscription.icon,
      userId: _currentUserId,
    );
    
    await _api.createSubscription(request, 'return=representation');
  }
  
  Future<void> _updateSubscriptionWithREST(Subscription subscription) async {
    final request = UpdateSubscriptionRequest(
      name: subscription.name,
      price: subscription.price,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextRenewalDate: subscription.nextPaymentDate,
      autoRenewal: subscription.autoRenewal,
      description: subscription.notes,
      iconName: subscription.icon,
      updatedAt: DateTime.now(),
    );
    
    await _api.updateSubscription(
      'eq.${subscription.id}',
      request,
      'return=representation',
    );
  }
  
  Future<void> _deleteSubscriptionWithREST(String id) async {
    await _api.deleteSubscription('eq.$id');
  }
  
  // 辅助方法
  String? get _currentUserId => Supabase.instance.client.auth.currentUser?.id;
  
  void _ensureUserLoggedIn() {
    if (_currentUserId == null) {
      throw Exception('用户未登录');
    }
  }
  
  // 实现缺失的接口方法
  @override
  Future<Subscription?> getSubscriptionById(String id) async {
    try {
      _ensureUserLoggedIn();
      final dtos = await _api.getSubscription('*', 'eq.$id');
      if (dtos.isEmpty) return null;
      return dtos.first.toDomain();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getExpiredSubscriptions() async {
    try {
      _ensureUserLoggedIn();
      final now = DateTime.now().toIso8601String();
      final dtos = await _api.getUpcomingSubscriptions(
        '*',
        _currentUserId!,
        'lt.$now',
        'eq.true',
        'next_renewal_date.desc',
      );
      return dtos.map((dto) => dto.toDomain()).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getSubscriptionsByType(String type) async {
    try {
      _ensureUserLoggedIn();
      final subscriptions = await getAllSubscriptions();
      return subscriptions.where((s) => s.type == type).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<double> getTotalMonthlyAmount([String? currency]) async {
    try {
      _ensureUserLoggedIn();
      final subscriptions = await getAllSubscriptions();
      if (currency != null) {
        return subscriptions
            .where((s) => s.currency == currency)
            .fold<double>(0.0, (sum, s) => sum + s.price);
      } else {
        return subscriptions.fold<double>(0.0, (sum, s) => sum + s.price);
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
}