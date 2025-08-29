import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dialogs/add_subscription_dialog.dart';
import '../providers/app_providers.dart';

class AddButton extends ConsumerWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // 点击事件，弹出添加订阅对话框
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddSubscriptionDialog(
              onSubscriptionAdded: (subscription) {
                // 使用Riverpod添加订阅
                ref.read(subscriptionProvider.notifier).addSubscription(subscription);
              },
            );
          },
        );
      },
      child: Container(
        width: 56.0,
        height: 56.0,
        margin: const EdgeInsets.only(bottom: 8.0), // 添加底部边距使按钮更居中
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 36.0,
        ),
      ),
    );
  }
}