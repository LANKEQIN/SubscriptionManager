import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/app_providers.dart';
import 'constants/theme_constants.dart';
import 'config/theme_builder.dart';

/// 应用程序入口点
/// 初始化并运行整个应用程序
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// 主应用程序类
/// 配置应用程序的主题、路由和整体结构
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 加载数据
    ref.listen(subscriptionProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        // 数据加载完成，可以在这里执行一些初始化操作
      }
    });
    
    // 监听并初始化加载数据
    final subscriptionNotifier = ref.read(subscriptionProvider.notifier);
    
    // 在build中加载数据（只加载一次）
    ref.listen(subscriptionProvider, (previous, next) {
      // 初始化时加载数据
    });
    
    // 使用Future.microtask确保在build完成后加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscriptionNotifier.loadFromPreferences();
    });
    
    final themeMode = ref.watch(themeModeProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final themeColor = ref.watch(themeColorProvider);
    
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // 获取颜色方案
        final colorSchemes = AppThemeBuilder.getColorSchemes(
          customColor: themeColor,
          lightDynamic: lightDynamic,
          darkDynamic: darkDynamic,
        );
        
        return MaterialApp(
          title: 'Subscription Manager',
          theme: AppThemeBuilder.buildLightTheme(
            colorSchemes.light, 
            fontSize
          ),
          darkTheme: AppThemeBuilder.buildDarkTheme(
            colorSchemes.dark, 
            fontSize
          ),
          themeMode: themeMode,
          home: const MainScreen(),
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