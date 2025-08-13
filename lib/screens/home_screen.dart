import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../dialogs/edit_subscription_dialog.dart';
import 'home_app_bar.dart';
import '../widgets/statistics_card.dart';
import '../widgets/subscription_list.dart';
import '../widgets/add_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
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
        ),
        // 添加按钮放置在右下角
        Positioned(
          right: 16,
          bottom: 16,
          child: AddButton(
            onSubscriptionAdded: (subscription) {
              Provider.of<SubscriptionProvider>(context, listen: false)
                  .addSubscription(subscription);
            },
          ),
        ),
      ],
    );
  }
}










