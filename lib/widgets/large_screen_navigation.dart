import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';

/// 大屏设备专用的侧边导航组件
class LargeScreenNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  
  const LargeScreenNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      width: ResponsiveLayout.getSidebarWidth(context),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 应用标题区域
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(
                  Icons.subscriptions,
                  size: 32,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Subscription\nManager',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // 导航菜单
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildNavigationItem(
                  context,
                  index: 0,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: '首页',
                ),
                _buildNavigationItem(
                  context,
                  index: 1,
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart,
                  label: '统计',
                ),
                _buildNavigationItem(
                  context,
                  index: 2,
                  icon: Icons.notifications_outlined,
                  selectedIcon: Icons.notifications,
                  label: '提醒',
                ),
                _buildNavigationItem(
                  context,
                  index: 3,
                  icon: Icons.person_outlined,
                  selectedIcon: Icons.person,
                  label: '我的',
                ),
              ],
            ),
          ),
          
          // 底部信息
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              '版本 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNavigationItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedIndex == index;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: isSelected 
            ? colorScheme.primaryContainer 
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onDestinationSelected(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected 
                      ? colorScheme.onPrimaryContainer 
                      : colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isSelected 
                          ? colorScheme.onPrimaryContainer 
                          : colorScheme.onSurface.withValues(alpha: 0.8),
                      fontWeight: isSelected 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 大屏设备专用的顶部应用栏
class LargeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  
  const LargeScreenAppBar({
    super.key,
    required this.title,
    this.actions,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(64);
}