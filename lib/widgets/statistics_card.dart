import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';

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

class HomeStatisticsCard extends ConsumerStatefulWidget {
  const HomeStatisticsCard({super.key});

  @override
  ConsumerState<HomeStatisticsCard> createState() => _HomeStatisticsCardState();
}

class _HomeStatisticsCardState extends ConsumerState<HomeStatisticsCard> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 模拟加载延迟
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildStatisticsContent(),
      ),
    );
  }

  Widget _buildStatisticsContent() {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return subscriptionState.when(
      data: (state) {
        final subscriptions = state.subscriptions;
        
        // 计算活跃订阅数 (自动续费的订阅)
        final activeSubscriptions = subscriptions
            .where((subscription) => subscription.autoRenewal)
            .length;

        // 计算即将到期订阅数 (7天内到期)
        final expiringSoon = subscriptions
            .where((subscription) => subscription.daysUntilPayment <= 7 &&
                subscription.daysUntilPayment >= 0)
            .length;

        // 本月支出
        final monthlyCost = state.totalMonthlyCost;

        // 计算较上月变化百分比 (这里简化为0，实际需要实现计算逻辑)
        const double changePercentage = 0.0; // TODO: 实现变化百分比计算

        return LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 350;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '本月概览',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (constraints.maxWidth < 400)
                  // 小屏幕 - 垂直布局
                  Column(
                    children: [
                      _buildStatisticItem(
                        '本月支出',
                        '¥${monthlyCost.toStringAsFixed(2)}',
                        '${changePercentage > 0 ? "↑" : "↓"}${changePercentage.abs().toStringAsFixed(1)}%较上月',
                        changePercentage > 0 ? Colors.red : (changePercentage < 0 ? Colors.green : Colors.grey),
                        isSmallScreen,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatisticItem(
                            '活跃订阅',
                            '$activeSubscriptions',
                            '',
                            null,
                            isSmallScreen,
                          ),
                          _buildStatisticItem(
                            '即将到期',
                            '$expiringSoon',
                            '7天内',
                            Colors.orange,
                            isSmallScreen,
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  // 大屏幕 - 水平布局
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatisticItem(
                        '本月支出',
                        '¥${monthlyCost.toStringAsFixed(2)}',
                        '${changePercentage > 0 ? "↑" : "↓"}${changePercentage.abs().toStringAsFixed(1)}%较上月',
                        changePercentage > 0 ? Colors.red : (changePercentage < 0 ? Colors.green : Colors.grey),
                        isSmallScreen,
                      ),
                      _buildStatisticItem(
                        '活跃订阅',
                        '$activeSubscriptions',
                        '',
                        null,
                        isSmallScreen,
                      ),
                      _buildStatisticItem(
                        '即将到期',
                        '$expiringSoon',
                        '7天内',
                        Colors.orange,
                        isSmallScreen,
                      ),
                    ],
                  ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('加载失败: $error'),
      ),
    );
  }

  Widget _buildStatisticItem(
    String title,
    String value,
    String subtitle,
    Color? subtitleColor,
    bool isSmallScreen,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: subtitleColor ?? Colors.grey,
            ),
          ),
      ],
    );
  }
}