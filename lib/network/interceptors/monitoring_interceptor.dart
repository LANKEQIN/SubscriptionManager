import 'package:dio/dio.dart';
import '../monitoring/network_monitor_service.dart';

/// 监控拦截器
/// 集成网络监控服务，记录请求性能和错误统计
class MonitoringInterceptor extends Interceptor {
  final NetworkMonitorService _monitor = NetworkMonitorService();
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 记录请求开始
    final requestId = _monitor.startRequest(
      options.uri.toString(),
      options.method,
    );
    
    // 将请求ID保存到请求选项中
    options.extra['monitoring_request_id'] = requestId;
    
    handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final requestId = response.requestOptions.extra['monitoring_request_id'] as String?;
    
    if (requestId != null) {
      // 记录请求成功
      _monitor.recordRequestSuccess(
        requestId,
        response.statusCode ?? 200,
        _calculateResponseSize(response),
      );
    }
    
    handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = err.requestOptions.extra['monitoring_request_id'] as String?;
    
    if (requestId != null) {
      // 记录请求失败
      _monitor.recordRequestFailure(
        requestId,
        _getErrorType(err),
        err.message ?? 'Unknown error',
        err.response?.statusCode,
      );
    }
    
    handler.next(err);
  }
  
  /// 计算响应大小
  int _calculateResponseSize(Response response) {
    if (response.data == null) return 0;
    
    if (response.data is String) {
      return (response.data as String).length;
    } else if (response.data is List<int>) {
      return (response.data as List<int>).length;
    } else if (response.data is Map || response.data is List) {
      return response.data.toString().length;
    }
    
    return 0;
  }
  
  /// 获取错误类型
  String _getErrorType(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'CONNECTION_TIMEOUT';
      case DioExceptionType.sendTimeout:
        return 'SEND_TIMEOUT';
      case DioExceptionType.receiveTimeout:
        return 'RECEIVE_TIMEOUT';
      case DioExceptionType.badResponse:
        return 'BAD_RESPONSE_${error.response?.statusCode ?? "UNKNOWN"}';
      case DioExceptionType.cancel:
        return 'CANCELLED';
      case DioExceptionType.unknown:
        return 'UNKNOWN';
      default:
        return 'OTHER';
    }
  }
}