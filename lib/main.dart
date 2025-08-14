import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/add_button.dart';
import 'dialogs/add_subscription_dialog.dart';
import 'providers/subscription_provider.dart';

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

  // 定义常量
  static const List<String> _fontFamilies = ['HarmonyOS Sans', 'Segoe UI', 'Roboto', 'sans-serif'];

  // 统一字体尺寸计算方法
  double _calculateFontSize(double baseSize, int increment) {
    return baseSize + increment;
  }

  // 提取文本主题样式为单独函数，避免重复代码
  TextTheme _buildTextTheme(double fontSize) {
    return TextTheme(
      bodyMedium: TextStyle(
        fontSize: _calculateFontSize(fontSize, 0),
        fontFamily: _fontFamilies[0],
        fontFamilyFallback: _fontFamilies.sublist(1),
      ),
      bodyLarge: TextStyle(
        fontSize: _calculateFontSize(fontSize, 2),
        fontFamily: _fontFamilies[0],
        fontFamilyFallback: _fontFamilies.sublist(1),
      ),
      bodySmall: TextStyle(
        fontSize: _calculateFontSize(fontSize, -2),
        fontFamily: _fontFamilies[0],
        fontFamilyFallback: _fontFamilies.sublist(1),
      ),
      titleLarge: TextStyle(
        fontSize: _calculateFontSize(fontSize, 6),
        fontFamily: _fontFamilies[0],
        fontFamilyFallback: _fontFamilies.sublist(1),
      ),
      titleMedium: TextStyle(
        fontSize: _calculateFontSize(fontSize, 4),
        fontFamily: _fontFamilies[0],
        fontFamilyFallback: _fontFamilies.sublist(1),
      ),
      titleSmall: TextStyle(
        fontSize: _calculateFontSize(fontSize, 2),
        fontFamily: _fontFamilies[0],
        fontFamilyFallback: _fontFamilies.sublist(1),
      ),
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, provider, child) {
        // 根据选择的颜色确定主题色
        Color seedColor = provider.themeColor ?? Colors.deepPurple;
        
        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            // 如果用户选择了特定颜色，则使用该颜色；否则尝试使用系统动态颜色
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;
            
            if (provider.themeColor != null) {
              // 用户选择了特定颜色
              lightColorScheme = ColorScheme.fromSeed(seedColor: provider.themeColor!);
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: provider.themeColor!, 
                brightness: Brightness.dark,
              );
            } else if (lightDynamic != null && darkDynamic != null) {
              // 使用系统动态颜色
              lightColorScheme = lightDynamic;
              darkColorScheme = darkDynamic;
            } else {
              // 回退到默认颜色
              lightColorScheme = ColorScheme.fromSeed(seedColor: seedColor);
              darkColorScheme = ColorScheme.fromSeed(
                seedColor: seedColor, 
                brightness: Brightness.dark,
              );
            }
            
            return MaterialApp(
              title: 'Subscription Manager',
              theme: ThemeData(
                colorScheme: lightColorScheme,
                useMaterial3: true,
                fontFamily: 'HarmonyOS Sans',
                textTheme: _buildTextTheme(provider.fontSize),
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                useMaterial3: true,
                fontFamily: 'HarmonyOS Sans',
                textTheme: _buildTextTheme(provider.fontSize),
              ),
              themeMode: provider.themeMode,
              home: const MainScreen(),
            );
          }
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
          bool isSmallScreen = constraints.maxWidth < 350;
          double iconSize = isSmallScreen ? 20 : 24;
          double labelSize = isSmallScreen ? 10 : 12;
          
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
            height: isSmallScreen ? 60 : 80,
          );
        },
      ),
    );
  }
}