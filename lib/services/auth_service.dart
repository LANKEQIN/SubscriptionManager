import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../config/supabase_config.dart';
import '../models/user_profile.dart';
import '../repositories/error_handler.dart';

part 'auth_service.g.dart';

/// 认证异常类
class AuthException implements Exception {
  final String message;
  final String? code;
  
  AuthException(this.message, [this.code]);
  
  @override
  String toString() => 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// 认证结果类
class AuthResult {
  final User? user;
  final String? error;
  final bool success;
  
  AuthResult.success(this.user) : error = null, success = true;
  AuthResult.error(this.error) : user = null, success = false;
}

/// 认证服务
/// 
/// 管理用户的注册、登录、登出等认证功能
@riverpod
class AuthService extends _$AuthService with ErrorHandler {
  @override
  AsyncValue<User?> build() {
    // 监听认证状态变化
    _listenToAuthChanges();
    
    // 返回当前用户状态
    final currentUser = SupabaseConfig.currentUser;
    return AsyncValue.data(currentUser);
  }
  
  /// 监听认证状态变化
  void _listenToAuthChanges() {
    SupabaseConfig.authStateChanges.listen((AuthState authState) {
      state = AsyncValue.data(authState.session?.user);
    });
  }
  
  /// 用户注册
  /// 
  /// [email] 邮箱地址
  /// [password] 密码
  /// [displayName] 显示名称（可选）
  Future<AuthResult> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // 验证输入
      _validateEmail(email);
      _validatePassword(password);
      
      // 调用Supabase注册API
      final response = await SupabaseConfig.client.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
      
      if (response.user != null) {
        // 注册成功，创建用户配置
        await _createUserProfile(response.user!, displayName);
        state = AsyncValue.data(response.user);
        return AuthResult.success(response.user);
      } else {
        const error = '注册失败，请稍后重试';
        state = AsyncValue.error(AuthException(error), StackTrace.current);
        return AuthResult.error(error);
      }
    } on AuthException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return AuthResult.error(e.message);
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = AsyncValue.error(AuthException(error), StackTrace.current);
      return AuthResult.error(error);
    }
  }
  
  /// 用户登录
  /// 
  /// [email] 邮箱地址
  /// [password] 密码
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      // 验证输入
      _validateEmail(email);
      _validatePassword(password);
      
      // 调用Supabase登录API
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user != null) {
        state = AsyncValue.data(response.user);
        
        // 触发数据同步
        // ref.read(syncServiceProvider.notifier).syncAfterAuth();
        
        return AuthResult.success(response.user);
      } else {
        const error = '登录失败，请检查邮箱和密码';
        state = AsyncValue.error(AuthException(error), StackTrace.current);
        return AuthResult.error(error);
      }
    } on AuthException catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return AuthResult.error(e.message);
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = AsyncValue.error(AuthException(error), StackTrace.current);
      return AuthResult.error(error);
    }
  }
  
  /// 用户登出
  Future<bool> signOut() async {
    try {
      await SupabaseConfig.client.auth.signOut();
      state = const AsyncValue.data(null);
      
      // 清理本地同步状态
      // ref.read(syncServiceProvider.notifier).clearSyncState();
      
      return true;
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = AsyncValue.error(AuthException(error), StackTrace.current);
      return false;
    }
  }
  
  /// 重置密码
  /// 
  /// [email] 邮箱地址
  Future<bool> resetPassword(String email) async {
    try {
      _validateEmail(email);
      
      await SupabaseConfig.client.auth.resetPasswordForEmail(email);
      return true;
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = AsyncValue.error(AuthException(error), StackTrace.current);
      return false;
    }
  }
  
  /// 更新密码
  /// 
  /// [newPassword] 新密码
  Future<bool> updatePassword(String newPassword) async {
    try {
      _validatePassword(newPassword);
      
      final response = await SupabaseConfig.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      
      return response.user != null;
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = AsyncValue.error(AuthException(error), StackTrace.current);
      return false;
    }
  }
  
  /// 检查用户是否已登录
  bool get isLoggedIn => state.value != null;
  
  /// 获取当前用户
  User? get currentUser => state.value;
  
  /// 获取当前用户ID
  String? get currentUserId => state.value?.id;
  
  /// 创建用户配置
  Future<void> _createUserProfile(User user, String? displayName) async {
    try {
      final profile = UserProfile(
        userId: user.id,
        displayName: displayName ?? user.email?.split('@').first,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await SupabaseConfig.client
          .from('profiles')
          .insert(profile.toSupabaseJson());
    } catch (e) {
      // 创建配置失败不应该阻止注册流程
      debugPrint('创建用户配置失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 验证邮箱格式
  void _validateEmail(String email) {
    if (email.isEmpty) {
      throw AuthException('邮箱地址不能为空');
    }
    
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw AuthException('请输入有效的邮箱地址');
    }
  }
  
  /// 验证密码强度
  void _validatePassword(String password) {
    if (password.isEmpty) {
      throw AuthException('密码不能为空');
    }
    
    if (password.length < 6) {
      throw AuthException('密码长度至少为6位');
    }
    
    // 可以添加更多密码强度验证规则
    // if (!password.contains(RegExp(r'[A-Z]'))) {
    //   throw AuthException('密码必须包含至少一个大写字母');
    // }
  }
}