import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import '../models/subscription_state.dart';
import '../utils/currency_constants.dart';

class StatisticsCard extends StatelessWidget {
  final Widget child;

  const StatisticsCard({
    super.key,
    required this.child,
  });

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
        child: child,
      ),
    );
  }
}

class HomeStatisticsCard extends ConsumerWidget {
  const HomeStatisticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ref.watch(subscriptionNotifierProvider).when(
          loading: () => const Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (error, stack) => Center(
            child: Text('加载失败: $error'),
          ),
          data: (state) => _buildStatisticsContent(context, state, ref),
        ),
      ),
    );
  }

  Widget _buildStatisticsContent(BuildContext context, SubscriptionState state, WidgetRef ref) {
    final subscriptions = state.subscriptions;
    
    // 计算各种统计数据
    final totalSubscriptions = subscriptions.length;
    final activeSubscriptions = subscriptions.where((s) => s.autoRenewal).length;
    final expiringSoon = subscriptions.where((s) => s.daysUntilPayment <= 7 && s.daysUntilPayment >= 0).length;
    final pausedSubscriptions = subscriptions.where((s) => !s.autoRenewal).length;
    
    // 计算年度支出
    final yearlyTotal = subscriptions.fold<double>(0.0, (sum, s) {
      double yearlyAmount = 0.0;
      switch (s.billingCycle) {
        case '每月':
          yearlyAmount = s.price * 12;
          break;
        case '每年':
          yearlyAmount = s.price;
          break;
        case '一次性':
          yearlyAmount = s.price;
          break;
        default:
          yearlyAmount = s.price * 12; // 默认按月计算
      }
      return sum + yearlyAmount;
    });
    
    // 获取基础货币和货币符号
    final baseCurrency = state.baseCurrency;
    final currencySymbol = _getCurrencySymbol(baseCurrency);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '本月概览',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '共$totalSubscriptions项',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // 主要支出信息
        FutureBuilder<double>(
          future: ref.read(subscriptionNotifierProvider.notifier).getMonthlyCost(),
          builder: (context, snapshot) {
            final monthlyCost = snapshot.data ?? 0.0;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '本月支出',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currencySymbol${monthlyCost.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '年度预估',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$currencySymbol${yearlyTotal.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        
        const SizedBox(height: 12),
        
        // 状态统计网格
        Row(
          children: [
            Expanded(
              child: _buildCompactStatItem(
                context,
                '活跃',
                '$activeSubscriptions',
                Icons.autorenew,
                Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactStatItem(
                context,
                '即将到期',
                '$expiringSoon',
                Icons.schedule,
                expiringSoon > 0 ? Colors.orange : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCompactStatItem(
                context,
                '已暂停',
                '$pausedSubscriptions',
                Icons.pause_circle_outline,
                Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildCompactStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }



  // 获取货币符号
  String _getCurrencySymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? currencyCode;
  }
}