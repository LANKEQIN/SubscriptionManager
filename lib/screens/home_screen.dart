import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subscription.dart';
import '../providers/subscription_provider.dart';
import '../dialogs/edit_subscription_dialog.dart';
import 'home_app_bar.dart';
import '../widgets/statistics_card.dart';
import '../widgets/subscription_list.dart';
import '../widgets/add_button.dart';

/// 主屏幕组件
/// 显示应用程序的主页，包括统计信息和订阅列表
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 主要内容区域
        Column(
          children: [
            // 顶部应用栏
            const HomeAppBar(),
            
            // 主页面内容（带有内边距）
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 统计信息卡片
                    const StatisticsCard(),
                    
                    // 间隔
                    const SizedBox(height: 16),
                    
                    // 订阅列表标题
                    const Text(
                      '所有订阅',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // 间隔
                    const SizedBox(height: 16),
                    
                    // 订阅项目列表
                    const SubscriptionList(),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // 右下角添加按钮
        Positioned(
          right: 16,
          bottom: 16,
          child: AddButton(
            onSubscriptionAdded: (subscription) {
              // 当添加新订阅时，通过Provider更新订阅列表
              Provider.of<SubscriptionProvider>(context, listen: false)
                  .addSubscription(subscription);
            },
          ),
        ),
      ],
    );
  }
}










