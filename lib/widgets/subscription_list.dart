import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import 'subscription_card.dart';
import '../dialogs/edit_subscription_dialog.dart';
import '../models/subscription.dart';
import '../utils/responsive_layout.dart';
import '../utils/icon_utils.dart';

/// 订阅列表组件
/// 显示所有订阅的列表，支持空状态显示和编辑功能

class SubscriptionList extends ConsumerWidget {
  final bool shrinkWrap;
  final bool showAsTable;
  
  const SubscriptionList({
    super.key, 
    this.shrinkWrap = false,
    this.showAsTable = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return subscriptionState.when(
      data: (state) {
        final subscriptions = state.subscriptions;
        
        if (subscriptions.isEmpty) {
          return _buildEmptyState();
        }
        
        // 检查是否为大屏设备且启用表格模式
        if (showAsTable && ResponsiveLayout.isLargeScreen(context)) {
          return _buildTableView(subscriptions, ref);
        }
        
        // 检查是否为大屏设备，使用网格布局
        if (ResponsiveLayout.isLargeScreen(context) && !shrinkWrap) {
          return _buildGridView(context, subscriptions, ref);
        }
        
        // 默认列表布局
        return ListView.builder(
          shrinkWrap: shrinkWrap,
          physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
          cacheExtent: 200, // 预缓存范围200像素
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            final subscription = subscriptions[index];
            return KeepAliveSubscriptionCard(
              key: ValueKey(subscription.id), // 使用ValueKey保持widget状态
              subscription: subscription,
              onEdit: (subscription) {
                _showEditDialog(context, subscription, ref);
              },
            );
          },
        );
      },
      loading: () => const SkeletonListWidget(), // 优化的骨架屏加载
      error: (error, stack) => ErrorListWidget(error: error), // 优化的错误组件
    );
  }

  /// 构建空状态视图
  /// 当没有订阅时显示的提示信息
  Widget _buildEmptyState() {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 350;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.subscriptions_outlined,
                size: isSmallScreen ? 48 : 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Text(
                '暂无订阅',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: isSmallScreen ? 6 : 8),
              Text(
                '点击下方按钮添加您的第一个订阅',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Icon(
                Icons.arrow_downward,
                size: isSmallScreen ? 24 : 32,
                color: Colors.grey[400],
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建网格视图（大屏设备）
  Widget _buildGridView(BuildContext context, List<Subscription> subscriptions, WidgetRef ref) {
    final columnCount = ResponsiveLayout.getColumnCount(context);
    
    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: ResponsiveLayout.getCardSpacing(context),
        mainAxisSpacing: ResponsiveLayout.getCardSpacing(context),
      ),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = subscriptions[index];
        return KeepAliveSubscriptionCard(
          key: ValueKey(subscription.id),
          subscription: subscription,
          onEdit: (subscription) {
            _showEditDialog(context, subscription, ref);
          },
        );
      },
    );
  }
  
  /// 构建表格视图（大屏设备）
  Widget _buildTableView(List<Subscription> subscriptions, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = subscriptions[index];
        return _buildTableRow(context, subscription, ref, index);
      },
    );
  }
  
  /// 构建表格行
  Widget _buildTableRow(BuildContext context, Subscription subscription, WidgetRef ref, int index) {
    final theme = Theme.of(context);
    final isEven = index % 2 == 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isEven ? theme.colorScheme.surface : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: InkWell(
        onTap: () => _showEditDialog(context, subscription, ref),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              // 服务图标和名称
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        IconUtils.getIconData(subscription.iconName),
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscription.name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subscription.notes?.isNotEmpty == true)
                            Text(
                              subscription.notes!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // 费用
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¥${subscription.price.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      _getBillingCycleText(subscription.billingCycle),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 下次扣费日期
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(subscription.nextPaymentDate),
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${subscription.daysUntilNextPayment}天后',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subscription.daysUntilNextPayment <= 7 
                            ? Colors.orange 
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 操作按钮
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => _showEditDialog(context, subscription, ref),
                      icon: const Icon(Icons.edit),
                      iconSize: 20,
                      tooltip: '编辑',
                    ),
                    IconButton(
                      onPressed: () => _deleteSubscription(context, subscription, ref),
                      icon: const Icon(Icons.delete),
                      iconSize: 20,
                      color: Colors.red,
                      tooltip: '删除',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 获取计费周期文本
  String _getBillingCycleText(String cycle) {
    switch (cycle) {
      case 'monthly':
        return '每月';
      case 'yearly':
        return '每年';
      case 'weekly':
        return '每周';
      default:
        return cycle;
    }
  }
  
  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  /// 删除订阅
  void _deleteSubscription(BuildContext context, Subscription subscription, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除订阅「${subscription.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(subscriptionNotifierProvider.notifier).removeSubscription(subscription.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订阅删除成功')),
              );
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
  
  /// 显示编辑对话框
  /// 当用户点击订阅项时弹出编辑对话框
  void _showEditDialog(BuildContext context, Subscription subscription, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditSubscriptionDialog(
          subscription: subscription,
          onSubscriptionUpdated: (updatedSubscription) {
            ref.read(subscriptionNotifierProvider.notifier).updateSubscription(updatedSubscription);
          },
          onSubscriptionDeleted: (id) {
            ref.read(subscriptionNotifierProvider.notifier).removeSubscription(id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('订阅删除成功')),
            );
          },
        );
      },
    );
  }
}

/// 保持状态的订阅卡片
/// 使用AutomaticKeepAliveClientMixin保持widget状态以提高性能
class KeepAliveSubscriptionCard extends StatefulWidget {
  final Subscription subscription;
  final Function(Subscription) onEdit;
  
  const KeepAliveSubscriptionCard({
    super.key,
    required this.subscription,
    required this.onEdit,
  });
  
  @override
  State<KeepAliveSubscriptionCard> createState() => _KeepAliveSubscriptionCardState();
}

class _KeepAliveSubscriptionCardState extends State<KeepAliveSubscriptionCard>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true; // 保持widget状态
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用父类build
    
    return SubscriptionCard(
      subscription: widget.subscription,
      onEdit: widget.onEdit,
    );
  }
}

/// 骨架屏加载组件
/// 提供更好的加载体验
class SkeletonListWidget extends StatelessWidget {
  const SkeletonListWidget({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // 禁止滚动
      itemCount: 5, // 显示5个骨架项
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}

/// 骨架卡片组件
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 模拟标题
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // 模拟副标题
          Container(
            width: 100,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          // 模拟价格
          Container(
            width: 80,
            height: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// 错误显示组件
class ErrorListWidget extends StatelessWidget {
  final Object error;
  
  const ErrorListWidget({super.key, required this.error});
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            '加载失败',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // 重试按钮，可以添加重试逻辑
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}

