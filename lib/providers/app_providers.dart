import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../fixed_exchange_rate_service.dart';
import '../models/subscription.dart';
import '../models/subscription_state.dart';
import 'subscription_notifier.dart';

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<Future<SharedPreferences>>((ref) async {
  return SharedPreferences.getInstance();
});

/// 汇率转换服务 Provider
final exchangeRateServiceProvider = Provider<FixedExchangeRateService>((ref) {
  return FixedExchangeRateService();
});

/// 主要的订阅状态管理 Provider
final subscriptionProvider = StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
  return SubscriptionNotifier();
});

/// 订阅列表选择器
final subscriptionsProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.subscriptions));
});

/// 月度历史选择器
final monthlyHistoriesProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.monthlyHistories));
});

/// 主题模式选择器
final themeModeProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.themeMode));
});

/// 字体大小选择器
final fontSizeProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.fontSize));
});

/// 主题颜色选择器
final themeColorProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.themeColor));
});

/// 未读通知状态选择器
final hasUnreadNotificationsProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.hasUnreadNotifications));
});

/// 基准货币选择器
final baseCurrencyProvider = Provider<String>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.baseCurrency));
});

/// 加载状态选择器
final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.isLoading));
});

/// 错误状态选择器
final errorProvider = Provider<String?>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.error));
});

/// 即将到期的订阅选择器
final upcomingSubscriptionsProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.upcomingSubscriptions));
});

/// 已过期的订阅选择器
final expiredSubscriptionsProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.expiredSubscriptions));
});

/// 按类型分组的订阅选择器
final subscriptionsByTypeProvider = Provider((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.subscriptionsByType));
});

/// 总月度成本选择器
final totalMonthlyCostProvider = Provider<double>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.totalMonthlyCost));
});

/// 总年度成本选择器
final totalYearlyCostProvider = Provider<double>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.totalYearlyCost));
});

/// 订阅数量选择器
final subscriptionCountProvider = Provider<int>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.subscriptions.length));
});

/// 是否有订阅选择器
final hasSubscriptionsProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.hasSubscriptions));
});

/// 是否有错误选择器
final hasErrorProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider.select((state) => state.hasError));
});

/// 月度费用计算 Provider（通过 Notifier 方法）
final monthlyCostProvider = Provider<double>((ref) {
  final notifier = ref.read(subscriptionProvider.notifier);
  return notifier.getMonthlyCost();
});

/// 年度费用计算 Provider（通过 Notifier 方法）
final yearlyCostProvider = Provider<double>((ref) {
  final notifier = ref.read(subscriptionProvider.notifier);
  return notifier.getYearlyCost();
});

/// 类型统计 Provider
final typeStatsProvider = Provider<Map<String, double>>((ref) {
  final notifier = ref.read(subscriptionProvider.notifier);
  return notifier.getTypeStats();
});

/// 月度成本变化百分比 Provider
final monthlyCostChangePercentageProvider = Provider<double>((ref) {
  final notifier = ref.read(subscriptionProvider.notifier);
  return notifier.getMonthlyCostChangePercentage();
});

/// 支持的货币列表 Provider
final supportedCurrenciesProvider = Provider<List<String>>((ref) {
  final notifier = ref.read(subscriptionProvider.notifier);
  return notifier.getSupportedCurrencies();
});

/// 上个月历史记录 Provider
final previousMonthHistoryProvider = Provider((ref) {
  final notifier = ref.read(subscriptionProvider.notifier);
  return notifier.getPreviousMonthHistory();
});

/// 根据ID获取订阅的 Provider
final subscriptionByIdProvider = Provider.family<Subscription?, String>((ref, id) {
  final subscriptions = ref.watch(subscriptionsProvider);
  try {
    return subscriptions.firstWhere((s) => s.id == id);
  } catch (e) {
    return null;
  }
});