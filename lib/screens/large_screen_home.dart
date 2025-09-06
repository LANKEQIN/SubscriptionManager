import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/subscription_list.dart';
import '../widgets/large_screen_layout.dart';
import '../utils/responsive_layout.dart';
import '../providers/subscription_notifier.dart';

/// 大屏设备专用的首页组件
class LargeScreenHome extends ConsumerWidget {
  const LargeScreenHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // 欢迎区域
          _buildWelcomeSection(context),
          
          SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
          
          // 统计概览区域
          _buildStatisticsSection(context),
          
          SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
          
          // 订阅管理区域
          _buildSubscriptionSection(context),
        ],
      ),
    );
  }
  
  /// 构建欢迎区域
  Widget _buildWelcomeSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return LargeScreenCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '欢迎回来！',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '管理您的所有订阅服务',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.subscriptions,
              size: 48,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建统计概览区域
  Widget _buildStatisticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '统计概览',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
        
        // 使用网格布局展示统计卡片
        LargeScreenGrid(
          crossAxisCount: ResponsiveLayout.responsiveValue(
            context: context,
            mobile: 1,
            tablet: 2,
            desktop: 4,
          ),
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context,
              title: '总订阅数',
              value: '12',
              icon: Icons.subscriptions,
              color: Colors.blue,
            ),
            _buildStatCard(
              context,
              title: '月度支出',
              value: '¥299',
              icon: Icons.payment,
              color: Colors.green,
            ),
            _buildStatCard(
              context,
              title: '即将到期',
              value: '3',
              icon: Icons.schedule,
              color: Colors.orange,
            ),
            _buildStatCard(
              context,
              title: '年度支出',
              value: '¥3,588',
              icon: Icons.trending_up,
              color: Colors.purple,
            ),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.trending_up,
                color: Colors.green,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建订阅管理区域
  Widget _buildSubscriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '订阅管理',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // 添加订阅逻辑
              },
              icon: const Icon(Icons.add),
              label: const Text('添加订阅'),
            ),
          ],
        ),
        SizedBox(height: ResponsiveLayout.getCardSpacing(context)),
        
        // 订阅列表
        LargeScreenCard(
          child: Column(
            children: [
              // 列表头部
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        '服务名称',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '费用',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: Text(
                        '下次扣费',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Text(
                        '操作',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              // 订阅列表内容
              const SubscriptionList(
                shrinkWrap: true,
                showAsTable: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}