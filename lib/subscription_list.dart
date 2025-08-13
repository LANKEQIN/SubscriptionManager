import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription_provider.dart';
import 'subscription_card.dart';
import 'edit_subscription_dialog.dart';
import 'subscription.dart';

class SubscriptionList extends StatelessWidget {
  const SubscriptionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          final subscriptions = subscriptionProvider.subscriptions;
          return subscriptions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: subscriptions.length,
                  itemBuilder: (context, index) {
                    return SubscriptionCard(
                      subscription: subscriptions[index],
                      onEdit: (subscription) {
                        _showEditDialog(context, subscription, subscriptionProvider);
                      },
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            '暂无订阅',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '点击下方按钮添加您的第一个订阅',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Subscription subscription,
      SubscriptionProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditSubscriptionDialog(
          subscription: subscription,
          onSubscriptionUpdated: (updatedSubscription) {
            provider.updateSubscription(updatedSubscription);
          },
          onSubscriptionDeleted: (id) {
            provider.removeSubscription(id);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('订阅删除成功')),
            );
          },
        );
      },
    );
  }
}



