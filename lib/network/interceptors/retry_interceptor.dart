import 'package:dio/dio.dart';
import '../../utils/app_logger.dart';
import '../dio_client.dart';

/// 重试拦截器
/// 自动重试失败的网络请求
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;
  final List<int> retryStatusCodes;
  
  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.retryStatusCodes = const [500, 502, 503, 504],
  });
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final shouldRetry = _shouldRetry(err);
    final retryCount = err.requestOptions.extra['retryCount'] ?? 0;
    
    if (shouldRetry && retryCount < maxRetries) {
      // 增加重试计数
      err.requestOptions.extra['retryCount'] = retryCount + 1;
      
      // 计算退避延迟（指数退避）
      final delay = Duration(
        milliseconds: (retryDelay.inMilliseconds * (retryCount + 1)).round(),
      );
      
      AppLogger.w('第 ${retryCount + 1} 次重试，延迟 ${delay.inMilliseconds}ms');
      await Future.delayed(delay);
      
      try {
        // 重新发送请求
        final response = await DioClient.instance.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // 重试失败，继续原错误处理流程
        AppLogger.e('重试失败', e);
      }
    }
    
    handler.next(err);
  }
  
  /// 判断是否应该重试请求
  bool _shouldRetry(DioException error) {
    // 连接超时、接收超时、发送超时应该重试
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return true;
    }
    
    // 特定的 HTTP 状态码应该重试
    if (error.response?.statusCode != null) {
      return retryStatusCodes.contains(error.response!.statusCode);
    }
    
    // 网络连接问题应该重试
    if (error.type == DioExceptionType.unknown &&
        error.message?.contains('connection') == true) {
      return true;
    }
    
    return false;
  }
}