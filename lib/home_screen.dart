import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription.dart';
import 'subscription_provider.dart';
import 'edit_subscription_dialog.dart';
import 'home_app_bar.dart';
import 'statistics_card.dart';
import 'subscription_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeAppBar(),
        // 主页面内容
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 添加统计卡片
                const StatisticsCard(),
                const SizedBox(height: 16),
                const Text(
                  '所有订阅',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const SubscriptionList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}










