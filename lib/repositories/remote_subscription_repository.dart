import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import 'repository_interfaces.dart';
import 'error_handler.dart';

/// 远程订阅数据仓库实现
/// 
/// 负责与Supabase数据库进行订阅数据的交互
class RemoteSubscriptionRepository with ErrorHandler implements SubscriptionRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  
  /// 获取当前用户ID
  String? get _currentUserId => SupabaseConfig.currentUser?.id;
  
  /// 确保用户已登录
  void _ensureUserLoggedIn() {
    if (_currentUserId == null) {
      throw Exception('用户未登录');
    }
  }
  
  @override
  Future<List<Subscription>> getAllSubscriptions() async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      return response.map<Subscription>((json) => 
          Subscription.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<Subscription?> getSubscriptionById(String id) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('id', id)
          .maybeSingle();
      
      if (response != null) {
        return Subscription.fromSupabaseJson(response);
      }
      return null;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> addSubscription(Subscription subscription) async {
    try {
      _ensureUserLoggedIn();
      
      final data = subscription.toSupabaseJson();
      data['user_id'] = _currentUserId!;
      
      await _client.from('subscriptions').insert(data);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      _ensureUserLoggedIn();
      
      if (subscription.serverId == null) {
        throw Exception('无法更新没有服务器ID的订阅');
      }
      
      final data = subscription.toSupabaseJson();
      data.remove('id'); // 移除id字段，避免更新主键
      data.remove('user_id'); // 移除user_id字段，避免权限问题
      
      await _client
          .from('subscriptions')
          .update(data)
          .eq('id', subscription.serverId!)
          .eq('user_id', _currentUserId!);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> deleteSubscription(String id) async {
    try {
      _ensureUserLoggedIn();
      
      await _client
          .from('subscriptions')
          .delete()
          .eq('id', id)
          .eq('user_id', _currentUserId!);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> searchSubscriptions(String query) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('is_active', true)
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);
      
      return response.map<Subscription>((json) => 
          Subscription.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<double> getTotalMonthlyAmount() async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select('price, billing_cycle')
          .eq('user_id', _currentUserId!)
          .eq('is_active', true);
      
      double total = 0.0;
      for (final item in response) {
        final price = (item['price'] ?? 0.0).toDouble();
        final billingCycle = item['billing_cycle'] ?? '';
        
        switch (billingCycle) {
          case 'monthly':
            total += price;
            break;
          case 'yearly':
            total += price / 12;
            break;
          case 'quarterly':
            total += price / 3;
            break;
          case 'weekly':
            total += price * 4.33; // 一个月约4.33周
            break;
        }
      }
      
      return total;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getUpcomingSubscriptions({int daysAhead = 7}) async {
    try {
      _ensureUserLoggedIn();
      
      final now = DateTime.now();
      final endDate = now.add(Duration(days: daysAhead));
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('is_active', true)
          .gte('next_renewal_date', now.toIso8601String())
          .lte('next_renewal_date', endDate.toIso8601String())
          .order('next_renewal_date', ascending: true);
      
      return response.map<Subscription>((json) => 
          Subscription.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getExpiredSubscriptions() async {
    try {
      _ensureUserLoggedIn();
      
      final now = DateTime.now();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('is_active', true)
          .lt('next_renewal_date', now.toIso8601String())
          .order('next_renewal_date', ascending: false);
      
      return response.map<Subscription>((json) => 
          Subscription.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getSubscriptionsByType(String type) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('is_active', true)
          .eq('category', type)
          .order('created_at', ascending: false);
      
      return response.map<Subscription>((json) => 
          Subscription.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 根据本地ID查找订阅
  Future<Subscription?> getSubscriptionByLocalId(String localId) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('local_id', localId)
          .maybeSingle();
      
      if (response != null) {
        return Subscription.fromSupabaseJson(response);
      }
      return null;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 获取指定时间之后更新的订阅
  Future<List<Subscription>> getSubscriptionsUpdatedAfter(DateTime timestamp) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('subscriptions')
          .select()
          .eq('user_id', _currentUserId!)
          .gte('updated_at', timestamp.toIso8601String())
          .order('updated_at', ascending: false);
      
      return response.map<Subscription>((json) => 
          Subscription.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 批量插入订阅
  Future<void> batchInsertSubscriptions(List<Subscription> subscriptions) async {
    try {
      _ensureUserLoggedIn();
      
      if (subscriptions.isEmpty) return;
      
      final data = subscriptions.map((subscription) {
        final json = subscription.toSupabaseJson();
        json['user_id'] = _currentUserId!;
        return json;
      }).toList();
      
      await _client.from('subscriptions').insert(data);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 批量更新订阅
  Future<void> batchUpdateSubscriptions(List<Subscription> subscriptions) async {
    try {
      _ensureUserLoggedIn();
      
      for (final subscription in subscriptions) {
        if (subscription.serverId != null) {
          await updateSubscription(subscription);
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
}

/// 远程月度历史数据仓库实现
class RemoteMonthlyHistoryRepository with ErrorHandler implements MonthlyHistoryRepository {
  final SupabaseClient _client = SupabaseConfig.client;
  
  /// 获取当前用户ID
  String? get _currentUserId => SupabaseConfig.currentUser?.id;
  
  /// 确保用户已登录
  void _ensureUserLoggedIn() {
    if (_currentUserId == null) {
      throw Exception('用户未登录');
    }
  }
  
  @override
  Future<List<MonthlyHistory>> getAllHistories() async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('monthly_histories')
          .select()
          .eq('user_id', _currentUserId!)
          .order('year', ascending: false)
          .order('month', ascending: false);
      
      return response.map<MonthlyHistory>((json) => 
          MonthlyHistory.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<MonthlyHistory?> getHistoryByYearMonth(int year, int month) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('monthly_histories')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('year', year)
          .eq('month', month)
          .maybeSingle();
      
      if (response != null) {
        return MonthlyHistory.fromSupabaseJson(response);
      }
      return null;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<void> updateCurrentMonthHistory(List<Subscription> subscriptions) async {
    try {
      _ensureUserLoggedIn();
      
      final now = DateTime.now();
      // 计算当月总金额
      double totalAmount = 0.0;
      for (final subscription in subscriptions) {
        // 转换为月度金额
        switch (subscription.billingCycle) {
          case 'monthly':
            totalAmount += subscription.price;
            break;
          case 'yearly':
            totalAmount += subscription.price / 12;
            break;
          case 'quarterly':
            totalAmount += subscription.price / 3;
            break;
          case 'weekly':
            totalAmount += subscription.price * 4.33;
            break;
        }
      }
      
      final history = MonthlyHistory.create(
        year: now.year,
        month: now.month,
        totalAmount: totalAmount,
        subscriptionCount: subscriptions.length,
      );
      
      await saveHistory(history);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<void> addMonthlyHistory(MonthlyHistory history) async {
    try {
      _ensureUserLoggedIn();
      
      final data = history.toSupabaseJson();
      data['user_id'] = _currentUserId!;
      
      await _client
          .from('monthly_histories')
          .insert(data);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<void> deleteMonthlyHistory(String id) async {
    try {
      _ensureUserLoggedIn();
      
      await _client
          .from('monthly_histories')
          .delete()
          .eq('user_id', _currentUserId!)
          .eq('id', id);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<List<MonthlyHistory>> getYearlyStatistics(int year) async {
    try {
      _ensureUserLoggedIn();
      
      final response = await _client
          .from('monthly_histories')
          .select()
          .eq('user_id', _currentUserId!)
          .eq('year', year)
          .order('month', ascending: false);
      
      return response.map<MonthlyHistory>((json) => 
          MonthlyHistory.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }

  @override
  Future<List<MonthlyHistory>> getHistoriesInRange(DateTime startDate, DateTime endDate) async {
    try {
      _ensureUserLoggedIn();
      
      final startYear = startDate.year;
      final startMonth = startDate.month;
      final endYear = endDate.year;
      final endMonth = endDate.month;
      
      final response = await _client
          .from('monthly_histories')
          .select()
          .eq('user_id', _currentUserId!)
          .or('year.gt.$startYear,and(year.eq.$startYear,month.gte.$startMonth)')
          .or('year.lt.$endYear,and(year.eq.$endYear,month.lte.$endMonth)')
          .order('year', ascending: false)
          .order('month', ascending: false);
      
      return response.map<MonthlyHistory>((json) => 
          MonthlyHistory.fromSupabaseJson(json)).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> saveHistory(MonthlyHistory history) async {
    try {
      _ensureUserLoggedIn();
      
      final data = history.toSupabaseJson();
      data['user_id'] = _currentUserId!;
      
      await _client
          .from('monthly_histories')
          .upsert(data);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> deleteHistory(String id) async {
    try {
      _ensureUserLoggedIn();
      
      await _client
          .from('monthly_histories')
          .delete()
          .eq('user_id', _currentUserId!)
          .eq('id', id);
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
}