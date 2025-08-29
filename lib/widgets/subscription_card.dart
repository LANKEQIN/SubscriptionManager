import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../utils/icon_utils.dart';

/// 订阅卡片组件
/// 显示单个订阅的详细信息，包括图标、名称、价格和到期时间
class SubscriptionCard extends StatelessWidget {
  /// 要显示的订阅对象
  final Subscription subscription;
  
  /// 编辑回调函数
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
          color: Theme.of(context).dividerColor.withValues(alpha:0.2),
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 在小屏幕上使用垂直布局，在大屏幕上使用水平布局
              if (constraints.maxWidth < 350) {
                // 小屏幕适配 - 垂直布局
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部 - 图标和名称
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconUtils.buildSubscriptionIcon(context, subscription.icon),
                        ),
                        const SizedBox(width: 16),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 底部 - 状态和日期
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${subscription.nextPaymentDate.month}月${subscription.nextPaymentDate.day}日',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
                  ],
                );
              } else {
                // 大屏幕适配 - 水平布局
                return Row(
                  children: [
                    // 左侧图标
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha:0.1),
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
                );
              }
            },
          ),
        ),
      ),
    );
  }
}