import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/subscription_provider.dart';
import 'constants/theme_constants.dart';
import 'config/theme_builder.dart';

/// 应用程序入口点
/// 初始化并运行整个应用程序
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 创建SubscriptionProvider实例并加载数据
  final provider = SubscriptionProvider();
  await provider.loadFromPrefs();
  
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const MyApp(),
    ),
  );
}

/// 主应用程序类
/// 配置应用程序的主题、路由和整体结构
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            // 获取颜色方案
            final colorSchemes = AppThemeBuilder.getColorSchemes(
              customColor: provider.themeColor,
              lightDynamic: lightDynamic,
              darkDynamic: darkDynamic,
            );
            
            return MaterialApp(
              title: 'Subscription Manager',
              theme: AppThemeBuilder.buildLightTheme(
                colorSchemes.light, 
                provider.fontSize
              ),
              darkTheme: AppThemeBuilder.buildDarkTheme(
                colorSchemes.dark, 
                provider.fontSize
              ),
              themeMode: provider.themeMode,
              home: const MainScreen(),
            );
          },
        );
      },
    );
  }
}

/// 主屏幕组件
/// 包含底部导航栏和各个页面的容器
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

/// 主屏幕状态类
/// 管理当前选中的页面和底部导航栏状态
class _MainScreenState extends State<MainScreen> {
  /// 当前选中的页面索引
  int _currentIndex = 0;

  // 页面列表
  final List<Widget> _pages = [
    const HomeScreen(),
    const StatisticsScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = ThemeConfigHelper.isSmallScreen(constraints.maxWidth);
          final iconSize = ThemeConfigHelper.getIconSize(isSmallScreen);
          final navigationBarHeight = ThemeConfigHelper.getNavigationBarHeight(isSmallScreen);
          
          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, size: iconSize),
                selectedIcon: Icon(Icons.home, size: iconSize),
                label: '首页',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined, size: iconSize),
                selectedIcon: Icon(Icons.bar_chart, size: iconSize),
                label: '统计',
              ),
              NavigationDestination(
                icon: Icon(Icons.notifications_outlined, size: iconSize),
                selectedIcon: Icon(Icons.notifications, size: iconSize),
                label: '提醒',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined, size: iconSize),
                selectedIcon: Icon(Icons.person, size: iconSize),
                label: '我的',
              ),
            ],
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            height: navigationBarHeight,
          );
        },
      ),
    );
  }
}