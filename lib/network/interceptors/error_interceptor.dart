import 'package:dio/dio.dart';
import '../error/network_exception.dart';

/// 错误处理拦截器
/// 统一处理和转换网络错误
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 将 Dio 错误转换为用户友好的错误消息
    final userFriendlyError = _convertToUserFriendlyError(err);
    
    // 创建新的错误对象，包含用户友好的消息
    final enhancedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: userFriendlyError,
      stackTrace: err.stackTrace,
      message: userFriendlyError.message,
    );
    
    handler.next(enhancedError);
  }
  
  /// 将 DioException 转换为用户友好的错误
  AppNetworkException _convertToUserFriendlyError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return AppNetworkException(
          message: '连接超时，请检查网络连接',
          type: NetworkErrorType.timeout,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case DioExceptionType.sendTimeout:
        return AppNetworkException(
          message: '发送超时，请重试',
          type: NetworkErrorType.timeout,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case DioExceptionType.receiveTimeout:
        return AppNetworkException(
          message: '接收超时，请重试',
          type: NetworkErrorType.timeout,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
        
      case DioExceptionType.cancel:
        return AppNetworkException(
          message: '请求已取消',
          type: NetworkErrorType.cancelled,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case DioExceptionType.unknown:
        if (error.message?.contains('connection') == true) {
          return AppNetworkException(
            message: '网络连接失败，请检查网络设置',
            type: NetworkErrorType.connectivity,
            originalException: error,
            uri: error.requestOptions.uri,
          );
        }
        return AppNetworkException(
          message: '网络错误：${error.message}',
          type: NetworkErrorType.unknown,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      default:
        return AppNetworkException(
          message: '未知网络错误',
          type: NetworkErrorType.unknown,
          originalException: error,
          uri: error.requestOptions.uri,
        );
    }
  }
  
  /// 处理 HTTP 响应错误
  AppNetworkException _handleResponseError(DioException error) {
    final response = error.response!;
    final statusCode = response.statusCode!;
    
    switch (statusCode) {
      case 400:
        return AppNetworkException(
          message: '请求参数错误',
          type: NetworkErrorType.badRequest,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 401:
        return AppNetworkException(
          message: '身份验证失败，请重新登录',
          type: NetworkErrorType.unauthorized,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 403:
        return AppNetworkException(
          message: '权限不足，无法访问该资源',
          type: NetworkErrorType.forbidden,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 404:
        return AppNetworkException(
          message: '请求的资源不存在',
          type: NetworkErrorType.notFound,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 409:
        return AppNetworkException(
          message: '数据冲突，请刷新后重试',
          type: NetworkErrorType.conflict,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 422:
        return AppNetworkException(
          message: '数据验证失败',
          type: NetworkErrorType.validation,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 429:
        return AppNetworkException(
          message: '请求过于频繁，请稍后重试',
          type: NetworkErrorType.rateLimited,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 500:
        return AppNetworkException(
          message: '服务器内部错误',
          type: NetworkErrorType.serverError,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 502:
        return AppNetworkException(
          message: '网关错误',
          type: NetworkErrorType.serverError,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      case 503:
        return AppNetworkException(
          message: '服务不可用，请稍后重试',
          type: NetworkErrorType.serverError,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
        
      default:
        return AppNetworkException(
          message: 'HTTP $statusCode: ${response.statusMessage ?? "未知错误"}',
          type: NetworkErrorType.unknown,
          statusCode: statusCode,
          originalException: error,
          uri: error.requestOptions.uri,
        );
    }
  }
}