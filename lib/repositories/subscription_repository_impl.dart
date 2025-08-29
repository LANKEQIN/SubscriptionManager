import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../cache/hive_service.dart';
import '../models/subscription.dart';
import 'repository_interfaces.dart';
import 'error_handler.dart';

/// 订阅仓储实现类
/// 实现订阅数据的增删改查操作，集成Drift数据库和Hive缓存
class SubscriptionRepositoryImpl with ErrorHandler implements SubscriptionRepository {
  final AppDatabase _database;
  
  SubscriptionRepositoryImpl(this._database);

  static const String _cacheKeyPrefix = 'subscriptions_';
  static const String _allSubscriptionsCacheKey = 'all_subscriptions';

  @override
  Future<List<Subscription>> getAllSubscriptions() async {
    return handleDatabaseOperation(() async {
      // 尝试从缓存获取
      final cached = HiveService.getCacheList<Map<String, dynamic>>(
        _allSubscriptionsCacheKey,
        (json) => json,
      );
      
      if (cached != null) {
        return cached.map((data) => _subscriptionFromJson(data)).toList();
      }
      
      // 从数据库获取
      final entities = await _database.getAllSubscriptions();
      final subscriptions = entities.map(_entityToSubscription).toList();
      
      // 更新缓存
      if (subscriptions.isNotEmpty) {
        await HiveService.setCacheList<Map<String, dynamic>>(
          _allSubscriptionsCacheKey,
          subscriptions.map((s) => _subscriptionToJson(s)).toList(),
          (data) => data,
          expiry: CachePolicy.getCacheDuration('subscriptions'),
        );
      }
      
      return subscriptions;
    });
  }

  @override
  Future<Subscription?> getSubscriptionById(String id) async {
    return handleDatabaseOperation(() async {
      // 尝试从缓存获取
      final cacheKey = '$_cacheKeyPrefix$id';
      final cached = HiveService.getCacheObject<Map<String, dynamic>>(
        cacheKey,
        (json) => json,
      );
      
      if (cached != null) {
        return _subscriptionFromJson(cached);
      }
      
      // 从数据库获取
      final entity = await _database.getSubscriptionById(id);
      if (entity == null) return null;
      
      final subscription = _entityToSubscription(entity);
      
      // 更新缓存
      await HiveService.setCacheObject<Map<String, dynamic>>(
        cacheKey,
        _subscriptionToJson(subscription),
        (json) => json,
        (data) => data,
        expiry: CachePolicy.getCacheDuration('subscriptions'),
      );
      
      return subscription;
    });
  }

  @override
  Future<void> addSubscription(Subscription subscription) async {
    return handleDatabaseOperation(() async {
      // 确保有有效的ID
      final subscriptionWithId = subscription.id.isEmpty 
          ? subscription.copyWith(id: const Uuid().v4())
          : subscription;
      
      final entity = _subscriptionToEntity(subscriptionWithId);
      await _database.insertSubscription(entity);
      
      // 清除相关缓存
      await _invalidateCache();
    });
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    return handleDatabaseOperation(() async {
      final entity = _subscriptionToEntity(subscription);
      await _database.updateSubscriptionById(subscription.id, entity);
      
      // 清除相关缓存
      await _invalidateCache();
    });
  }

  @override
  Future<void> deleteSubscription(String id) async {
    return handleDatabaseOperation(() async {
      await _database.deleteSubscriptionById(id);
      
      // 清除相关缓存
      await _invalidateCache();
    });
  }

  @override
  Future<List<Subscription>> searchSubscriptions(String query) async {
    return handleDatabaseOperation(() async {
      final entities = await _database.searchSubscriptions(query);
      return entities.map(_entityToSubscription).toList();
    });
  }

  @override
  Future<List<Subscription>> getUpcomingSubscriptions({int daysAhead = 7}) async {
    return handleDatabaseOperation(() async {
      final now = DateTime.now();
      final futureDate = now.add(Duration(days: daysAhead));
      
      final entities = await _database.getUpcomingSubscriptions(now, futureDate);
      return entities.map(_entityToSubscription).toList();
    });
  }

  @override
  Future<List<Subscription>> getExpiredSubscriptions() async {
    return handleDatabaseOperation(() async {
      final subscriptions = await getAllSubscriptions();
      return subscriptions.where((s) => s.daysUntilPayment < 0).toList();
    });
  }

  @override
  Future<List<Subscription>> getSubscriptionsByType(String type) async {
    return handleDatabaseOperation(() async {
      final subscriptions = await getAllSubscriptions();
      return subscriptions.where((s) => s.type == type).toList();
    });
  }

  /// 清除相关缓存
  Future<void> _invalidateCache() async {
    await HiveService.deleteCache(_allSubscriptionsCacheKey);
    // 清除单个订阅缓存比较困难，简单起见清除所有缓存
    // 在实际应用中可以维护一个缓存键列表
  }

  /// 将数据库实体转换为订阅模型
  Subscription _entityToSubscription(SubscriptionEntity entity) {
    return Subscription(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      type: entity.type,
      price: entity.price,
      currency: entity.currency,
      billingCycle: entity.billingCycle,
      nextPaymentDate: entity.nextPaymentDate,
      autoRenewal: entity.autoRenewal,
      notes: entity.notes,
    );
  }

  /// 将订阅模型转换为数据库实体
  SubscriptionsCompanion _subscriptionToEntity(Subscription subscription) {
    return SubscriptionsCompanion.insert(
      id: subscription.id,
      name: subscription.name,
      icon: Value(subscription.icon),
      type: subscription.type,
      price: subscription.price,
      currency: Value(subscription.currency),
      billingCycle: subscription.billingCycle,
      nextPaymentDate: subscription.nextPaymentDate,
      autoRenewal: Value(subscription.autoRenewal),
      notes: Value(subscription.notes),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// 将订阅模型转换为JSON
  Map<String, dynamic> _subscriptionToJson(Subscription subscription) {
    return subscription.toMap();
  }

  /// 从JSON创建订阅模型
  Subscription _subscriptionFromJson(Map<String, dynamic> json) {
    return Subscription.fromMap(json);
  }
}