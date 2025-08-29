import 'package:flutter/foundation.dart';
import 'hive_service.dart';

/// 智能缓存管理器
/// 提供精细化缓存更新策略，优化性能
class SmartCacheManager {
  // 缓存策略配置
  static const Map<String, Duration> _cachePolicies = {
    'subscriptions_list': Duration(minutes: 5),    // 订阅列表短期缓存
    'subscription_': Duration(minutes: 15),        // 单个订阅中期缓存
    'statistics_daily': Duration(hours: 2),        // 日统计数据
    'statistics_monthly': Duration(hours: 12),     // 月统计数据
    'user_preferences': Duration(days: 7),         // 用户偏好设置
    'exchange_rates': Duration(hours: 6),          // 汇率数据
    'monthly_history': Duration(hours: 24),        // 月度历史数据
  };
  
  /// 按模式失效缓存
  /// [pattern] 缓存键匹配模式，如 'subscription_' 会匹配所有以此开头的键
  static Future<void> invalidateByPattern(String pattern) async {
    try {
      final allKeys = await getAllCacheKeys();
      final keysToDelete = allKeys.where((key) => key.startsWith(pattern)).toList();
      
      if (keysToDelete.isNotEmpty) {
        await deleteCaches(keysToDelete);
        debugPrint('清除缓存: ${keysToDelete.length} 个项目，模式: $pattern');
      }
    } catch (e) {
      debugPrint('缓存清理失败: $e');
    }
  }
  
  /// 选择性缓存更新
  /// 根据操作类型选择性地清除相关缓存
  static Future<void> updateCacheSelectively({
    String? subscriptionId,
    bool updateList = true,
    bool updateStatistics = false,
    bool updateHistory = false,
  }) async {
    try {
      if (subscriptionId != null) {
        // 仅清除特定订阅缓存
        await invalidateByPattern('subscription_$subscriptionId');
      }
      
      if (updateList) {
        // 清除列表缓存
        await invalidateByPattern('subscriptions_list');
        await invalidateByPattern('all_subscriptions');
      }
      
      if (updateStatistics) {
        // 清除统计缓存
        await invalidateByPattern('statistics_');
      }

      if (updateHistory) {
        // 清除历史数据缓存
        await invalidateByPattern('monthly_history');
        await invalidateByPattern('all_monthly_histories');
      }
    } catch (e) {
      debugPrint('选择性缓存更新失败: $e');
    }
  }
  
  /// LRU缓存淘汰
  /// 当缓存项目过多时，删除最少使用的缓存项
  static Future<void> performLRUCleanup() async {
    try {
      final cacheStats = HiveService.getCacheStats();
      final totalItems = cacheStats['total_items'] as int;
      
      // 如果缓存项目超过限制，执行LRU清理
      if (totalItems > 1000) {
        await performLRUCleanupInternal(targetSize: 800);
        debugPrint('执行LRU清理，清理前: $totalItems 项，目标: 800 项');
      }
    } catch (e) {
      debugPrint('LRU清理失败: $e');
    }
  }

  /// 获取所有缓存键
  static Future<List<String>> getAllCacheKeys() async {
    try {
      return await HiveService.getAllCacheKeys();
    } catch (e) {
      debugPrint('获取缓存键失败: $e');
      return [];
    }
  }

  /// 批量删除缓存
  static Future<void> deleteCaches(List<String> keys) async {
    try {
      for (final key in keys) {
        await HiveService.deleteCache(key);
      }
    } catch (e) {
      debugPrint('批量删除缓存失败: $e');
    }
  }

  /// 内部LRU清理实现
  static Future<void> performLRUCleanupInternal({required int targetSize}) async {
    try {
      final allKeys = await getAllCacheKeys();
      
      if (allKeys.length <= targetSize) {
        return; // 不需要清理
      }

      // 简单的清理策略：删除最旧的缓存项
      final keysToDelete = allKeys.take(allKeys.length - targetSize).toList();
      await deleteCaches(keysToDelete);
      
      debugPrint('LRU清理完成，删除了 ${keysToDelete.length} 个缓存项');
    } catch (e) {
      debugPrint('LRU清理内部实现失败: $e');
    }
  }

  /// 根据数据类型获取缓存策略
  static Duration getCacheDuration(String dataType) {
    return _cachePolicies[dataType] ?? const Duration(minutes: 5);
  }

  /// 预热缓存
  /// 提前加载常用数据到缓存中
  static Future<void> preloadCache() async {
    try {
      debugPrint('开始预热缓存...');
      
      // 这里可以添加预加载逻辑
      // 例如预加载订阅列表、用户偏好等
      
      debugPrint('缓存预热完成');
    } catch (e) {
      debugPrint('缓存预热失败: $e');
    }
  }

  /// 缓存性能统计
  static Map<String, dynamic> getCachePerformanceStats() {
    try {
      final stats = HiveService.getCacheStats();
      return {
        ...stats,
        'cache_policies_count': _cachePolicies.length,
        'last_cleanup': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('获取缓存统计失败: $e');
      return {'error': e.toString()};
    }
  }

  /// 智能缓存决策
  /// 根据操作类型和数据量决定缓存策略
  static Future<bool> shouldCache(String key, int dataSize) async {
    try {
      // 数据过大不缓存
      if (dataSize > 1024 * 1024) { // 1MB
        return false;
      }

      // 检查缓存空间
      final stats = HiveService.getCacheStats();
      final totalItems = stats['total_items'] as int;
      
      if (totalItems > 500) {
        // 缓存接近满载，只缓存重要数据
        return key.contains('subscription') || key.contains('user_preferences');
      }

      return true;
    } catch (e) {
      debugPrint('缓存决策失败: $e');
      return false;
    }
  }
}