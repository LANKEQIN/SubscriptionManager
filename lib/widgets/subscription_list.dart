import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import 'subscription_card.dart';
import '../dialogs/edit_subscription_dialog.dart';
import '../models/subscription.dart';

/// 订阅列表组件
/// 显示所有订阅的列表，支持空状态显示和编辑功能

class SubscriptionList extends ConsumerWidget {
  final bool shrinkWrap;
  
  const SubscriptionList({super.key, this.shrinkWrap = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return subscriptionState.when(
      data: (state) {
        final subscriptions = state.subscriptions;
        
        if (subscriptions.isEmpty) {
          return _buildEmptyState();
        }
        
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

