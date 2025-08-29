import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import '../models/subscription.dart';
import '../utils/icon_utils.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('提醒'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '即将到期',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '7天内到期的订阅',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: subscriptionState.when(
                data: (state) {
                  final upcomingSubscriptions = state.upcomingSubscriptions;
                  
                  if (upcomingSubscriptions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '没有即将到期的订阅',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '所有订阅都安全无忧',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    itemCount: upcomingSubscriptions.length,
                    itemBuilder: (context, index) {
                      return _buildSubscriptionItem(
                        context, 
                        upcomingSubscriptions[index],
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
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubscriptionItem(BuildContext context, Subscription subscription) {
    final daysUntilPayment = subscription.daysUntilPayment;
    Color? statusColor;
    
    if (daysUntilPayment <= 0) {
      statusColor = Colors.red;
    } else if (daysUntilPayment <= 3) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.green;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 左侧图标
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
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subscription.renewalStatus,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
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
                  '${subscription.nextPaymentDate.month}-${subscription.nextPaymentDate.day}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${subscription.nextPaymentDate.year}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}