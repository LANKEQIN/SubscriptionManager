import 'package:flutter/foundation.dart';

/// 数据异常类
/// 用于处理仓储层的各种数据操作异常
class DataException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;

  DataException(this.message, this.code, [this.originalError]);

  @override
  String toString() => 'DataException($code): $message';
}

/// 错误处理混入类
/// 为仓储层提供统一的错误处理机制
mixin ErrorHandler {
  /// 处理数据库操作
  /// 包装数据库操作并转换异常为用户友好的错误信息
  Future<T> handleDatabaseOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on Exception catch (e) {
      // 根据异常类型返回不同的错误
      if (e.toString().contains('sqlite')) {
        throw DataException('数据库操作失败', 'DB_ERROR', e);
      } else if (e.toString().contains('FormatException')) {
        throw DataException('数据格式错误', 'FORMAT_ERROR', e);
      } else if (e.toString().contains('NetworkException')) {
        throw DataException('网络连接失败', 'NETWORK_ERROR', e);
      } else {
        throw DataException('操作失败: ${e.toString()}', 'UNKNOWN_ERROR', e);
      }
    } catch (e) {
      throw DataException('未知错误: ${e.toString()}', 'UNKNOWN_ERROR', e);
    }
  }

  /// 处理缓存操作
  /// 缓存操作失败不应该影响主要功能，只记录错误
  Future<T?> handleCacheOperation<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (e) {
      debugPrint('缓存操作失败: $e');
      return null;
    }
  }

  /// 处理异步操作并提供重试机制
  Future<T> handleWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(milliseconds: 500),
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        
        // 指数退避策略
        await Future.delayed(delay * attempts);
      }
    }
    
    throw DataException('操作重试失败', 'RETRY_FAILED');
  }
}