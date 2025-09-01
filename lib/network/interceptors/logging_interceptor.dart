import 'package:dio/dio.dart';
import '../../utils/app_logger.dart';

/// 日志拦截器
/// 记录所有 HTTP 请求和响应的详细信息
class LoggingInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final bool logHeaders;
  final bool logBody;
  
  LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logHeaders = false,
    this.logBody = true,
  });
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      AppLogger.network('REQUEST', method: options.method, url: options.uri.toString());
      
      if (logHeaders && options.headers.isNotEmpty) {
        AppLogger.d('📋 Headers:');
        options.headers.forEach((key, value) {
          // 隐藏敏感信息
          if (_isSensitiveHeader(key)) {
            AppLogger.d('   $key: ***');
          } else {
            AppLogger.d('   $key: $value');
          }
        });
      }
      
      if (logBody && options.data != null) {
        AppLogger.d('📝 Body: ${_formatData(options.data)}');
      }
      
      if (options.queryParameters.isNotEmpty) {
        AppLogger.d('🔍 Query Parameters: ${options.queryParameters}');
      }
    }
    
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      AppLogger.network('RESPONSE', url: response.requestOptions.uri.toString(), statusCode: response.statusCode);
      
      if (logHeaders && response.headers.map.isNotEmpty) {
        AppLogger.d('📋 Response Headers:');
        response.headers.forEach((key, values) {
          AppLogger.d('   $key: ${values.join(', ')}');
        });
      }
      
      if (logBody && response.data != null) {
        AppLogger.d('📄 Response Data: ${_formatData(response.data)}');
      }
    }
    
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      AppLogger.e('ERROR[${err.response?.statusCode ?? 'NO_STATUS'}] => ${err.requestOptions.uri}');
      AppLogger.e('💥 Error Type: ${err.type}');
      AppLogger.e('💬 Error Message: ${err.message}');
      
      if (err.response?.data != null) {
        AppLogger.e('📄 Error Response: ${_formatData(err.response!.data)}');
      }
      
      // 打印堆栈跟踪（仅在调试模式下）
      final stackTrace = err.stackTrace;
      AppLogger.e('📚 Stack Trace:', err, stackTrace);
    }
    
    handler.next(err);
  }
  
  /// 格式化数据用于日志输出
  String _formatData(dynamic data) {
    if (data is String) {
      return data.length > 500 ? '${data.substring(0, 500)}...' : data;
    } else if (data is Map || data is List) {
      final str = data.toString();
      return str.length > 500 ? '${str.substring(0, 500)}...' : str;
    }
    return data.toString();
  }
  
  /// 检查是否为敏感的请求头
  bool _isSensitiveHeader(String key) {
    final sensitiveHeaders = [
      'authorization',
      'apikey',
      'x-api-key',
      'cookie',
      'set-cookie',
    ];
    return sensitiveHeaders.contains(key.toLowerCase());
  }
}