import 'package:flutter/material.dart';
import 'home_app_bar.dart';
import '../widgets/statistics_card.dart';
import '../widgets/subscription_list.dart';
import '../widgets/add_button.dart';
import '../constants/theme_constants.dart';
import '../features/subscription_feature/presentation/screens/subscription_main_screen.dart';

/// 主屏幕组件
/// 显示应用程序的主页，包括统计信息和订阅列表
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 检查是否应该使用Feature-First架构
    if (FeatureFlags.useFeatureFirst) {
      return const SubscriptionMainScreen();
    }

    return const Stack(
      children: [
        // 主要内容区域
        Column(
          children: [
            // 顶部应用栏
            HomeAppBar(),
            
            // 主页面内容（带有内边距）
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppThemeConstants.standardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 统计信息卡片
                    HomeStatisticsCard(),
                    
                    // 间隔
                    SizedBox(height: AppThemeConstants.standardPadding),
                    
                    // 订阅列表标题
                    Text(
                      '所有订阅',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // 间隔
                    SizedBox(height: AppThemeConstants.standardPadding),
                    
                    // 订阅项目列表
                    Expanded(
                      child: SubscriptionList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        // 添加订阅按钮
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: AddButton(),
        ),
      ],
    );
  }
}

class FeatureFlags {
  static const bool useFeatureFirst = false; // 设置为true以启用Feature-First架构
}