import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/home_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/app_providers.dart';
import 'providers/subscription_notifier.dart';
import 'models/subscription_state.dart';
import 'config/theme_builder.dart';
import 'config/supabase_config.dart';
import 'services/migration_service.dart';
import 'widgets/sync_indicator.dart';
import 'utils/responsive_layout.dart';
import 'widgets/large_screen_layout.dart';

/// 应用程序入口点
/// 初始化并运行整个应用程序
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 初始化Supabase
    await SupabaseConfig.initialize();
    debugPrint('Supabase初始化成功');
  } catch (e) {
    debugPrint('Supabase初始化失败: $e');
    // 即使Supabase初始化失败，应用仍可以正常运行（仅限本地功能）
  }
  
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
    // 等待应用初始化完成
    final initializationState = ref.watch(appInitializationProvider);
    
    // 加载订阅数据
    final subscriptionState = ref.watch(subscriptionNotifierProvider);
    
    // 执行数据迁移（在后台进行）
    ref.listen(migrationServiceProvider, (previous, next) {
      if (previous == null) {
        // 首次初始化时执行迁移
        next.checkAndMigrate().then((success) {
          if (success) {
            debugPrint('数据迁移成功');
          } else {
            debugPrint('数据迁移失败');
          }
        });
      }
    });
    
    // 如果初始化失败，显示错误页面
    return initializationState.when(
      data: (initialized) {
        if (!initialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('初始化失败'),
              ),
            ),
          );
        }
        
        // 获取主题设置
        return subscriptionState.when(
          data: (state) => _buildApp(context, ref, state),
          loading: () => const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, stack) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('加载失败: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(subscriptionNotifierProvider);
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('初始化中...'),
              ],
            ),
          ),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('初始化失败: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(appInitializationProvider);
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildApp(BuildContext context, WidgetRef ref, SubscriptionState state) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        // 获取颜色方案
        final colorSchemes = AppThemeBuilder.getColorSchemes(
          customColor: state.themeColor,
          lightDynamic: lightDynamic,
          darkDynamic: darkDynamic,
        );
        
        return MaterialApp(
          title: 'Subscription Manager',
          theme: AppThemeBuilder.buildLightTheme(
            colorSchemes.light, 
            state.fontSize
          ),
          darkTheme: AppThemeBuilder.buildDarkTheme(
            colorSchemes.dark, 
            state.fontSize
          ),
          themeMode: state.themeMode,
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
  static const List<Widget> _pages = [
    HomeScreen(),
    StatisticsScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // 检查是否为大屏设备
    if (ResponsiveLayout.isLargeScreen(context)) {
      return _buildLargeScreenLayout(context);
    }
    
    // 手机设备使用原有布局
    return Scaffold(
      body: Stack(
        children: [
          // 主要内容
          _pages[_currentIndex],
          // 同步状态指示器（浮动在内容之上）
          const SyncIndicator(),
        ],
      ),
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
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
  
  /// 构建大屏设备布局
  Widget _buildLargeScreenLayout(BuildContext context) {
    final titles = ['首页', '统计', '提醒', '我的'];
    
    return LargeScreenLayout(
      selectedIndex: _currentIndex,
      onDestinationSelected: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      title: titles[_currentIndex],
      child: _pages[_currentIndex],
    );
  }
}