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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SubscriptionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                textTheme: TextTheme(
                  bodyMedium: TextStyle(fontSize: provider.fontSize),
                  bodyLarge: TextStyle(fontSize: provider.fontSize + 2),
                  bodySmall: TextStyle(fontSize: provider.fontSize - 2),
                  titleLarge: TextStyle(fontSize: provider.fontSize + 6),
                  titleMedium: TextStyle(fontSize: provider.fontSize + 4),
                  titleSmall: TextStyle(fontSize: provider.fontSize + 2),
                ),
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                useMaterial3: true,
                textTheme: TextTheme(
                  bodyMedium: TextStyle(fontSize: provider.fontSize),
                  bodyLarge: TextStyle(fontSize: provider.fontSize + 2),
                  bodySmall: TextStyle(fontSize: provider.fontSize - 2),
                  titleLarge: TextStyle(fontSize: provider.fontSize + 6),
                  titleMedium: TextStyle(fontSize: provider.fontSize + 4),
                  titleSmall: TextStyle(fontSize: provider.fontSize + 2),
                ),
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
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
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
      floatingActionButton: Consumer<SubscriptionProvider>(
        builder: (context, subscriptionProvider, child) {
          return AddButton(
            onSubscriptionAdded: (subscription) {
              subscriptionProvider.addSubscription(subscription);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}