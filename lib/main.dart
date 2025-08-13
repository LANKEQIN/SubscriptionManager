import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'add_button.dart';
import 'add_subscription_dialog.dart';
import 'subscription_provider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 提取文本主题样式为单独函数，避免重复代码
  TextTheme _buildTextTheme(double fontSize) {
    return TextTheme(
      bodyMedium: TextStyle(fontSize: fontSize, fontFamily: 'HarmonyOS Sans', fontFamilyFallback: ['Segoe UI', 'Roboto', 'sans-serif']),
      bodyLarge: TextStyle(fontSize: fontSize + 2, fontFamily: 'HarmonyOS Sans', fontFamilyFallback: ['Segoe UI', 'Roboto', 'sans-serif']),
      bodySmall: TextStyle(fontSize: fontSize - 2, fontFamily: 'HarmonyOS Sans', fontFamilyFallback: ['Segoe UI', 'Roboto', 'sans-serif']),
      titleLarge: TextStyle(fontSize: fontSize + 6, fontFamily: 'HarmonyOS Sans', fontFamilyFallback: ['Segoe UI', 'Roboto', 'sans-serif']),
      titleMedium: TextStyle(fontSize: fontSize + 4, fontFamily: 'HarmonyOS Sans', fontFamilyFallback: ['Segoe UI', 'Roboto', 'sans-serif']),
      titleSmall: TextStyle(fontSize: fontSize + 2, fontFamily: 'HarmonyOS Sans', fontFamilyFallback: ['Segoe UI', 'Roboto', 'sans-serif']),
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex > 1 ? _currentIndex + 1 : _currentIndex,
        onDestinationSelected: (index) {
          if (index == 2) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddSubscriptionDialog(
                  onSubscriptionAdded: (subscription) {
                    Provider.of<SubscriptionProvider>(context, listen: false)
                        .addSubscription(subscription);
                  },
                );
              },
            );
          } else {
            setState(() {
              // 调整索引以匹配页面列表
              _currentIndex = index > 2 ? index - 1 : index;
            });
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: '添加',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: '提醒',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}