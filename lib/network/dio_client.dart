import 'package:dio/dio.dart';
import '../config/supabase_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/monitoring_interceptor.dart';

/// Dio HTTP 客户端配置和管理类
/// 提供统一的 HTTP 客户端实例，支持拦截器和高级功能
class DioClient {
  static Dio? _instance;
  
  /// 获取 Dio 客户端单例实例
  static Dio get instance {
    _instance ??= _createDio();
    return _instance!;
  }
  
  /// 重置客户端实例（用于测试或重新配置）
  static void reset() {
    _instance = null;
  }
  
  /// 创建和配置 Dio 客户端
  static Dio _createDio() {
    final dio = Dio(BaseOptions(
      baseUrl: SupabaseConfig.supabaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'apikey': SupabaseConfig.supabaseAnonKey,
        'Prefer': 'return=representation',
      },
    ));
    
    // 添加拦截器（顺序很重要）
    dio.interceptors.addAll([
      MonitoringInterceptor(), // 监控拦截器
      LoggingInterceptor(),    // 日志拦截器
      AuthInterceptor(),       // 认证拦截器
      RetryInterceptor(),      // 重试拦截器
      ErrorInterceptor(),      // 错误处理拦截器
    ]);
    
    return dio;
  }
  
  /// 创建用于测试的 Dio 客户端
  static Dio createTestClient({
    String? baseUrl,
    Duration? connectTimeout,
    List<Interceptor>? interceptors,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? 'http://localhost:3000',
      connectTimeout: connectTimeout ?? const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    
    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }
    
    return dio;
  }
}