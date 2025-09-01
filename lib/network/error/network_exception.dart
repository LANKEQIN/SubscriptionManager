import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exception.freezed.dart';

/// 网络错误类型枚举
enum NetworkErrorType {
  /// 连接超时
  timeout,
  /// 请求被取消
  cancelled,
  /// 网络连接错误
  connectivity,
  /// 服务器错误 (5xx)
  serverError,
  /// 客户端错误 (4xx)
  clientError,
  /// 请求参数错误 (400)
  badRequest,
  /// 身份验证失败 (401)
  unauthorized,
  /// 权限不足 (403)
  forbidden,
  /// 资源不存在 (404)
  notFound,
  /// 数据冲突 (409)
  conflict,
  /// 数据验证失败 (422)
  validation,
  /// 请求过于频繁 (429)
  rateLimited,
  /// 未知错误
  unknown,
}

/// 网络异常类
@freezed
class NetworkException with _$NetworkException implements Exception {
  const factory NetworkException({
    required String message,
    required NetworkErrorType type,
    required Exception originalException,
    required Uri uri,
    int? statusCode,
    String? stackTrace,
    Map<String, dynamic>? responseData,
  }) = _NetworkException;
  
  /// 简化构造函数，用于向后兼容
  const factory NetworkException.simple({
    required String message,
    required NetworkErrorType type,
    Exception? originalError,
    int? statusCode,
  }) = _SimpleNetworkException;
}

/// 应用网络异常类 - 用于错误拦截器
@freezed
class AppNetworkException with _$AppNetworkException implements Exception {
  const factory AppNetworkException({
    required String message,
    required NetworkErrorType type,
    required Exception originalException,
    required Uri uri,
    int? statusCode,
    String? stackTrace,
    Map<String, dynamic>? responseData,
  }) = _AppNetworkException;
}