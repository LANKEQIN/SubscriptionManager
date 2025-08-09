import 'package:flutter/material.dart';
import 'add_subscription_dialog.dart';
import 'subscription.dart';

class AddButton extends StatelessWidget {
  final Function(Subscription)? onSubscriptionAdded;
  
  const AddButton({super.key, this.onSubscriptionAdded});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 点击事件，弹出添加订阅对话框
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddSubscriptionDialog(
              onSubscriptionAdded: onSubscriptionAdded,
            );
          },
        );
      },
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurple,
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