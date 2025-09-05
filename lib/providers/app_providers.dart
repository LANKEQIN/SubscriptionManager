import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/app_database.dart';
import '../cache/hive_service.dart';
import '../cache/cached_data.dart';
import '../repositories/repository_interfaces.dart';
import '../repositories/subscription_repository_impl.dart';
import '../repositories/monthly_history_repository_impl.dart';
import 'subscription_notifier.dart';
import 'package:subscription_manager/features/subscription_feature/di/subscription_di.dart';

part 'app_providers.g.dart';

/// 数据库Provider
/// 提供AppDatabase单例
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

/// 缓存Box Provider
/// 提供Hive缓存Box
@Riverpod(keepAlive: true)
Future<Box<CachedData>> cacheBox(Ref ref) async {
  await HiveService.initHive();
  return Hive.box<CachedData>('cache');
}

/// 用户偏好Box Provider
/// 提供用户偏好设置Box
@Riverpod(keepAlive: true)
Future<Box<String>> userPrefsBox(Ref ref) async {
  await HiveService.initHive();
  return Hive.box<String>('user_preferences');
}

/// 订阅仓储Provider
/// 提供SubscriptionRepository实例
@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return SubscriptionRepositoryImpl(database);
}

/// 月度历史仓储Provider
/// 提供MonthlyHistoryRepository实例
@Riverpod(keepAlive: true)
MonthlyHistoryRepository monthlyHistoryRepository(Ref ref) {
  final database = ref.watch(appDatabaseProvider);
  return MonthlyHistoryRepositoryImpl(database);
}

/// 应用初始化Provider
/// 处理应用启动时的所有初始化工作
@riverpod
Future<bool> appInitialization(Ref ref) async {
  try {
    // 初始化Hive缓存
    await HiveService.initHive();
    
    // 确保数据库连接正常
    ref.read(appDatabaseProvider);
    
    // 清理过期缓存
    await HiveService.cleanExpiredCache();
    
    // 可以在这里添加更多初始化逻辑，如数据迁移等
    
    return true;
  } catch (e) {
    throw Exception('应用初始化失败: $e');
  }
}

/// 缓存统计信息Provider
/// 提供缓存使用情况的统计信息
@riverpod
Future<Map<String, dynamic>> cacheStats(Ref ref) async {
  // 确保缓存已初始化
  await ref.watch(appInitializationProvider.future);
  
  return HiveService.getCacheStats();
}

/// 数据库统计信息Provider
/// 提供数据库使用情况的统计信息
@riverpod
Future<Map<String, dynamic>> databaseStats(Ref ref) async {
  final subscriptionRepo = ref.watch(subscriptionRepositoryProvider);
  final historyRepo = ref.watch(monthlyHistoryRepositoryProvider);
  
  try {
    final subscriptions = await subscriptionRepo.getAllSubscriptions();
    final histories = await historyRepo.getAllHistories();
    
    return {
      'total_subscriptions': subscriptions.length,
      'total_histories': histories.length,
      'active_subscriptions': subscriptions.where((s) => s.autoRenewal).length,
      'upcoming_subscriptions': subscriptions.where((s) => s.daysUntilPayment >= 0 && s.daysUntilPayment <= 7).length,
    };
  } catch (e) {
    return {
      'error': e.toString(),
    };
  }
}

/// 主题模式Provider
/// 提供当前主题模式
@riverpod
ThemeMode themeModeProvider(Ref ref) {
  return ref.watch(subscriptionNotifierProvider).maybeWhen(
    data: (state) => state.themeMode,
    orElse: () => ThemeMode.system,
  );
}

/// 字体大小Provider
/// 提供当前字体大小
@riverpod
double fontSizeProvider(Ref ref) {
  return ref.watch(subscriptionNotifierProvider).maybeWhen(
    data: (state) => state.fontSize,
    orElse: () => 14.0,
  );
}

/// 主题颜色Provider
/// 提供当前主题颜色
@riverpod
Color? themeColorProvider(Ref ref) {
  return ref.watch(subscriptionNotifierProvider).maybeWhen(
    data: (state) => state.themeColor,
    orElse: () => null,
  );
}

/// 基准货币Provider
/// 提供当前基准货币
@riverpod
String baseCurrencyProvider(Ref ref) {
  return ref.watch(subscriptionNotifierProvider).maybeWhen(
    data: (state) => state.baseCurrency,
    orElse: () => 'CNY',
  );
}

// 合并所有提供商
final appProviders = [
  appDatabaseProvider,
  cacheBoxProvider,
  userPrefsBoxProvider,
  subscriptionRepositoryProvider,
  monthlyHistoryRepositoryProvider,
  appInitializationProvider,
  cacheStatsProvider,
  databaseStatsProvider,
  themeModeProvider,
  fontSizeProvider,
  themeColorProvider,
  baseCurrencyProvider,
  subscriptionLocalDatasourceProvider,
  subscriptionRepositoryProvider,
  getAllSubscriptionsUseCaseProvider,
  subscriptionBlocProvider,
];
