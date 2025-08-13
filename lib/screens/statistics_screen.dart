import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 模拟加载延迟
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<SubscriptionProvider>(
              builder: (context, provider, child) {
                // 按类型分组统计
                final typeStats = <String, double>{};
                final typeCounts = <String, int>{};
                
                for (var subscription in provider.subscriptions) {
                  if (typeStats.containsKey(subscription.type)) {
                    typeStats[subscription.type] = 
                        typeStats[subscription.type]! + subscription.price;
                    typeCounts[subscription.type] = typeCounts[subscription.type]! + 1;
                  } else {
                    typeStats[subscription.type] = subscription.price;
                    typeCounts[subscription.type] = 1;
                  }
                }
                
                // 准备饼图数据
                final dataMap = <String, double>{};
                typeStats.forEach((key, value) {
                  dataMap[key] = value;
                });
                
                return LayoutBuilder(
                  builder: (context, constraints) {
                    bool isSmallScreen = constraints.maxWidth < 400;
                    double chartSize = isSmallScreen 
                        ? constraints.maxWidth * 0.7 
                        : constraints.maxWidth / 2.7;
                    
                    return Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '订阅类型分布',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (dataMap.isNotEmpty)
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PieChart(
                                      dataMap: dataMap,
                                      animationDuration: const Duration(milliseconds: 800),
                                      chartLegendSpacing: isSmallScreen ? 20 : 32,
                                      chartRadius: chartSize,
                                      colorList: [
                                        Colors.blue,
                                        Colors.red,
                                        Colors.green,
                                        Colors.orange,
                                        Colors.purple,
                                        Colors.teal,
                                        Colors.pink,
                                      ],
                                      initialAngleInDegree: 0,
                                      chartType: ChartType.disc,
                                      legendOptions: LegendOptions(
                                        showLegendsInRow: false,
                                        legendPosition: LegendPosition.right,
                                        showLegends: true,
                                        legendShape: BoxShape.circle,
                                        legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: isSmallScreen ? 12 : 14,
                                        ),
                                      ),
                                      chartValuesOptions: const ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: true,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.insert_chart_outlined,
                                      size: isSmallScreen ? 48 : 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '暂无数据',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 16 : 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '添加订阅后将在此显示统计信息',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '统计概览',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 16 : 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildStatItem('订阅总数', '${provider.subscriptionCount}个', isSmallScreen),
                                  const SizedBox(height: 8),
                                  _buildStatItem('月度支出', '¥${provider.monthlyCost.toStringAsFixed(2)}', isSmallScreen),
                                  const SizedBox(height: 8),
                                  _buildStatItem('年度支出', '¥${provider.yearlyCost.toStringAsFixed(2)}', isSmallScreen),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
  
  Widget _buildStatItem(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}