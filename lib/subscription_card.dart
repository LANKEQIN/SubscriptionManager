import 'package:flutter/material.dart';
import 'subscription.dart';
import 'icon_utils.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;
  final Function(Subscription)? onEdit;

  const SubscriptionCard({super.key, required this.subscription, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // 点击事件可以保留用于查看详情等功能
        },
        onLongPress: onEdit != null
            ? () {
                onEdit!(subscription);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 左侧图标
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconUtils.buildSubscriptionIcon(context, subscription.icon),
              ),
              const SizedBox(width: 16),
              // 中间信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscription.formattedPrice,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subscription.renewalStatus,
                      style: TextStyle(
                        fontSize: 14,
                        color: subscription.autoRenewal
                            ? Colors.green
                            : subscription.daysUntilPayment <= 7
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // 右侧信息
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '下次付费',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    '${subscription.nextPaymentDate.month}月${subscription.nextPaymentDate.day}日',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${subscription.nextPaymentDate.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}