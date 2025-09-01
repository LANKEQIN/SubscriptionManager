import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_client.dart';
import '../dto/subscription_dto.dart';
import 'subscription_queries.dart';

/// GraphQL 操作服务
/// 封装所有 GraphQL 操作的具体实现
class GraphQLSubscriptionService {
  final GraphQLClient _client;
  
  GraphQLSubscriptionService({GraphQLClient? client})
      : _client = client ?? GraphQLClientManager.instance;
  
  /// 获取用户的所有订阅
  Future<List<SubscriptionDto>> getSubscriptions({
    required String userId,
    bool isActive = true,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(getSubscriptionsQuery),
        variables: {
          'userId': userId,
          'isActive': isActive,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final subscriptions = result.data?['subscriptionsCollection']?['edges']
        ?.map<SubscriptionDto>((edge) => 
            SubscriptionDto.fromJson(edge['node'] as Map<String, dynamic>))
        ?.toList() ?? <SubscriptionDto>[];
    
    return subscriptions;
  }
  
  /// 根据 ID 获取单个订阅
  Future<SubscriptionDto?> getSubscriptionById(String id) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(getSubscriptionByIdQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.cacheFirst,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final edges = result.data?['subscriptionsCollection']?['edges'] as List?;
    if (edges?.isEmpty ?? true) {
      return null;
    }
    
    return SubscriptionDto.fromJson(edges!.first['node'] as Map<String, dynamic>);
  }
  
  /// 创建新订阅
  Future<SubscriptionDto> createSubscription(Map<String, dynamic> input) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(createSubscriptionMutation),
        variables: {'input': input},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final records = result.data?['insertIntoSubscriptionsCollection']?['records'] as List?;
    if (records?.isEmpty ?? true) {
      throw Exception('创建订阅失败');
    }
    
    return SubscriptionDto.fromJson(records!.first as Map<String, dynamic>);
  }
  
  /// 更新订阅
  Future<SubscriptionDto> updateSubscription(
    String id,
    Map<String, dynamic> input,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(updateSubscriptionMutation),
        variables: {
          'id': id,
          'input': input,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final records = result.data?['updateSubscriptionsCollection']?['records'] as List?;
    if (records?.isEmpty ?? true) {
      throw Exception('更新订阅失败');
    }
    
    return SubscriptionDto.fromJson(records!.first as Map<String, dynamic>);
  }
  
  /// 删除订阅
  Future<void> deleteSubscription(String id) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(deleteSubscriptionMutation),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final records = result.data?['deleteFromSubscriptionsCollection']?['records'] as List?;
    if (records?.isEmpty ?? true) {
      throw Exception('删除订阅失败');
    }
  }
  
  /// 搜索订阅
  Future<List<SubscriptionDto>> searchSubscriptions({
    required String userId,
    required String searchTerm,
    bool isActive = true,
    int? limit,
    int? offset,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(searchSubscriptionsQuery),
        variables: {
          'userId': userId,
          'searchTerm': '%$searchTerm%',
          'isActive': isActive,
          'limit': limit,
          'offset': offset,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final subscriptions = result.data?['subscriptionsCollection']?['edges']
        ?.map<SubscriptionDto>((edge) => 
            SubscriptionDto.fromJson(edge['node'] as Map<String, dynamic>))
        ?.toList() ?? <SubscriptionDto>[];
    
    return subscriptions;
  }
  
  /// 获取即将到期的订阅
  Future<List<SubscriptionDto>> getUpcomingSubscriptions({
    required String userId,
    int daysAhead = 7,
  }) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(getUpcomingSubscriptionsQuery),
        variables: {
          'userId': userId,
          'daysAhead': daysAhead,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final subscriptions = result.data?['subscriptionsCollection']?['edges']
        ?.map<SubscriptionDto>((edge) => 
            SubscriptionDto.fromJson(edge['node'] as Map<String, dynamic>))
        ?.toList() ?? <SubscriptionDto>[];
    
    return subscriptions;
  }
  
  /// 获取订阅统计数据
  Future<Map<String, dynamic>> getSubscriptionStats(String userId) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(getSubscriptionStatsQuery),
        variables: {'userId': userId},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
    
    final subscriptions = result.data?['subscriptionsCollection']?['edges'] as List? ?? [];
    
    // 计算统计数据
    double totalCost = 0;
    double monthlyCost = 0;
    int activeCount = subscriptions.length;
    Map<String, double> currencyBreakdown = {};
    
    for (final edge in subscriptions) {
      final subscription = edge['node'] as Map<String, dynamic>;
      final price = (subscription['price'] as num).toDouble();
      final currency = subscription['currency'] as String;
      final billingCycle = subscription['billing_cycle'] as String;
      
      // 转换为月度成本
      double monthlyPrice = price;
      switch (billingCycle.toLowerCase()) {
        case 'yearly':
          monthlyPrice = price / 12;
          break;
        case 'weekly':
          monthlyPrice = price * 4.33;
          break;
        case 'daily':
          monthlyPrice = price * 30;
          break;
      }
      
      monthlyCost += monthlyPrice;
      totalCost += price;
      
      currencyBreakdown[currency] = (currencyBreakdown[currency] ?? 0) + monthlyPrice;
    }
    
    return {
      'totalCost': totalCost,
      'monthlyCost': monthlyCost,
      'yearlyCost': monthlyCost * 12,
      'activeSubscriptions': activeCount,
      'currencyBreakdown': currencyBreakdown,
    };
  }
  
  /// 批量更新订阅状态
  Future<void> batchUpdateSubscriptions(
    List<String> ids,
    Map<String, dynamic> updates,
  ) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(batchUpdateSubscriptionsMutation),
        variables: {
          'ids': ids,
          'input': updates,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
    
    if (result.hasException) {
      throw result.exception!;
    }
  }
  
  /// 订阅订阅数据的实时更新
  Stream<List<SubscriptionDto>> subscribeToUpdates(String userId) {
    return _client
        .subscribe(
          SubscriptionOptions(
            document: gql(subscribeToSubscriptionUpdates),
            variables: {'userId': userId},
          ),
        )
        .map((result) {
          if (result.hasException) {
            throw result.exception!;
          }
          
          final data = result.data?['subscriptionsCollection'] as List? ?? [];
          return data
              .map<SubscriptionDto>((item) => 
                  SubscriptionDto.fromJson(item as Map<String, dynamic>))
              .toList();
        });
  }
}