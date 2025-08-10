import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription.dart';
import 'subscription_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部标题栏
        AppBar(
          title: const Text('会员制管理'),
          centerTitle: false,
          actions: [
            // 提醒铃铛图标
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // 跳转到提醒页面
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('跳转到提醒页面')),
                );
                // 在实际应用中，这里应该导航到提醒页面
              },
            ),
            // 用户头像
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person_outline,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        // 主页面内容
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 添加统计卡片
                _buildStatisticsCard(context),
                const SizedBox(height: 16),
                const Text(
                  '所有订阅',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
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
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildStatisticsCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SubscriptionProvider>(
          builder: (context, provider, child) {
            // 计算活跃订阅数 (自动续费的订阅)
            final activeSubscriptions = provider.subscriptions
                .where((subscription) => subscription.autoRenewal)
                .length;
            
            // 计算即将到期订阅数 (7天内到期)
            final expiringSoon = provider.subscriptions
                .where((subscription) => subscription.daysUntilPayment <= 7 && 
                      subscription.daysUntilPayment >= 0)
                .length;
            
            // 本月支出
            final monthlyCost = provider.monthlyCost;
            
            // 计算较上月变化百分比
            final changePercentage = provider.getMonthlyCostChangePercentage();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '本月概览',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatisticItem(
                      '本月支出',
                      '¥${monthlyCost.toStringAsFixed(2)}',
                      '${changePercentage > 0 ? "↑" : "↓"}${changePercentage.abs().toStringAsFixed(1)}%较上月',
                      changePercentage > 0 ? Colors.red : (changePercentage < 0 ? Colors.green : Colors.grey),
                    ),
                    _buildStatisticItem(
                      '活跃订阅',
                      '$activeSubscriptions',
                      '',
                      null,
                    ),
                    _buildStatisticItem(
                      '即将到期',
                      '$expiringSoon',
                      '7天内',
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatisticItem(
    String title,
    String value,
    String subtitle,
    Color? subtitleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: subtitleColor ?? Colors.grey,
            ),
          ),
      ],
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({super.key, required this.subscription});

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
              child: subscription.icon != null
                  ? Icon(
                      IconData(int.parse(subscription.icon!), fontFamily: 'MaterialIcons'),
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : Icon(
                      Icons.subscriptions_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
    );
  }
}