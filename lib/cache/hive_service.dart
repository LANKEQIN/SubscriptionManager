import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cached_data.dart';

/// Hive缓存服务
/// 提供高性能的本地缓存功能
class HiveService {
  static late Box<CachedData> _cacheBox;
  static late Box<String> _userPrefsBox;
  
  /// 初始化Hive数据库
  static Future<void> initHive() async {
    await Hive.initFlutter();
    
    // 注册适配器
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CachedDataAdapter());
    }
    
    // 打开Box
    _cacheBox = await Hive.openBox<CachedData>('cache');
    _userPrefsBox = await Hive.openBox<String>('user_preferences');
  }

  /// 设置缓存
  /// [key] 缓存键
  /// [value] 缓存值（JSON字符串）
  /// [expiry] 过期时间（可选）
  static Future<void> setCache(
    String key, 
    String value, 
    {Duration? expiry}
  ) async {
    try {
      final cachedData = CachedData(
        key: key,
        value: value,
        createdAt: DateTime.now(),
        expiryDuration: expiry,
      );
      await _cacheBox.put(key, cachedData);
    } catch (e) {
      debugPrint('设置缓存失败: $e');
    }
  }

  /// 获取缓存
  /// [key] 缓存键
  /// 返回缓存值，如果不存在或已过期则返回null
  static String? getCache(String key) {
    try {
      final cached = _cacheBox.get(key);
      if (cached == null || cached.isExpired) {
        if (cached?.isExpired == true) {
          _cacheBox.delete(key); // 删除过期缓存
        }
        return null;
      }
      return cached.value;
    } catch (e) {
      debugPrint('获取缓存失败: $e');
      return null;
    }
  }

  /// 删除特定缓存
  static Future<void> deleteCache(String key) async {
    try {
      await _cacheBox.delete(key);
    } catch (e) {
      debugPrint('删除缓存失败: $e');
    }
  }

  /// 清理过期缓存
  static Future<void> cleanExpiredCache() async {
    try {
      final keysToDelete = <String>[];
      for (final cached in _cacheBox.values) {
        if (cached.isExpired) {
          keysToDelete.add(cached.key);
        }
      }
      await _cacheBox.deleteAll(keysToDelete);
      debugPrint('清理了 ${keysToDelete.length} 个过期缓存');
    } catch (e) {
      debugPrint('清理过期缓存失败: $e');
    }
  }

  /// 清除所有缓存
  static Future<void> clearAllCache() async {
    try {
      await _cacheBox.clear();
    } catch (e) {
      debugPrint('清除所有缓存失败: $e');
    }
  }

  /// 设置用户偏好设置
  static Future<void> setUserPreference(String key, String value) async {
    try {
      await _userPrefsBox.put(key, value);
    } catch (e) {
      debugPrint('设置用户偏好失败: $e');
    }
  }

  /// 获取用户偏好设置
  static String? getUserPreference(String key) {
    try {
      return _userPrefsBox.get(key);
    } catch (e) {
      debugPrint('获取用户偏好失败: $e');
      return null;
    }
  }

  /// 删除用户偏好设置
  static Future<void> deleteUserPreference(String key) async {
    try {
      await _userPrefsBox.delete(key);
    } catch (e) {
      debugPrint('删除用户偏好失败: $e');
    }
  }

  /// 缓存JSON对象
  static Future<void> setCacheObject<T>(
    String key, 
    T object,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> Function(T) toJson,
    {Duration? expiry}
  ) async {
    try {
      final jsonString = json.encode(toJson(object));
      await setCache(key, jsonString, expiry: expiry);
    } catch (e) {
      debugPrint('缓存对象失败: $e');
    }
  }

  /// 获取缓存的JSON对象
  static T? getCacheObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final jsonString = getCache(key);
      if (jsonString == null) return null;
      
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      return fromJson(jsonMap);
    } catch (e) {
      debugPrint('获取缓存对象失败: $e');
      return null;
    }
  }

  /// 缓存列表对象
  static Future<void> setCacheList<T>(
    String key, 
    List<T> list,
    Map<String, dynamic> Function(T) toJson,
    {Duration? expiry}
  ) async {
    try {
      final jsonList = list.map(toJson).toList();
      final jsonString = json.encode(jsonList);
      await setCache(key, jsonString, expiry: expiry);
    } catch (e) {
      debugPrint('缓存列表失败: $e');
    }
  }

  /// 获取缓存的列表对象
  static List<T>? getCacheList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final jsonString = getCache(key);
      if (jsonString == null) return null;
      
      final jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('获取缓存列表失败: $e');
      return null;
    }
  }

  /// 获取缓存统计信息
  static Map<String, dynamic> getCacheStats() {
    return {
      'total_items': _cacheBox.length,
      'expired_items': _cacheBox.values.where((cache) => cache.isExpired).length,
      'user_prefs_items': _userPrefsBox.length,
    };
  }

  /// 关闭Hive数据库
  static Future<void> closeHive() async {
    try {
      await _cacheBox.close();
      await _userPrefsBox.close();
    } catch (e) {
      debugPrint('关闭Hive失败: $e');
    }
  }
}

/// 缓存策略定义
class CachePolicy {
  /// 短期缓存：5分钟
  static const Duration shortTerm = Duration(minutes: 5);
  
  /// 中期缓存：1小时
  static const Duration mediumTerm = Duration(hours: 1);
  
  /// 长期缓存：1天
  static const Duration longTerm = Duration(days: 1);
  
  /// 根据数据类型获取缓存时长
  static Duration getCacheDuration(String dataType) {
    switch (dataType) {
      case 'subscriptions':
        return shortTerm;
      case 'statistics':
        return mediumTerm;
      case 'user_preferences':
        return longTerm;
      case 'monthly_histories':
        return mediumTerm;
      default:
        return shortTerm;
    }
  }
}