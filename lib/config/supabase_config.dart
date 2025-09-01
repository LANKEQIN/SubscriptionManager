import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Supabase配置类
/// 
/// 管理Supabase客户端的初始化和配置
class SupabaseConfig {
  // 从环境变量读取配置，如果没有则使用默认值（仅用于开发）
  static String get supabaseUrl => 
      dotenv.env['SUPABASE_URL'] ?? 
      (kDebugMode ? 'https://your-project.supabase.co' : throw Exception('SUPABASE_URL not configured'));
  
  static String get supabaseAnonKey => 
      dotenv.env['SUPABASE_ANON_KEY'] ?? 
      (kDebugMode ? 'your-anon-key-here' : throw Exception('SUPABASE_ANON_KEY not configured'));
  
  /// 初始化Supabase客户端
  /// 
  /// 应在应用启动时调用此方法
  static Future<void> initialize() async {
    // 首先加载环境变量
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      if (kDebugMode) {
        debugPrint('警告: 无法加载 .env 文件: $e');
        debugPrint('请确保创建 .env 文件并配置 Supabase 信息');
      }
    }
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: kDebugMode, // 开发环境启用调试
    );
  }
  
  /// 获取Supabase客户端实例
  static SupabaseClient get client => Supabase.instance.client;
  
  /// 获取当前用户
  static User? get currentUser => client.auth.currentUser;
  
  /// 检查用户是否已登录
  static bool get isLoggedIn => currentUser != null;
  
  /// 监听认证状态变化
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}