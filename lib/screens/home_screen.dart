import 'package:flutter/material.dart';
import 'home_app_bar.dart';
import '../widgets/statistics_card.dart';
import '../widgets/subscription_list.dart';
import '../widgets/add_button.dart';
import '../constants/theme_constants.dart';
import '../features/subscription_feature/presentation/screens/subscription_main_screen.dart';
import '../utils/responsive_layout.dart';
import 'large_screen_home.dart';

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
    
    // 检查是否为大屏设备
    if (ResponsiveLayout.isLargeScreen(context)) {
      return const LargeScreenHome();
    }

    // 手机设备使用原有布局
    return Scaffold(
      body: Column(
        children: [
          // 顶部应用栏
          const HomeAppBar(),
          
          // 可滚动的主要内容区域
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 统计信息卡片
                  const HomeStatisticsCard(),
                  
                  // 间隔
                  const SizedBox(height: AppThemeConstants.standardPadding),
                  
                  // 订阅列表标题
                  const Text(
                    '所有订阅',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  // 间隔
                  const SizedBox(height: AppThemeConstants.standardPadding),
                  
                  // 订阅项目列表 - 使用shrinkWrap让它适应内容高度
                  const SubscriptionList(shrinkWrap: true),
                  
                  // 底部额外间距，为悬浮按钮留出空间
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      // 悬浮添加按钮
      floatingActionButton: const AddButton(),
    );
  }
}

class FeatureFlags {
  static const bool useFeatureFirst = false; // 设置为true以启用Feature-First架构
}