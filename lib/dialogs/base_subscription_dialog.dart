import 'package:flutter/material.dart';
import '../models/subscription.dart';
import 'subscription_form.dart';

abstract class BaseSubscriptionDialog extends StatefulWidget {
  final String title;
  final SubscriptionFormData? initialData;
  final Function(Subscription) onSubscriptionSaved;
  final Function()? onDelete;
  
  const BaseSubscriptionDialog({
    super.key,
    required this.title,
    this.initialData,
    required this.onSubscriptionSaved,
    this.onDelete,
  });
  
  @override
  State<BaseSubscriptionDialog> createState() => _BaseSubscriptionDialogState();
}

class _BaseSubscriptionDialogState extends State<BaseSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  SubscriptionFormState? _formState;

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final formData = _formState!.formData;
      
      final subscription = Subscription(
        id: widget.initialData != null ? '' : null, // 如果是编辑则保留ID，添加时生成新ID
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
      
      widget.onSubscriptionSaved(subscription);
      Navigator.of(context).pop();
    }
  }

  void _handleDelete() {
    if (widget.onDelete != null) {
      widget.onDelete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SubscriptionForm(
          initialData: widget.initialData,
          formKey: _formKey,
          onStateCreated: (state) {
            _formState = state;
          },
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: _handleDelete,
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
          onPressed: _handleSave,
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