import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'subscription.dart';
import 'monthly_history.dart';

class SubscriptionProvider with ChangeNotifier {
  List<Subscription> _subscriptions = [];
  List<MonthlyHistory> _monthlyHistories = [];
  
  // 主题模式，默认跟随系统
  ThemeMode _themeMode = ThemeMode.system;
  
  // 字体大小，默认16
  double _fontSize = 16.0;
  
  // 主题颜色，默认为null表示使用系统动态颜色或默认蓝色
  Color? _themeColor;
  
  // 提醒查看状态，默认为false（未查看）
  bool _hasUnreadNotifications = false;

  List<Subscription> get subscriptions => _subscriptions;
  List<MonthlyHistory> get monthlyHistories => _monthlyHistories;
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  Color? get themeColor => _themeColor;
  bool get hasUnreadNotifications => _hasUnreadNotifications;

  // 初始化数据
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 加载订阅数据
    final subscriptionsString = prefs.getString('subscriptions');
    if (subscriptionsString != null) {
      final List<dynamic> subscriptionsJson = json.decode(subscriptionsString);
      _subscriptions = subscriptionsJson
          .map((json) => Subscription.fromMap(json))
          .toList();
    } else {
      _subscriptions = [];
    }
    
    // 加载月度历史数据
    final monthlyHistoriesString = prefs.getString('monthlyHistories');
    if (monthlyHistoriesString != null) {
      final List<dynamic> monthlyHistoriesJson = json.decode(monthlyHistoriesString);
      _monthlyHistories = monthlyHistoriesJson
          .map((json) => MonthlyHistory.fromMap(json))
          .toList();
    } else {
      _monthlyHistories = [];
    }
    
    // 加载主题模式
    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];
    
    // 加载字体大小
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    
    // 加载主题颜色
    final themeColorValue = prefs.getInt('themeColor');
    _themeColor = themeColorValue != null ? Color(themeColorValue) : null;
    
    notifyListeners();
  }

  // 保存数据到SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 保存订阅数据
    final subscriptionsJson = _subscriptions.map((s) => s.toMap()).toList();
    prefs.setString('subscriptions', json.encode(subscriptionsJson));
    
    // 保存月度历史数据
    final monthlyHistoriesJson = _monthlyHistories.map((h) => h.toMap()).toList();
    prefs.setString('monthlyHistories', json.encode(monthlyHistoriesJson));
    
    // 保存主题模式
    prefs.setInt('themeMode', _themeMode.index);
    
    // 保存字体大小
    prefs.setDouble('fontSize', _fontSize);
    
    // 保存主题颜色
    if (_themeColor != null) {
      prefs.setInt('themeColor', _themeColor!.value);
    } else {
      prefs.remove('themeColor');
    }
  }

  // 添加订阅
  void addSubscription(Subscription subscription) {
    _subscriptions.add(subscription);
    _updateCurrentMonthHistory();
    
    // 检查是否需要设置未读通知状态
    final now = DateTime.now();
    final difference = subscription.nextPaymentDate.difference(now);
    if (difference.inDays <= 7 && difference.inDays >= 0 && !_hasUnreadNotifications) {
      _hasUnreadNotifications = true;
    }
    
    _saveToPrefs(); // 保存数据
    notifyListeners();
  }

  // 删除订阅
  void removeSubscription(String id) {
    _subscriptions.removeWhere((subscription) => subscription.id == id);
    _updateCurrentMonthHistory();
    _saveToPrefs(); // 保存数据
    notifyListeners();
  }

  // 更新订阅
  void updateSubscription(Subscription updatedSubscription) {
    final index = _subscriptions.indexWhere((subscription) => subscription.id == updatedSubscription.id);
    if (index != -1) {
      _subscriptions[index] = updatedSubscription;
      _updateCurrentMonthHistory();
      _saveToPrefs(); // 保存数据
      notifyListeners();
    }
  }

  // 根据ID获取订阅
  Subscription? getSubscriptionById(String id) {
    try {
      return _subscriptions.firstWhere((subscription) => subscription.id == id);
    } on StateError {
      return null;
    }
  }

  // 获取订阅总数
  int get subscriptionCount => _subscriptions.length;

  // 计算指定计费周期的订阅总费用
  double _calculateCostByBillingCycle(String billingCycle, {bool monthlyRate = false}) {
    double total = 0;
    final subscriptions = _subscriptions.where((s) => s.billingCycle == billingCycle);
    
    for (var subscription in subscriptions) {
      if (monthlyRate && billingCycle == '每年') {
        total += subscription.price / 12;
      } else if (!monthlyRate && billingCycle == '每月') {
        total += subscription.price * 12;
      } else {
        total += subscription.price;
      }
    }
    
    return total;
  }

  // 获取月度总费用
  double get monthlyCost {
    return _calculateCostByBillingCycle('每月') + 
           _calculateCostByBillingCycle('每年', monthlyRate: true);
  }

  // 获取年度总费用
  double get yearlyCost {
    return _calculateCostByBillingCycle('每月', monthlyRate: false) + 
           _calculateCostByBillingCycle('每年') + 
           _calculateCostByBillingCycle('一次性');
  }

  // 获取即将到期的订阅（7天内）
  List<Subscription> get upcomingSubscriptions {
    final now = DateTime.now();
    final upcoming = _subscriptions.where((subscription) {
      final difference = subscription.nextPaymentDate.difference(now);
      return difference.inDays <= 7 && difference.inDays >= 0;
    }).toList();
    
    upcoming.sort((a, b) => a.nextPaymentDate.compareTo(b.nextPaymentDate));
    return upcoming;
  }

  // 更新当前月份历史记录
  void _updateCurrentMonthHistory() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    // 查找当前月份是否已有记录
    final index = _monthlyHistories.indexWhere(
      (history) => history.year == currentYear && history.month == currentMonth
    );
    
    // 创建新的历史记录
    final currentMonthHistory = MonthlyHistory(
      year: currentYear,
      month: currentMonth,
      totalCost: monthlyCost,
    );
    
    // 如果已有记录则更新，否则添加新记录
    if (index != -1) {
      _monthlyHistories[index] = currentMonthHistory;
    } else {
      _monthlyHistories.add(currentMonthHistory);
    }
  }

  // 获取上个月的历史记录
  MonthlyHistory? getPreviousMonthHistory() {
    final now = DateTime.now();
    final previousMonth = now.month == 1 ? 12 : now.month - 1;
    final previousYear = now.month == 1 ? now.year - 1 : now.year;
    
    try {
      return _monthlyHistories.firstWhere(
        (history) => history.year == previousYear && history.month == previousMonth
      );
    } on StateError {
      return null;
    }
  }

  // 计算与上个月相比的变化百分比
  double getMonthlyCostChangePercentage() {
    final previousMonthHistory = getPreviousMonthHistory();
    if (previousMonthHistory == null) {
      return 0.0; // 没有上个月的数据
    }
    
    final currentCost = monthlyCost;
    final previousCost = previousMonthHistory.totalCost;
    
    if (previousCost == 0) {
      return 0.0; // 避免除以零
    }
    
    return ((currentCost - previousCost) / previousCost) * 100;
  }
  
  // 更新主题模式
  void updateThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveToPrefs(); // 保存数据
    notifyListeners();
  }
  
  // 更新字体大小
  void updateFontSize(double size) {
    _fontSize = size;
    _saveToPrefs(); // 保存数据
    notifyListeners();
  }
  
  // 更新主题颜色
  void updateThemeColor(Color? color) {
    _themeColor = color;
    _saveToPrefs(); // 保存数据
    notifyListeners();
  }
  
  // 标记提醒为已读
  void markNotificationsAsRead() {
    _hasUnreadNotifications = false;
    notifyListeners();
  }
  
  // 重置未读通知状态（用于在添加新订阅时检查是否需要显示通知）
  void resetUnreadNotificationStatus() {
    final upcoming = _subscriptions.where((subscription) {
      final now = DateTime.now();
      final difference = subscription.nextPaymentDate.difference(now);
      return difference.inDays <= 7 && difference.inDays >= 0;
    }).toList();
    
    if (upcoming.isNotEmpty && !_hasUnreadNotifications) {
      _hasUnreadNotifications = true;
      notifyListeners();
    }
  }

}