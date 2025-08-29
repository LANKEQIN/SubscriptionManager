import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import '../models/subscription_state.dart';
import '../fixed_exchange_rate_service.dart';
import '../utils/user_preferences.dart';

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  SubscriptionNotifier() : super(const SubscriptionState());

  final FixedExchangeRateService _exchangeRateService = FixedExchangeRateService();

  /// 从SharedPreferences加载数据
  Future<void> loadFromPreferences() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prefs = await SharedPreferences.getInstance();

      // 加载订阅数据
      List<Subscription> subscriptions = [];
      final subscriptionsString = prefs.getString('subscriptions');
      if (subscriptionsString != null) {
        final List<dynamic> subscriptionsJson = json.decode(subscriptionsString);
        subscriptions = subscriptionsJson
            .map((json) => Subscription.fromMap(json))
            .toList();
      }

      // 加载月度历史数据
      List<MonthlyHistory> monthlyHistories = [];
      final monthlyHistoriesString = prefs.getString('monthlyHistories');
      if (monthlyHistoriesString != null) {
        final List<dynamic> monthlyHistoriesJson = json.decode(monthlyHistoriesString);
        monthlyHistories = monthlyHistoriesJson
            .map((json) => MonthlyHistory.fromMap(json))
            .toList();
      }

      // 加载主题设置
      final themeModeIndex = prefs.getInt('themeMode') ?? 0;
      final themeMode = ThemeMode.values[themeModeIndex];
      final fontSize = prefs.getDouble('fontSize') ?? 14.0;
      final themeColorValue = prefs.getInt('themeColor');
      final themeColor = themeColorValue != null ? Color(themeColorValue) : null;

      // 加载基准货币
      final baseCurrency = await UserPreferences.getBaseCurrency();

      // 检查是否有未读通知
      final hasUnreadNotifications = _checkUnreadNotifications(subscriptions);

      state = state.copyWith(
        subscriptions: subscriptions,
        monthlyHistories: monthlyHistories,
        themeMode: themeMode,
        fontSize: fontSize,
        themeColor: themeColor,
        baseCurrency: baseCurrency,
        hasUnreadNotifications: hasUnreadNotifications,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '加载数据失败: ${e.toString()}',
      );
    }
  }

  /// 保存数据到SharedPreferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 保存订阅数据
      final subscriptionsJson = state.subscriptions.map((s) => s.toMap()).toList();
      await prefs.setString('subscriptions', json.encode(subscriptionsJson));

      // 保存月度历史数据
      final monthlyHistoriesJson = state.monthlyHistories.map((h) => h.toMap()).toList();
      await prefs.setString('monthlyHistories', json.encode(monthlyHistoriesJson));

      // 保存主题设置
      await prefs.setInt('themeMode', state.themeMode.index);
      await prefs.setDouble('fontSize', state.fontSize);

      if (state.themeColor != null) {
        await prefs.setInt('themeColor', state.themeColor!.toARGB32());
      } else {
        await prefs.remove('themeColor');
      }
    } catch (e) {
      state = state.copyWith(error: '保存数据失败: ${e.toString()}');
    }
  }

  /// 添加订阅
  Future<void> addSubscription(Subscription subscription) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newSubscriptions = [...state.subscriptions, subscription];
      final updatedMonthlyHistories = _updateCurrentMonthHistory(newSubscriptions);
      final hasUnreadNotifications = _checkUnreadNotifications(newSubscriptions);

      state = state.copyWith(
        subscriptions: newSubscriptions,
        monthlyHistories: updatedMonthlyHistories,
        hasUnreadNotifications: hasUnreadNotifications,
        isLoading: false,
      );

      await _saveToPreferences();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '添加订阅失败: ${e.toString()}',
      );
    }
  }

  /// 删除订阅
  Future<void> removeSubscription(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newSubscriptions = state.subscriptions.where((s) => s.id != id).toList();
      final updatedMonthlyHistories = _updateCurrentMonthHistory(newSubscriptions);

      state = state.copyWith(
        subscriptions: newSubscriptions,
        monthlyHistories: updatedMonthlyHistories,
        isLoading: false,
      );

      await _saveToPreferences();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '删除订阅失败: ${e.toString()}',
      );
    }
  }

  /// 更新订阅
  Future<void> updateSubscription(Subscription updatedSubscription) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newSubscriptions = state.subscriptions
          .map((s) => s.id == updatedSubscription.id ? updatedSubscription : s)
          .toList();
      final updatedMonthlyHistories = _updateCurrentMonthHistory(newSubscriptions);

      state = state.copyWith(
        subscriptions: newSubscriptions,
        monthlyHistories: updatedMonthlyHistories,
        isLoading: false,
      );

      await _saveToPreferences();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '更新订阅失败: ${e.toString()}',
      );
    }
  }

  /// 更新主题模式
  Future<void> updateThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _saveToPreferences();
  }

  /// 更新字体大小
  Future<void> updateFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    await _saveToPreferences();
  }

  /// 更新主题颜色
  Future<void> updateThemeColor(Color? color) async {
    state = state.copyWith(themeColor: color);
    await _saveToPreferences();
  }

  /// 标记通知为已读
  void markNotificationsAsRead() {
    state = state.copyWith(hasUnreadNotifications: false);
  }

  /// 设置基准货币
  Future<void> setBaseCurrency(String currencyCode) async {
    state = state.copyWith(baseCurrency: currencyCode);
    await UserPreferences.setBaseCurrency(currencyCode);
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 更新当前月份历史记录
  List<MonthlyHistory> _updateCurrentMonthHistory(List<Subscription> subscriptions) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    // 计算当前月份的总费用
    double totalCost = 0;
    for (var subscription in subscriptions) {
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
        state.baseCurrency,
      );
      totalCost += convertedAmount;
    }

    // 创建当前月份的历史记录
    final currentMonthHistory = MonthlyHistory(
      year: currentYear,
      month: currentMonth,
      totalCost: totalCost,
    );

    // 更新历史记录列表
    final updatedHistories = [...state.monthlyHistories];
    final index = updatedHistories.indexWhere(
      (history) => history.year == currentYear && history.month == currentMonth,
    );

    if (index != -1) {
      updatedHistories[index] = currentMonthHistory;
    } else {
      updatedHistories.add(currentMonthHistory);
    }

    return updatedHistories;
  }

  /// 检查是否有未读通知
  bool _checkUnreadNotifications(List<Subscription> subscriptions) {
    final upcoming = subscriptions.where((subscription) {
      return subscription.daysUntilPayment >= 0 && subscription.daysUntilPayment <= 7;
    }).toList();

    return upcoming.isNotEmpty;
  }

  /// 根据ID获取订阅
  Subscription? getSubscriptionById(String id) {
    try {
      return state.subscriptions.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取月度总费用（转换为基准货币）
  double getMonthlyCost() {
    double total = 0;
    for (var subscription in state.subscriptions) {
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
        state.baseCurrency,
      );
      total += convertedAmount;
    }
    return total;
  }

  /// 获取年度总费用（转换为基准货币）
  double getYearlyCost() {
    double total = 0;
    for (var subscription in state.subscriptions) {
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
        state.baseCurrency,
      );
      total += convertedAmount;
    }
    return total;
  }

  /// 按类型分组统计费用
  Map<String, double> getTypeStats() {
    final typeStats = <String, double>{};

    for (var subscription in state.subscriptions) {
      double amount = subscription.price;
      if (subscription.billingCycle == '每年') {
        amount = subscription.price / 12; // 转换为月费用进行比较
      }

      // 转换为基准货币
      final convertedAmount = _exchangeRateService.convertCurrency(
        amount,
        subscription.currency,
        state.baseCurrency,
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
  MonthlyHistory? getPreviousMonthHistory() {
    final now = DateTime.now();
    final previousMonth = now.month == 1 ? 12 : now.month - 1;
    final previousYear = now.month == 1 ? now.year - 1 : now.year;

    try {
      return state.monthlyHistories.firstWhere(
        (history) => history.year == previousYear && history.month == previousMonth,
      );
    } on StateError {
      return null;
    }
  }

  /// 计算与上个月相比的变化百分比
  double getMonthlyCostChangePercentage() {
    final previousMonthHistory = getPreviousMonthHistory();
    if (previousMonthHistory == null) {
      return 0.0;
    }

    final currentCost = getMonthlyCost();
    final previousCost = previousMonthHistory.totalCost;

    if (previousCost == 0) {
      return 0.0;
    }

    return ((currentCost - previousCost) / previousCost) * 100;
  }

  /// 获取支持的货币列表
  List<String> getSupportedCurrencies() {
    return _exchangeRateService.getSupportedCurrencies();
  }
}