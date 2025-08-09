import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  List<Subscription> get subscriptions => _subscriptions;
  List<MonthlyHistory> get monthlyHistories => _monthlyHistories;
  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  Color? get themeColor => _themeColor;

  // 添加订阅
  void addSubscription(Subscription subscription) {
    _subscriptions.add(subscription);
    _updateCurrentMonthHistory();
    notifyListeners();
  }

  // 删除订阅
  void removeSubscription(String id) {
    _subscriptions.removeWhere((subscription) => subscription.id == id);
    _updateCurrentMonthHistory();
    notifyListeners();
  }

  // 更新订阅
  void updateSubscription(Subscription updatedSubscription) {
    final index = _subscriptions.indexWhere((subscription) => subscription.id == updatedSubscription.id);
    if (index != -1) {
      _subscriptions[index] = updatedSubscription;
      _updateCurrentMonthHistory();
      notifyListeners();
    }
  }

  // 根据ID获取订阅
  Subscription? getSubscriptionById(String id) {
    try {
      return _subscriptions.firstWhere((subscription) => subscription.id == id);
    } catch (e) {
      return null;
    }
  }

  // 获取订阅总数
  int get subscriptionCount => _subscriptions.length;

  // 获取月度总费用
  double get monthlyCost {
    double total = 0;
    for (var subscription in _subscriptions) {
      if (subscription.billingCycle == '每月') {
        total += subscription.price;
      } else if (subscription.billingCycle == '每年') {
        total += subscription.price / 12;
      }
    }
    return total;
  }

  // 获取年度总费用
  double get yearlyCost {
    double total = 0;
    for (var subscription in _subscriptions) {
      if (subscription.billingCycle == '每月') {
        total += subscription.price * 12;
      } else if (subscription.billingCycle == '每年') {
        total += subscription.price;
      } else if (subscription.billingCycle == '一次性') {
        total += subscription.price;
      }
    }
    return total;
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
    } catch (e) {
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
    notifyListeners();
  }
  
  // 更新字体大小
  void updateFontSize(double size) {
    _fontSize = size;
    notifyListeners();
  }
  
  // 更新主题颜色
  void updateThemeColor(Color? color) {
    _themeColor = color;
    notifyListeners();
  }
}