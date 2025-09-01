import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../models/sync_types.dart';

/// 认证页面
/// 
/// 提供用户登录和注册功能
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // 表单控制器
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _displayNameController = TextEditingController();
  
  // 状态管理
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);
    final networkStatus = ref.watch(connectivityServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('账户登录'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '登录'),
            Tab(text: '注册'),
          ],
        ),
      ),
      body: authState.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在处理...'),
            ],
          ),
        ),
        error: (error, _) => _buildErrorView(error.toString()),
        data: (user) => user != null 
            ? _buildSuccessView(user.email ?? '用户')
            : _buildAuthForm(networkStatus),
      ),
    );
  }

  /// 构建认证表单
  Widget _buildAuthForm(NetworkStatus networkStatus) {
    return Column(
      children: [
        // 网络状态指示器
        if (networkStatus == NetworkStatus.offline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade100,
            child: Row(
              children: [
                Icon(Icons.cloud_off, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  '当前离线，请检查网络连接',
                  style: TextStyle(color: Colors.orange.shade700),
                ),
              ],
            ),
          ),
        
        // 表单内容
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLoginForm(),
              _buildSignUpForm(),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建登录表单
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            
            // 欢迎文本
            Text(
              '欢迎回来',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '登录您的账户以同步数据',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 48),
            
            // 邮箱输入框
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '邮箱地址',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _validateEmail,
              enabled: !ref.watch(authServiceProvider).isLoading,
            ),
            
            const SizedBox(height: 16),
            
            // 密码输入框
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: '密码',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validatePassword,
              enabled: !ref.watch(authServiceProvider).isLoading,
            ),
            
            const SizedBox(height: 16),
            
            // 记住我和忘记密码
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('记住我'),
                const Spacer(),
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: const Text('忘记密码？'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // 登录按钮
            ElevatedButton(
              onPressed: ref.watch(authServiceProvider).isLoading
                  ? null
                  : _handleLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('登录'),
            ),
            
            const SizedBox(height: 16),
            
            // 跳过登录按钮
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('暂时跳过'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建注册表单
  Widget _buildSignUpForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            
            // 欢迎文本
            Text(
              '创建账户',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '注册账户以享受云端同步服务',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // 显示名称输入框
            TextFormField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: '显示名称（可选）',
                prefixIcon: Icon(Icons.person_outlined),
                border: OutlineInputBorder(),
              ),
              enabled: !ref.watch(authServiceProvider).isLoading,
            ),
            
            const SizedBox(height: 16),
            
            // 邮箱输入框
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '邮箱地址',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _validateEmail,
              enabled: !ref.watch(authServiceProvider).isLoading,
            ),
            
            const SizedBox(height: 16),
            
            // 密码输入框
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: '密码',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validatePassword,
              enabled: !ref.watch(authServiceProvider).isLoading,
            ),
            
            const SizedBox(height: 16),
            
            // 确认密码输入框
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                labelText: '确认密码',
                prefixIcon: const Icon(Icons.lock_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validateConfirmPassword,
              enabled: !ref.watch(authServiceProvider).isLoading,
            ),
            
            const SizedBox(height: 24),
            
            // 注册按钮
            ElevatedButton(
              onPressed: ref.watch(authServiceProvider).isLoading
                  ? null
                  : _handleSignUp,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('注册'),
            ),
            
            const SizedBox(height: 16),
            
            // 跳过注册按钮
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('暂时跳过'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建错误视图
  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '登录失败',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 重置状态，重新显示表单
                _clearForm();
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建成功视图
  Widget _buildSuccessView(String userEmail) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              '登录成功',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '欢迎回来，$userEmail',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('继续'),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理登录
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = ref.read(authServiceProvider.notifier);
    final result = await authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!result.success && mounted) {
      _showErrorSnackBar(result.error ?? '登录失败');
    }
  }

  /// 处理注册
  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = ref.read(authServiceProvider.notifier);
    final result = await authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      displayName: _displayNameController.text.trim().isEmpty
          ? null
          : _displayNameController.text.trim(),
    );

    if (result.success) {
      if (mounted) {
        _showSuccessSnackBar('注册成功！请检查邮箱以验证账户。');
      }
    } else {
      if (mounted) {
        _showErrorSnackBar(result.error ?? '注册失败');
      }
    }
  }

  /// 显示忘记密码对话框
  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('请输入您的邮箱地址，我们将发送重置密码的链接。'),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '邮箱地址',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                final authService = ref.read(authServiceProvider.notifier);
                final success = await authService.resetPassword(email);
                
                if (context.mounted) {
                  Navigator.pop(context);
                  
                  if (success) {
                    _showSuccessSnackBar('重置密码邮件已发送');
                  } else {
                    _showErrorSnackBar('发送重置邮件失败');
                  }
                }
              }
            },
            child: const Text('发送'),
          ),
        ],
      ),
    );
  }

  /// 清理表单
  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _displayNameController.clear();
    setState(() {
      _isPasswordVisible = false;
      _isConfirmPasswordVisible = false;
      _rememberMe = false;
    });
  }

  /// 验证邮箱
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱地址';
    }
    
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    
    return null;
  }

  /// 验证密码
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    
    if (value.length < 6) {
      return '密码长度至少为6位';
    }
    
    return null;
  }

  /// 验证确认密码
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    
    if (value != _passwordController.text) {
      return '两次输入的密码不一致';
    }
    
    return null;
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// 显示成功提示
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}