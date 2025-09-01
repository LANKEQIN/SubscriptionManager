import 'package:dio/dio.dart' as dio;
import 'package:graphql_flutter/graphql_flutter.dart' hide NetworkException;
import 'network_exception.dart';

/// 统一的网络错误处理器
/// 将不同来源的网络错误转换为统一的错误格式
class NetworkErrorHandler {
  /// 处理 Dio 错误
  static AppNetworkException handleDioError(dio.DioException error) {
    switch (error.type) {
      case dio.DioExceptionType.connectionTimeout:
        return AppNetworkException(
          message: '连接超时，请检查网络连接',
          type: NetworkErrorType.timeout,
          originalException: error,
          uri: error.requestOptions.uri,
        );
      case dio.DioExceptionType.sendTimeout:
        return AppNetworkException(
          message: '发送超时，请重试',
          type: NetworkErrorType.timeout,
          originalException: error,
          uri: error.requestOptions.uri,
        );
      case dio.DioExceptionType.receiveTimeout:
        return AppNetworkException(
          message: '接收超时，请重试',
          type: NetworkErrorType.timeout,
          originalException: error,
          uri: error.requestOptions.uri,
        );
      case dio.DioExceptionType.badResponse:
        return _handleResponseError(error.response!);
      case dio.DioExceptionType.cancel:
        return AppNetworkException(
          message: '请求已取消',
          type: NetworkErrorType.cancelled,
          originalException: error,
          uri: error.requestOptions.uri,
        );
      case dio.DioExceptionType.unknown:
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
  
  /// 处理 GraphQL 错误
  static AppNetworkException handleGraphQLError(OperationException error) {
    if (error.linkException != null) {
      return _handleLinkException(error.linkException!);
    }
    
    if (error.graphqlErrors.isNotEmpty) {
      return _handleGraphQLErrors(error.graphqlErrors);
    }
    
    return AppNetworkException(
      message: error.toString(),
      type: NetworkErrorType.unknown,
      originalException: error,
      uri: Uri.parse('graphql://unknown'),
    );
  }
  
  /// 处理通用异常
  static AppNetworkException handleGenericError(Exception error) {
    if (error is dio.DioException) {
      return handleDioError(error);
    }
    
    if (error is OperationException) {
      return handleGraphQLError(error);
    }
    
    if (error is AppNetworkException) {
      return error;
    }
    
    return AppNetworkException(
      message: error.toString(),
      type: NetworkErrorType.unknown,
      originalException: error,
      uri: Uri.parse('unknown://error'),
    );
  }
  
  /// 处理 HTTP 响应错误
  static AppNetworkException _handleResponseError(dio.Response response) {
    final statusCode = response.statusCode!;
    
    switch (statusCode) {
      case 400:
        return AppNetworkException(
          message: '请求参数错误',
          type: NetworkErrorType.badRequest,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 401:
        return AppNetworkException(
          message: '身份验证失败，请重新登录',
          type: NetworkErrorType.unauthorized,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 403:
        return AppNetworkException(
          message: '权限不足，无法访问该资源',
          type: NetworkErrorType.forbidden,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 404:
        return AppNetworkException(
          message: '请求的资源不存在',
          type: NetworkErrorType.notFound,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 409:
        return AppNetworkException(
          message: '数据冲突，请刷新后重试',
          type: NetworkErrorType.conflict,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 422:
        return AppNetworkException(
          message: '数据验证失败',
          type: NetworkErrorType.validation,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 429:
        return AppNetworkException(
          message: '请求过于频繁，请稍后重试',
          type: NetworkErrorType.rateLimited,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 500:
        return AppNetworkException(
          message: '服务器内部错误',
          type: NetworkErrorType.serverError,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 502:
        return AppNetworkException(
          message: '网关错误',
          type: NetworkErrorType.serverError,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      case 503:
        return AppNetworkException(
          message: '服务不可用，请稍后重试',
          type: NetworkErrorType.serverError,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
        
      default:
        return AppNetworkException(
          message: 'HTTP $statusCode: ${response.statusMessage ?? "未知错误"}',
          type: NetworkErrorType.unknown,
          statusCode: statusCode,
          originalException: dio.DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: dio.DioExceptionType.badResponse,
          ),
          uri: response.requestOptions.uri,
        );
    }
  }
  
  /// 处理 GraphQL 链接异常
  static AppNetworkException _handleLinkException(LinkException linkException) {
    if (linkException is HttpLinkServerException) {
      return AppNetworkException(
        message: 'GraphQL 服务器错误：${linkException.response.statusCode}',
        type: NetworkErrorType.serverError,
        statusCode: linkException.response.statusCode,
        originalException: linkException,
        uri: Uri.parse('graphql://server'),
      );
    }
    
    if (linkException is NetworkException) {
      return AppNetworkException(
        message: 'GraphQL 网络错误：${linkException.toString()}',
        type: NetworkErrorType.connectivity,
        originalException: linkException,
        uri: Uri.parse('graphql://network'),
      );
    }
    
    return AppNetworkException(
      message: 'GraphQL 链接错误：${linkException.toString()}',
      type: NetworkErrorType.unknown,
      originalException: linkException,
      uri: Uri.parse('graphql://link'),
    );
  }
  
  /// 处理 GraphQL 错误列表
  static AppNetworkException _handleGraphQLErrors(List<GraphQLError> errors) {
    final firstError = errors.first;
    
    // 检查是否为权限错误
    if (firstError.message.contains('permission') || 
        firstError.message.contains('unauthorized')) {
      return AppNetworkException(
        message: '权限不足，无法执行此操作',
        type: NetworkErrorType.forbidden,
        originalException: OperationException(graphqlErrors: errors),
        uri: Uri.parse('graphql://permission'),
      );
    }
    
    // 检查是否为验证错误
    if (firstError.message.contains('validation') ||
        firstError.message.contains('invalid')) {
      return AppNetworkException(
        message: '数据验证失败：${firstError.message}',
        type: NetworkErrorType.validation,
        originalException: OperationException(graphqlErrors: errors),
        uri: Uri.parse('graphql://validation'),
      );
    }
    
    return AppNetworkException(
      message: 'GraphQL 错误：${firstError.message}',
      type: NetworkErrorType.unknown,
      originalException: OperationException(graphqlErrors: errors),
      uri: Uri.parse('graphql://error'),
    );
  }
}