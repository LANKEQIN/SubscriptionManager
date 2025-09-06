import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/subscription_notifier.dart';
import '../widgets/large_screen_layout.dart';
import '../utils/responsive_layout.dart';
import '../utils/currency_constants.dart';

/// 大屏设备专用的统计页面
class LargeScreenStatistics extends ConsumerStatefulWidget {
  const LargeScreenStatistics({super.key});

  @override
  ConsumerState<LargeScreenStatistics> createState() => _LargeScreenStatisticsState();
}

class _LargeScreenStatisticsState extends ConsumerState<LargeScreenStatistics> {
  // 货币选项
  static final Map<String, String> _currencies = {
    'CNY': '人民币 (CN¥)',
    'USD': '美元 (US\$)',
    'EUR': '欧元 (€)',
    'GBP': '英镑 (£)',
    'JPY': '日元 (JP¥)',
    'KRW': '韩元 (₩)',
    'INR': '印度卢比 (₹)',
    'RUB': '卢布 (₽)',
    'AUD': '澳元 (A\$)',
    'CAD': '加元 (C\$)',
    'HKD': '港币 (HK\$)',
    'TWD': '新台币 (NT\$)',
    'SGD': '新加坡元 (S\$)',
  };

  @override
  Widget build(BuildContext context) {
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    return subscriptionState.when(
      data: (state) => _buildContent(context, state),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(subscriptionNotifierProvider);
              },
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, state) {
    return LargeScreenContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部操作栏
          _buildTopActions(context, state),
          
          SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
          
          // 统计概览网格
          _buildOverviewGrid(context, state),
          
          SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
          
          // 详细统计区域
          _buildDetailedStats(context, state),
        ],
      ),
    );
  }
  
  /// 构建顶部操作栏
  Widget _buildTopActions(BuildContext context, state) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '统计分析',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showCurrencySelector(context),
          icon: const Icon(Icons.swap_horiz),
          label: Text('货币: ${_getCurrencyName(state.baseCurrency)}'),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () {
            // 导出统计数据
          },
          icon: const Icon(Icons.download),
          label: const Text('导出数据'),
        ),
      ],
    );
  }
  
  /// 构建统计概览网格
  Widget _buildOverviewGrid(BuildContext context, state) {
    final subscriptionCount = state.subscriptions.length;
    final baseCurrency = state.baseCurrency;
    
    return LargeScreenGrid(
      crossAxisCount: ResponsiveLayout.responsiveValue(
        context: context,
        mobile: 2,
        tablet: 3,
        desktop: 4,
      ),
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          context,
          title: '订阅总数',
          value: '$subscriptionCount',
          subtitle: '个服务',
          icon: Icons.subscriptions,
          color: Colors.blue,
        ),
        
        // 月度支出卡片
        FutureBuilder<double>(
          future: ref.read(subscriptionNotifierProvider.notifier).getMonthlyCost(),
          builder: (context, snapshot) {
            final monthlyCost = snapshot.data ?? 0.0;
            return _buildStatCard(
              context,
              title: '月度支出',
              value: '${_getCurrencySymbol(baseCurrency)}${monthlyCost.toStringAsFixed(2)}',
              subtitle: '每月',
              icon: Icons.payment,
              color: Colors.green,
            );
          },
        ),
        
        // 年度支出卡片
        FutureBuilder<double>(
          future: ref.read(subscriptionNotifierProvider.notifier).getYearlyCost(),
          builder: (context, snapshot) {
            final yearlyCost = snapshot.data ?? 0.0;
            return _buildStatCard(
              context,
              title: '年度支出',
              value: '${_getCurrencySymbol(baseCurrency)}${yearlyCost.toStringAsFixed(2)}',
              subtitle: '每年',
              icon: Icons.trending_up,
              color: Colors.purple,
            );
          },
        ),
        
        _buildStatCard(
          context,
          title: '平均费用',
          value: subscriptionCount > 0 
              ? '${_getCurrencySymbol(baseCurrency)}${(state.subscriptions.fold<double>(0, (sum, sub) => sum + sub.price) / subscriptionCount).toStringAsFixed(2)}'
              : '${_getCurrencySymbol(baseCurrency)}0.00',
          subtitle: '每个服务',
          icon: Icons.calculate,
          color: Colors.orange,
        ),
      ],
    );
  }
  
  /// 构建详细统计区域
  Widget _buildDetailedStats(BuildContext context, state) {
    return LargeScreenColumns(
      flex: const [2, 1],
      children: [
        // 左侧：类型分布和趋势
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '类型分布',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
            _buildTypeDistributionCard(context, state),
            
            SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
            
            Text(
              '支出趋势',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
            _buildTrendCard(context),
          ],
        ),
        
        // 右侧：即将到期和最近活动
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '即将到期',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
            _buildUpcomingCard(context, state),
            
            SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
            
            Text(
              '最近活动',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
            _buildRecentActivityCard(context),
          ],
        ),
      ],
    );
  }
  
  /// 构建统计卡片
  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return LargeScreenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.green,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+5%',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建类型分布卡片
  Widget _buildTypeDistributionCard(BuildContext context, state) {
    return LargeScreenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '按类型分布',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // 这里可以添加图表组件
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('图表区域\n（可集成图表库）'),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建趋势卡片
  Widget _buildTrendCard(BuildContext context) {
    return LargeScreenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '支出趋势',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('趋势图表\n（可集成图表库）'),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建即将到期卡片
  Widget _buildUpcomingCard(BuildContext context, state) {
    final upcomingSubscriptions = state.upcomingSubscriptions;
    
    return LargeScreenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7天内到期',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          if (upcomingSubscriptions.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 48,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '暂无即将到期的订阅',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          else
            ...upcomingSubscriptions.take(3).map((subscription) => 
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        subscription.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      '${subscription.daysUntilNextPayment}天',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  /// 构建最近活动卡片
  Widget _buildRecentActivityCard(BuildContext context) {
    return LargeScreenCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最近活动',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // 活动列表
          ...List.generate(3, (index) => 
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '订阅更新',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '2小时前',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 显示货币选择器
  void _showCurrencySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择货币'),
        content: SizedBox(
          width: 300,
          child: ListView(
            shrinkWrap: true,
            children: _currencies.entries.map((entry) {
              return ListTile(
                title: Text(entry.value),
                onTap: () {
                  ref.read(subscriptionNotifierProvider.notifier)
                      .setBaseCurrency(entry.key);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  
  /// 获取货币符号
  String _getCurrencySymbol(String currency) {
    return currencySymbols[currency] ?? currency;
  }
  
  /// 获取货币名称
  String _getCurrencyName(String currency) {
    return _currencies[currency]?.split(' ').first ?? currency;
  }
}