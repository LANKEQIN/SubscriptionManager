import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription_provider.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context) {
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