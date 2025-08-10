import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription_provider.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('统计'),
        centerTitle: true,
      ),
      body: Consumer<SubscriptionProvider>(
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
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '订阅类型分布',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (dataMap.isNotEmpty)
                  Expanded(
                    child: PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 2.7,
                      colorList: [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.orange,
                        Colors.purple,
                      ],
                      initialAngleInDegree: 0,
                      chartType: ChartType.disc,
                      legendOptions: const LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
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
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        '暂无数据',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        _buildStatItem('月度支出', '¥${provider.monthlyCost.toStringAsFixed(2)}'),
                        const SizedBox(height: 8),
                        _buildStatItem('年度支出', '¥${provider.yearlyCost.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
}