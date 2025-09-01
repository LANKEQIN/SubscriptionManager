import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utils/app_logger.dart';

/// 认证拦截器
/// 自动为请求添加用户认证令牌
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 获取当前用户的访问令牌
    final session = Supabase.instance.client.auth.currentSession;
    if (session?.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${session!.accessToken}';
    }
    
    handler.next(options);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 处理认证相关错误
    if (err.response?.statusCode == 401) {
      // 可以在这里实现自动刷新令牌的逻辑
      _handleUnauthorized(err);
    }
    
    handler.next(err);
  }
  
  void _handleUnauthorized(DioException err) {
    // 这里可以实现令牌刷新逻辑
    // 或者触发重新登录流程
    AppLogger.w('认证失败，需要重新登录');
  }
}