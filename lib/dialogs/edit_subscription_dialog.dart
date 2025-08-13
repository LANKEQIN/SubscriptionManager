import 'package:flutter/material.dart';
import '../models/subscription.dart';
import 'subscription_form.dart';

class EditSubscriptionDialog extends StatefulWidget {
  final Subscription subscription;
  final Function(Subscription) onSubscriptionUpdated;
  final Function(String) onSubscriptionDeleted;

  const EditSubscriptionDialog({
    super.key,
    required this.subscription,
    required this.onSubscriptionUpdated,
    required this.onSubscriptionDeleted,
  });

  @override
  State<EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  SubscriptionFormState? _formState;

  void _deleteSubscription() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('确定要删除"${widget.subscription.name}"这个订阅吗？此操作无法撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 关闭编辑对话框
                widget.onSubscriptionDeleted(widget.subscription.id);
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑订阅'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SubscriptionForm(
          formKey: _formKey,
          initialData: SubscriptionFormData.fromSubscription(widget.subscription),
          onStateCreated: (state) {
            _formState = state;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: _deleteSubscription,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('删除'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // 表单验证通过，创建订阅对象
              final formData = _formState!.formData;
              
              final updatedSubscription = widget.subscription.copyWith(
                name: formData.serviceName,
                icon: formData.icon?.codePoint.toString(),
                type: formData.subscriptionType,
                price: formData.price,
                currency: formData.currency,
                billingCycle: formData.billingCycle,
                nextPaymentDate: DateTime.parse(formData.nextPaymentDate),
                autoRenewal: formData.autoRenewal,
                notes: formData.notes?.isNotEmpty == true ? formData.notes : null,
              );
              
              // 调用回调函数传递更新后的订阅
              widget.onSubscriptionUpdated(updatedSubscription);
              
              // 关闭对话框
              Navigator.of(context).pop();
              
              // 显示成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订阅更新成功')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('保存'),
        ),
      ],
    );
  }
}