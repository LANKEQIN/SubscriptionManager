import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../providers/subscription_notifier.dart';
import '../constants/theme_constants.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../models/sync_types.dart';
import '../models/sync_state.dart';
import 'auth_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);
    final syncState = ref.watch(syncServiceProvider);
    final networkStatus = ref.watch(connectivityServiceProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 用户信息区域
              _buildUserSection(authState, syncState, networkStatus),
              
              const SizedBox(height: AppThemeConstants.largeSpacing),
              
              const Text(
                '设置',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppThemeConstants.largeSpacing),
              
              // 主题设置
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: ListTile(
                  title: const Text('主题设置'),
                  subtitle: const Text('选择应用主题模式'),
                  trailing: DropdownButton<ThemeMode>(
                    value: ref.watch(themeModeProviderProvider),
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('跟随系统'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('浅色'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('深色'),
                      ),
                    ],
                    onChanged: (ThemeMode? mode) {
                      if (mode != null) {
                        ref.read(subscriptionNotifierProvider.notifier).updateThemeMode(mode);
                      }
                    },
                    underline: Container(), // 移除下划线
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: AppThemeConstants.standardPadding),
              
              // 主题颜色设置
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '主题颜色',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppThemeConstants.smallSpacing),
                      const Text('选择应用主题颜色'),
                      const SizedBox(height: AppThemeConstants.standardPadding),
                      _buildThemeColorOptions(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppThemeConstants.standardPadding),
              
              // 字体大小设置
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: ListTile(
                  title: const Text('字体大小'),
                  subtitle: const Text('调整应用字体大小'),
                  trailing: DropdownButton<double>(
                    value: ref.watch(fontSizeProviderProvider),
                    items: AppThemeConstants.fontSizeOptions.map((double size) {
                      return DropdownMenuItem<double>(
                        value: size,
                        child: Text('${size.toInt()}'),
                      );
                    }).toList(),
                    onChanged: (double? size) {
                      if (size != null) {
                        ref.read(subscriptionNotifierProvider.notifier).updateFontSize(size);
                      }
                    },
                    underline: Container(), // 移除下划线
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: AppThemeConstants.largeSpacing * 1.33), // 32
              
              // 应用信息
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '应用信息',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppThemeConstants.standardPadding),
                      const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('版本'),
                        subtitle: Text('1.0.0'),
                      ),
                      const SizedBox(height: AppThemeConstants.smallSpacing),
                      ListTile(
                        leading: const Icon(Icons.star_border),
                        title: const Text('给我们评分'),
                        onTap: () {
                          // TODO: 实现评分功能
                        },
                      ),
                      const SizedBox(height: AppThemeConstants.smallSpacing),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('隐私政策'),
                        onTap: () {
                          // TODO: 实现隐私政策页面
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建用户信息区域
  Widget _buildUserSection(
    AsyncValue<dynamic> authState,
    SyncState syncState,
    NetworkStatus networkStatus,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户状态
            authState.when(
              loading: () => const ListTile(
                leading: CircularProgressIndicator(),
                title: Text('正在加载...'),
              ),
              error: (error, _) => ListTile(
                leading: Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: const Text('登录失败'),
                subtitle: Text(error.toString()),
              ),
              data: (user) => user != null
                  ? _buildLoggedInUser(user, syncState, networkStatus)
                  : _buildLoggedOutUser(),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建已登录用户信息
  Widget _buildLoggedInUser(
    dynamic user,
    SyncState syncState,
    NetworkStatus networkStatus,
  ) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              (user.email ?? '用户')[0].toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(user.email ?? '用户'),
          subtitle: Text('已登录 • ${_getNetworkStatusText(networkStatus)}'),
          trailing: PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'sync',
                child: Row(
                  children: [
                    Icon(
                      syncState.isLoading ? Icons.sync : Icons.sync_outlined,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(syncState.isLoading ? '同步中...' : '手动同步'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('登出'),
                  ],
                ),
              ),
            ],
            onSelected: _handleUserAction,
          ),
        ),
        
        // 同步状态指示器
        if (syncState.isLoading || syncState.hasError || syncState.hasPendingSync)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getSyncStatusColor(syncState).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getSyncStatusColor(syncState).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getSyncStatusIcon(syncState),
                  size: 16,
                  color: _getSyncStatusColor(syncState),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getSyncStatusText(syncState),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getSyncStatusColor(syncState),
                    ),
                  ),
                ),
                if (syncState.progress > 0 && syncState.isLoading)
                  SizedBox(
                    width: 60,
                    height: 4,
                    child: LinearProgressIndicator(
                      value: syncState.progress,
                      backgroundColor: _getSyncStatusColor(syncState).withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation(_getSyncStatusColor(syncState)),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
  
  /// 构建未登录用户信息
  Widget _buildLoggedOutUser() {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person_outline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          title: const Text('未登录'),
          subtitle: const Text('登录后可享受云端同步服务'),
          trailing: ElevatedButton(
            onPressed: _showAuthScreen,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('登录'),
          ),
        ),
      ],
    );
  }
  
  /// 显示认证页面
  void _showAuthScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthScreen(),
      ),
    );
  }
  
  /// 处理用户操作
  void _handleUserAction(String action) {
    switch (action) {
      case 'sync':
        _performManualSync();
        break;
      case 'logout':
        _performLogout();
        break;
    }
  }
  
  /// 执行手动同步
  void _performManualSync() {
    final syncService = ref.read(syncServiceProvider.notifier);
    syncService.manualSync();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('开始同步数据...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// 执行登出
  void _performLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认登出'),
        content: const Text('登出后将停止云端同步，是否继续？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              final authService = ref.read(authServiceProvider.notifier);
              final success = await authService.signOut();
              
              if (success && mounted) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('已成功登出'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('登出'),
          ),
        ],
      ),
    );
  }
  
  /// 获取网络状态文本
  String _getNetworkStatusText(NetworkStatus status) {
    switch (status) {
      case NetworkStatus.online:
        return '在线';
      case NetworkStatus.offline:
        return '离线';
      case NetworkStatus.slow:
        return '网络缓慢';
      case NetworkStatus.unknown:
        return '网络未知';
    }
  }
  
  /// 获取同步状态颜色
  Color _getSyncStatusColor(SyncState state) {
    if (state.hasError) return Colors.red;
    if (state.hasConflicts) return Colors.orange;
    if (state.isLoading) return Colors.blue;
    if (state.hasPendingSync) return Colors.amber;
    return Colors.green;
  }
  
  /// 获取同步状态图标
  IconData _getSyncStatusIcon(SyncState state) {
    if (state.hasError) return Icons.error_outline;
    if (state.hasConflicts) return Icons.warning_outlined;
    if (state.isLoading) return Icons.sync;
    if (state.hasPendingSync) return Icons.schedule;
    return Icons.check_circle_outline;
  }
  
  /// 获取同步状态文本
  String _getSyncStatusText(SyncState state) {
    if (state.hasError) return '同步失败: ${state.error}';
    if (state.hasConflicts) return '有 ${state.conflictCount} 个冲突需要处理';
    if (state.isLoading) return state.statusMessage ?? '正在同步...';
    if (state.hasPendingSync) return '有 ${state.pendingSyncCount} 个项目待同步';
    return '数据已同步';
  }

  Widget _buildThemeColorOptions() {
    final currentThemeColor = ref.watch(themeColorProviderProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 跟随系统颜色选项
        GestureDetector(
          onTap: () {
            ref.read(subscriptionNotifierProvider.notifier).updateThemeColor(null);
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                  border: currentThemeColor == null
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
                      : null,
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text('自动', style: TextStyle(fontSize: 16)),
              const Spacer(),
              if (currentThemeColor == null)
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
            ],
          ),
        ),
        const SizedBox(height: AppThemeConstants.standardPadding),
        const Text(
          '预设颜色',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppThemeConstants.componentSpacing),
        // 预定义颜色选项
        GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: AppThemeConstants.presetThemeColors.map((color) {
            return GestureDetector(
              onTap: () {
                ref.read(subscriptionNotifierProvider.notifier).updateThemeColor(color);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppThemeConstants.componentSpacing),
                  border: currentThemeColor == color
                      ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
                      : Border.all(color: Colors.grey.withValues(alpha: 0.5)),
                ),
                child: currentThemeColor == color 
                    ? Icon(Icons.check, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}