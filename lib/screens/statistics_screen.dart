import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../widgets/statistics_card.dart';
import '../utils/currency_constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () => _showCurrencySelector(context),
          ),
        ],
      ),
      body: Consumer<SubscriptionProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // 统计概览卡片
              StatisticsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '统计概览',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatItem('订阅总数', '${provider.subscriptionCount}个'),
                    const SizedBox(height: 8),
                    _buildStatItem(
                      '月度支出', 
                      '${_getCurrencySymbol(provider.baseCurrency)}${provider.monthlyCost.toStringAsFixed(2)}'
                    ),
                    const SizedBox(height: 8),
                    _buildStatItem(
                      '年度支出', 
                      '${_getCurrencySymbol(provider.baseCurrency)}${provider.yearlyCost.toStringAsFixed(2)}'
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 类型分布卡片
              StatisticsCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '类型分布',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTypeDistribution(provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  // 构建类型分布图表
  Widget _buildTypeDistribution(SubscriptionProvider provider) {
    final typeStats = provider.getTypeStats();
    if (typeStats.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }
    
    final total = typeStats.values.fold(0.0, (sum, item) => sum + item);
    if (total == 0) {
      return const Center(
        child: Text('暂无数据'),
      );
    }
    
    // 按值排序，从大到小
    final sortedEntries = typeStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Column(
      children: sortedEntries.map((entry) {
        final percentage = (entry.value / total) * 100;
        return _buildTypeItem(entry.key, entry.value, percentage, provider.baseCurrency);
      }).toList(),
    );
  }
  
  // 构建单个类型项
  Widget _buildTypeItem(String type, double value, double percentage, String currency) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                '${_getCurrencySymbol(currency)}${value.toStringAsFixed(2)} (${percentage.toStringAsFixed(1)}%)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
  
  // 获取货币符号
  String _getCurrencySymbol(String currencyCode) {
    return currencySymbols[currencyCode] ?? currencyCode;
  }
  
  // 显示货币选择对话框
  void _showCurrencySelector(BuildContext context) {
    final provider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '选择基准货币',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _currencies.length,
                  itemBuilder: (context, index) {
                    final currencyCode = _currencies.keys.elementAt(index);
                    final currencyName = _currencies.values.elementAt(index);
                    
                    return RadioListTile<String>(
                      title: Text(currencyName),
                      value: currencyCode,
                      groupValue: provider.baseCurrency,
                      onChanged: (value) {
                        if (value != null) {
                          provider.setBaseCurrency(value);
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}