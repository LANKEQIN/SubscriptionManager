import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/responsive_layout.dart';
import '../widgets/large_screen_layout.dart';

/// 大屏设备个人中心页面
class LargeScreenProfile extends ConsumerWidget {
  const LargeScreenProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LargeScreenContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
          
          Expanded(
            child: LargeScreenColumns(
              children: [
                // 左侧：用户信息和快捷操作
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildUserProfile(context),
                      SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
                      _buildQuickActions(context),
                    ],
                  ),
                ),
                
                SizedBox(width: ResponsiveLayout.getCardSpacing(context)),
                
                // 右侧：设置和偏好
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildSettings(context),
                      SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
                      _buildDataManagement(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建页面头部
  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.person,
            size: 32,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '个人中心',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '管理您的账户设置和偏好',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// 构建用户资料
  Widget _buildUserProfile(BuildContext context) {
    final theme = Theme.of(context);
    
    return LargeScreenCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 头像
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 用户名
            Text(
              '用户',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 4),
            
            // 邮箱
            Text(
              'user@example.com',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 编辑资料按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showEditProfileDialog(context);
                },
                icon: const Icon(Icons.edit),
                label: const Text('编辑资料'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建快捷操作
  Widget _buildQuickActions(BuildContext context) {
    return LargeScreenCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '快捷操作',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildActionItem(
              context,
              '导出数据',
              '导出所有订阅数据',
              Icons.download,
              () => _exportData(context),
            ),
            
            const SizedBox(height: 12),
            
            _buildActionItem(
              context,
              '导入数据',
              '从文件导入订阅数据',
              Icons.upload,
              () => _importData(context),
            ),
            
            const SizedBox(height: 12),
            
            _buildActionItem(
              context,
              '备份设置',
              '备份应用设置和数据',
              Icons.backup,
              () => _backupData(context),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建设置
  Widget _buildSettings(BuildContext context) {
    return LargeScreenCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '应用设置',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingItem(
              context,
              '深色模式',
              '启用深色主题',
              Icons.dark_mode,
              false,
              (value) {
                // 处理深色模式切换
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingItem(
              context,
              '自动同步',
              '自动同步订阅数据',
              Icons.sync,
              true,
              (value) {
                // 处理自动同步切换
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingItem(
              context,
              '推送通知',
              '接收订阅提醒通知',
              Icons.notifications,
              true,
              (value) {
                // 处理通知切换
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingItem(
              context,
              '生物识别',
              '使用指纹或面部识别',
              Icons.fingerprint,
              false,
              (value) {
                // 处理生物识别切换
              },
            ),
            
            const SizedBox(height: 20),
            
            const Divider(),
            
            const SizedBox(height: 16),
            
            // 货币设置
            _buildCurrencySelector(context),
            
            const SizedBox(height: 16),
            
            // 语言设置
            _buildLanguageSelector(context),
          ],
        ),
      ),
    );
  }
  
  /// 构建数据管理
  Widget _buildDataManagement(BuildContext context) {
    return LargeScreenCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '数据管理',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildDataItem(
              context,
              '存储使用',
              '2.5 MB / 100 MB',
              Icons.storage,
              0.025,
            ),
            
            const SizedBox(height: 16),
            
            _buildActionItem(
              context,
              '清除缓存',
              '清除应用缓存数据',
              Icons.cleaning_services,
              () => _clearCache(context),
            ),
            
            const SizedBox(height: 12),
            
            _buildActionItem(
              context,
              '重置应用',
              '恢复应用到初始状态',
              Icons.restore,
              () => _resetApp(context),
              isDestructive: true,
            ),
            
            const SizedBox(height: 20),
            
            const Divider(),
            
            const SizedBox(height: 16),
            
            // 关于信息
            _buildAboutSection(context),
          ],
        ),
      ),
    );
  }
  
  /// 构建操作项
  Widget _buildActionItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive ? Colors.red : theme.colorScheme.onSurface;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: color.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color.withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建设置项
  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          size: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
  
  /// 构建数据项
  Widget _buildDataItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    double progress,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
      ],
    );
  }
  
  /// 构建货币选择器
  Widget _buildCurrencySelector(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          Icons.attach_money,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          size: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '默认货币',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '人民币 (¥)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            _showCurrencySelector(context);
          },
          child: const Text('更改'),
        ),
      ],
    );
  }
  
  /// 构建语言选择器
  Widget _buildLanguageSelector(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          Icons.language,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          size: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '语言',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '简体中文',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            _showLanguageSelector(context);
          },
          child: const Text('更改'),
        ),
      ],
    );
  }
  
  /// 构建关于部分
  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '关于',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '订阅管理器',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '版本 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// 显示编辑资料对话框
  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑资料'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '邮箱',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('资料更新成功')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
  
  /// 导出数据
  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据导出功能开发中')),
    );
  }
  
  /// 导入数据
  void _importData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据导入功能开发中')),
    );
  }
  
  /// 备份数据
  void _backupData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据备份功能开发中')),
    );
  }
  
  /// 清除缓存
  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除缓存'),
        content: const Text('确定要清除应用缓存吗？这不会删除您的订阅数据。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('缓存清除成功')),
              );
            },
            child: const Text('清除'),
          ),
        ],
      ),
    );
  }
  
  /// 重置应用
  void _resetApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置应用'),
        content: const Text('警告：这将删除所有数据并恢复应用到初始状态，此操作不可撤销！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('应用重置功能开发中')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('重置'),
          ),
        ],
      ),
    );
  }
  
  /// 显示货币选择器
  void _showCurrencySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择货币'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('人民币 (¥)'),
              leading: Radio<String>(
                value: 'CNY',
                groupValue: 'CNY',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('美元 (\$)'),
              leading: Radio<String>(
                value: 'USD',
                groupValue: 'CNY',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('欧元 (€)'),
              leading: Radio<String>(
                value: 'EUR',
                groupValue: 'CNY',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
  
  /// 显示语言选择器
  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('简体中文'),
              leading: Radio<String>(
                value: 'zh_CN',
                groupValue: 'zh_CN',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<String>(
                value: 'en_US',
                groupValue: 'zh_CN',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}