import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import '../models/subscription.dart';
import '../utils/responsive_layout.dart';
import '../utils/icon_utils.dart';
import '../widgets/large_screen_layout.dart';
import '../dialogs/edit_subscription_dialog.dart';

/// 大屏设备提醒页面
class LargeScreenNotifications extends ConsumerWidget {
  const LargeScreenNotifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return LargeScreenContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
          
          Expanded(
            child: subscriptionState.when(
              data: (state) => _buildNotificationContent(context, state.subscriptions, ref),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
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
            Icons.notifications_active,
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
                '订阅提醒',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '管理即将到期的订阅服务',
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
  
  /// 构建通知内容
  Widget _buildNotificationContent(BuildContext context, List<Subscription> subscriptions, WidgetRef ref) {
    // 筛选即将到期的订阅（7天内）
    final upcomingSubscriptions = subscriptions
        .where((subscription) => subscription.daysUntilNextPayment <= 7)
        .toList();
    
    // 按到期时间排序
    upcomingSubscriptions.sort((a, b) => a.daysUntilNextPayment.compareTo(b.daysUntilNextPayment));
    
    if (upcomingSubscriptions.isEmpty) {
      return _buildEmptyState(context);
    }
    
    return LargeScreenColumns(
      children: [
        // 左侧：即将到期列表
        Expanded(
          flex: 2,
          child: _buildUpcomingList(context, upcomingSubscriptions, ref),
        ),
        
        SizedBox(width: ResponsiveLayout.getCardSpacing(context)),
        
        // 右侧：提醒设置和统计
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildReminderSettings(context),
              SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
              _buildNotificationStats(context, subscriptions),
            ],
          ),
        ),
      ],
    );
  }
  
  /// 构建即将到期列表
  Widget _buildUpcomingList(BuildContext context, List<Subscription> subscriptions, WidgetRef ref) {
    return LargeScreenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '即将到期订阅',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${subscriptions.length}个',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subscriptions.length,
              itemBuilder: (context, index) {
                final subscription = subscriptions[index];
                return _buildNotificationItem(context, subscription, ref, index);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建通知项
  Widget _buildNotificationItem(BuildContext context, Subscription subscription, WidgetRef ref, int index) {
    final theme = Theme.of(context);
    final daysLeft = subscription.daysUntilNextPayment;
    
    Color urgencyColor;
    String urgencyText;
    
    if (daysLeft == 0) {
      urgencyColor = Colors.red;
      urgencyText = '今天到期';
    } else if (daysLeft == 1) {
      urgencyColor = Colors.orange;
      urgencyText = '明天到期';
    } else if (daysLeft <= 3) {
      urgencyColor = Colors.orange;
      urgencyText = '$daysLeft天后到期';
    } else {
      urgencyColor = Colors.blue;
      urgencyText = '$daysLeft天后到期';
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: urgencyColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showEditDialog(context, subscription, ref),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // 服务图标
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconUtils.getIconData(subscription.iconName),
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // 订阅信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '¥${subscription.price.toStringAsFixed(2)} / ${_getBillingCycleText(subscription.billingCycle)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            // 紧急程度标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: urgencyColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                urgencyText,
                style: TextStyle(
                  color: urgencyColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建提醒设置
  Widget _buildReminderSettings(BuildContext context) {
    return LargeScreenCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '提醒设置',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildSettingItem(
              context,
              '提前提醒',
              '在订阅到期前7天提醒',
              Icons.schedule,
              true,
            ),
            
            const SizedBox(height: 12),
            
            _buildSettingItem(
              context,
              '推送通知',
              '发送系统通知提醒',
              Icons.notifications,
              true,
            ),
            
            const SizedBox(height: 12),
            
            _buildSettingItem(
              context,
              '邮件提醒',
              '发送邮件提醒',
              Icons.email,
              false,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建设置项
  Widget _buildSettingItem(BuildContext context, String title, String subtitle, IconData icon, bool value) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
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
          onChanged: (newValue) {
            // 处理设置变更
          },
        ),
      ],
    );
  }
  
  /// 构建通知统计
  Widget _buildNotificationStats(BuildContext context, List<Subscription> subscriptions) {
    final todayCount = subscriptions.where((s) => s.daysUntilNextPayment == 0).length;
    final weekCount = subscriptions.where((s) => s.daysUntilNextPayment <= 7).length;
    final monthCount = subscriptions.where((s) => s.daysUntilNextPayment <= 30).length;
    
    return LargeScreenCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '提醒统计',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            _buildStatItem(context, '今日到期', todayCount.toString(), Colors.red),
            const SizedBox(height: 12),
            _buildStatItem(context, '本周到期', weekCount.toString(), Colors.orange),
            const SizedBox(height: 12),
            _buildStatItem(context, '本月到期', monthCount.toString(), Colors.blue),
          ],
        ),
      ),
    );
  }
  
  /// 构建统计项
  Widget _buildStatItem(BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
  
  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '暂无即将到期的订阅',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '所有订阅都在有效期内',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建加载状态
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  /// 构建错误状态
  Widget _buildErrorState(Object error) {
    return Builder(
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '加载失败',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  /// 获取计费周期文本
  String _getBillingCycleText(String cycle) {
    switch (cycle) {
      case 'monthly':
        return '月';
      case 'yearly':
        return '年';
      case 'weekly':
        return '周';
      default:
        return cycle;
    }
  }
  
  /// 显示编辑对话框
  void _showEditDialog(BuildContext context, Subscription subscription, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => EditSubscriptionDialog(
        subscription: subscription,
        onSubscriptionUpdated: (updatedSubscription) {
          ref.read(subscriptionNotifierProvider.notifier).updateSubscription(updatedSubscription);
        },
        onSubscriptionDeleted: (subscriptionId) {
          ref.read(subscriptionNotifierProvider.notifier).removeSubscription(subscriptionId);
        },
      ),
    );
  }
}