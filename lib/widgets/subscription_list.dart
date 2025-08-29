import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import 'subscription_card.dart';
import '../dialogs/edit_subscription_dialog.dart';
import '../models/subscription.dart';

/// 订阅列表组件
/// 显示所有订阅的列表，支持空状态显示和编辑功能

class SubscriptionList extends ConsumerWidget {
  const SubscriptionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return Expanded(
      child: subscriptionState.when(
        data: (state) {
          final subscriptions = state.subscriptions;
          
          if (subscriptions.isEmpty) {
            return _buildEmptyState();
          }
          
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: subscriptions.length,
            itemBuilder: (context, index) {
              return SubscriptionCard(
                subscription: subscriptions[index],
                onEdit: (subscription) {
                  _showEditDialog(context, subscription, ref);
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Text('加载失败: $error'),
        ),
      ),
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

