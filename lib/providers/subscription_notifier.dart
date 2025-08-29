import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import '../models/subscription_state.dart';
import '../fixed_exchange_rate_service.dart';
import '../utils/user_preferences.dart';
import '../services/migration_service.dart';
import 'app_providers.dart';

part 'subscription_notifier.g.dart';

/// 升级后的订阅状态管理器
/// 使用Repository模式和现代Riverpod架构
@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  final FixedExchangeRateService _exchangeRateService = FixedExchangeRateService();
  
  @override
  Future<SubscriptionState> build() async {
    // 等待应用初始化完成
    await ref.watch(appInitializationProvider.future);
    
    // 获取仓储实例
    final subscriptionRepo = ref.watch(subscriptionRepositoryProvider);
    final historyRepo = ref.watch(monthlyHistoryRepositoryProvider);
    
    // 执行数据迁移（如果需要）
    await _performMigrationIfNeeded();
    
    // 加载数据
    final subscriptions = await subscriptionRepo.getAllSubscriptions();
    final histories = await historyRepo.getAllHistories();
    
    // 加载用户偏好设置
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
    final themeMode = ThemeMode.values[themeModeIndex];
    final fontSize = prefs.getDouble('font_size') ?? 14.0;
    final themeColorValue = prefs.getInt('theme_color');
    final themeColor = themeColorValue != null ? Color(themeColorValue) : null;
    final baseCurrency = await UserPreferences.getBaseCurrency();
    
    // 检查是否有未读通知
    final hasUnreadNotifications = _checkUnreadNotifications(subscriptions);
    
    return SubscriptionState(
      subscriptions: subscriptions,
      monthlyHistories: histories,
      themeMode: themeMode,
      fontSize: fontSize,
      themeColor: themeColor,
      baseCurrency: baseCurrency,
      hasUnreadNotifications: hasUnreadNotifications,
      isLoading: false,
    );
  }

  /// 执行数据迁移（如果需要）
  Future<void> _performMigrationIfNeeded() async {
    try {
      final database = ref.read(appDatabaseProvider);
      final subscriptionRepo = ref.read(subscriptionRepositoryProvider);
      final historyRepo = ref.read(monthlyHistoryRepositoryProvider);
      
      final migrationService = MigrationService(
        database,
        subscriptionRepo,
        historyRepo,
      );
      
      await migrationService.checkAndMigrate();
    } catch (e) {
      debugPrint('数据迁移过程中发生错误: $e');
      // 迁移失败不应阻止应用启动
    }
  }

  /// 添加订阅
  Future<void> addSubscription(Subscription subscription) async {
    try {
      // 1. 乐观更新UI（立即响应）
      final currentState = await future;
      final updatedSubscriptions = [...currentState.subscriptions, subscription];
      
      // 重新计算统计信息
      final hasUnreadNotifications = _checkUnreadNotifications(updatedSubscriptions);
      
      // 2. 立即更新状态
      state = AsyncValue.data(currentState.copyWith(
        subscriptions: updatedSubscriptions,
        hasUnreadNotifications: hasUnreadNotifications,
      ));
      
      // 3. 后台异步持久化
      _persistSubscriptionInBackground(subscription);
      
    } catch (e) {
      // 4. 失败时回滚状态
      ref.invalidateSelf();
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 删除订阅
  Future<void> removeSubscription(String id) async {
    try {
      // 1. 乐观更新UI（立即响应）
      final currentState = await future;
      final updatedSubscriptions = currentState.subscriptions
          .where((s) => s.id != id)
          .toList();
      
      // 重新计算统计信息
      final hasUnreadNotifications = _checkUnreadNotifications(updatedSubscriptions);
      
      // 2. 立即更新状态
      state = AsyncValue.data(currentState.copyWith(
        subscriptions: updatedSubscriptions,
        hasUnreadNotifications: hasUnreadNotifications,
      ));
      
      // 3. 后台异步持久化
      _removeSubscriptionInBackground(id);
      
    } catch (e) {
      // 4. 失败时回滚状态
      ref.invalidateSelf();
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 更新订阅
  Future<void> updateSubscription(Subscription updatedSubscription) async {
    try {
      // 1. 乐观更新UI（立即响应）
      final currentState = await future;
      final updatedSubscriptions = currentState.subscriptions
          .map((s) => s.id == updatedSubscription.id ? updatedSubscription : s)
          .toList();
      
      // 重新计算统计信息
      final hasUnreadNotifications = _checkUnreadNotifications(updatedSubscriptions);
      
      // 2. 立即更新状态
      state = AsyncValue.data(currentState.copyWith(
        subscriptions: updatedSubscriptions,
        hasUnreadNotifications: hasUnreadNotifications,
      ));
      
      // 3. 后台异步持久化
      _updateSubscriptionInBackground(updatedSubscription);
      
    } catch (e) {
      // 4. 失败时回滚状态
      ref.invalidateSelf();
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 更新当前月度历史
  Future<void> _updateCurrentMonthHistory() async {
    try {
      final subscriptionRepo = ref.read(subscriptionRepositoryProvider);
      final historyRepo = ref.read(monthlyHistoryRepositoryProvider);
      
      final subscriptions = await subscriptionRepo.getAllSubscriptions();
      await historyRepo.updateCurrentMonthHistory(subscriptions);
    } catch (e) {
      debugPrint('更新月度历史失败: $e');
    }
  }

  /// 后台持久化订阅（不阻塞UI）
  Future<void> _persistSubscriptionInBackground(Subscription subscription) async {
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.addSubscription(subscription);
      await _updateCurrentMonthHistory();
      
      debugPrint('订阅持久化成功: ${subscription.name}');
    } catch (e) {
      debugPrint('订阅持久化失败: $e');
      // 失败时重新加载数据
      ref.invalidateSelf();
    }
  }

  /// 后台删除订阅（不阻塞UI）
  Future<void> _removeSubscriptionInBackground(String id) async {
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.deleteSubscription(id);
      await _updateCurrentMonthHistory();
      
      debugPrint('订阅删除成功: $id');
    } catch (e) {
      debugPrint('订阅删除失败: $e');
      // 失败时重新加载数据
      ref.invalidateSelf();
    }
  }

  /// 后台更新订阅（不阻塞UI）
  Future<void> _updateSubscriptionInBackground(Subscription subscription) async {
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.updateSubscription(subscription);
      await _updateCurrentMonthHistory();
      
      debugPrint('订阅更新成功: ${subscription.name}');
    } catch (e) {
      debugPrint('订阅更新失败: $e');
      // 失败时重新加载数据
      ref.invalidateSelf();
    }
  }

  /// 检查未读通知
  bool _checkUnreadNotifications(List<Subscription> subscriptions) {
    return subscriptions.any((subscription) {
      final daysUntil = subscription.daysUntilPayment;
      return daysUntil >= 0 && daysUntil <= 7;
    });
  }

  /// 清除错误
  void clearError() {
    ref.invalidateSelf();
  }





  /// 根据ID获取订阅
  Future<Subscription?> getSubscriptionById(String id) async {
    final currentState = await future;
    try {
      return currentState.subscriptions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取月度总费用（转换为基准货币）
  Future<double> getMonthlyCost() async {
    final currentState = await future;
    double total = 0;
    for (var subscription in currentState.subscriptions) {
      double amount = 0;
      if (subscription.billingCycle == '每月') {
        amount = subscription.price;
      } else if (subscription.billingCycle == '每年') {
        amount = subscription.price / 12;
      }

      // 转换为基准货币
      final convertedAmount = _exchangeRateService.convertCurrency(
        amount,
        subscription.currency,
        currentState.baseCurrency,
      );
      total += convertedAmount;
    }
    return total;
  }

  /// 获取年度总费用（转换为基准货币）
  Future<double> getYearlyCost() async {
    final currentState = await future;
    double total = 0;
    for (var subscription in currentState.subscriptions) {
      double amount = 0;
      if (subscription.billingCycle == '每月') {
        amount = subscription.price * 12;
      } else if (subscription.billingCycle == '每年') {
        amount = subscription.price;
      } else if (subscription.billingCycle == '一次性') {
        amount = subscription.price;
      }

      // 转换为基准货币
      final convertedAmount = _exchangeRateService.convertCurrency(
        amount,
        subscription.currency,
        currentState.baseCurrency,
      );
      total += convertedAmount;
    }
    return total;
  }

  /// 按类型分组统计费用
  Future<Map<String, double>> getTypeStats() async {
    final currentState = await future;
    final typeStats = <String, double>{};

    for (var subscription in currentState.subscriptions) {
      double amount = subscription.price;
      if (subscription.billingCycle == '每年') {
        amount = subscription.price / 12; // 转换为月费用进行比较
      }

      // 转换为基准货币
      final convertedAmount = _exchangeRateService.convertCurrency(
        amount,
        subscription.currency,
        currentState.baseCurrency,
      );

      if (typeStats.containsKey(subscription.type)) {
        typeStats[subscription.type] = typeStats[subscription.type]! + convertedAmount;
      } else {
        typeStats[subscription.type] = convertedAmount;
      }
    }

    return typeStats;
  }

  /// 获取上个月的历史记录
  Future<MonthlyHistory?> getPreviousMonthHistory() async {
    final currentState = await future;
    final now = DateTime.now();
    final previousMonth = now.month == 1 ? 12 : now.month - 1;
    final previousYear = now.month == 1 ? now.year - 1 : now.year;

    try {
      return currentState.monthlyHistories.firstWhere(
        (history) => history.year == previousYear && history.month == previousMonth,
      );
    } on StateError {
      return null;
    }
  }

  /// 计算与上个月相比的变化百分比
  Future<double> getMonthlyCostChangePercentage() async {
    final previousMonthHistory = await getPreviousMonthHistory();
    if (previousMonthHistory == null) {
      return 0.0;
    }

    final currentCost = await getMonthlyCost();
    final previousCost = previousMonthHistory.totalAmount;

    if (previousCost == 0) {
      return 0.0;
    }

    return ((currentCost - previousCost) / previousCost) * 100;
  }

  /// 获取支持的货币列表
  List<String> getSupportedCurrencies() {
    return _exchangeRateService.getSupportedCurrencies();
  }

  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    try {
      // 1. 立即更新状态（乐观更新）
      final currentState = await future;
      state = AsyncValue.data(currentState.copyWith(themeMode: mode));
      
      // 2. 后台持久化
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('theme_mode', mode.index);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 更新字体大小
  Future<void> updateFontSize(double size) async {
    try {
      // 1. 立即更新状态（乐观更新）
      final currentState = await future;
      state = AsyncValue.data(currentState.copyWith(fontSize: size));
      
      // 2. 后台持久化
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('font_size', size);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 更新主题颜色
  Future<void> updateThemeColor(Color? color) async {
    try {
      // 1. 立即更新状态（乐观更新）
      final currentState = await future;
      state = AsyncValue.data(currentState.copyWith(themeColor: color));
      
      // 2. 后台持久化
      final prefs = await SharedPreferences.getInstance();
      if (color != null) {
        await prefs.setInt('theme_color', color.toARGB32());
      } else {
        await prefs.remove('theme_color');
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 标记通知为已读
  void markNotificationsAsRead() {
    try {
      final currentState = state.valueOrNull;
      if (currentState != null) {
        state = AsyncValue.data(currentState.copyWith(
          hasUnreadNotifications: false,
        ));
      }
      debugPrint('通知已标记为已读');
    } catch (e) {
      debugPrint('标记通知失败: $e');
    }
  }

  /// 设置基准货币
  Future<void> setBaseCurrency(String currencyCode) async {
    try {
      // 1. 立即更新状态（乐观更新）
      final currentState = await future;
      state = AsyncValue.data(currentState.copyWith(baseCurrency: currencyCode));
      
      // 2. 后台持久化
      await UserPreferences.setBaseCurrency(currencyCode);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}