import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'subscription.dart';
import 'monthly_history.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    /// 订阅列表
    @Default([]) List<Subscription> subscriptions,
    
    /// 月度历史记录
    @Default([]) List<MonthlyHistory> monthlyHistories,
    
    /// 主题模式
    @Default(ThemeMode.system) ThemeMode themeMode,
    
    /// 字体大小
    @Default(14.0) double fontSize,
    
    /// 主题颜色
    Color? themeColor,
    
    /// 是否有未读通知
    @Default(false) bool hasUnreadNotifications,
    
    /// 基础货币
    @Default('CNY') String baseCurrency,
    
    /// 是否正在加载
    @Default(false) bool isLoading,
    
    /// 错误信息
    String? error,
  }) = _SubscriptionState;

  const SubscriptionState._();

  /// 计算总月度成本（以基础货币计算）
  double get totalMonthlyCost {
    double total = 0.0;
    for (final subscription in subscriptions) {
      if (subscription.billingCycle == 'monthly') {
        total += subscription.price;
      } else if (subscription.billingCycle == 'yearly') {
        total += subscription.price / 12;
      }
    }
    return total;
  }

  /// 计算总年度成本（以基础货币计算）
  double get totalYearlyCost {
    double total = 0.0;
    for (final subscription in subscriptions) {
      if (subscription.billingCycle == 'monthly') {
        total += subscription.price * 12;
      } else if (subscription.billingCycle == 'yearly') {
        total += subscription.price;
      }
    }
    return total;
  }

  /// 获取即将到期的订阅（7天内）
  List<Subscription> get upcomingSubscriptions {
    return subscriptions.where((subscription) {
      return subscription.daysUntilPayment >= 0 && subscription.daysUntilPayment <= 7;
    }).toList()
      ..sort((a, b) => a.daysUntilPayment.compareTo(b.daysUntilPayment));
  }

  /// 获取已过期的订阅
  List<Subscription> get expiredSubscriptions {
    return subscriptions.where((subscription) {
      return subscription.daysUntilPayment < 0;
    }).toList()
      ..sort((a, b) => b.daysUntilPayment.compareTo(a.daysUntilPayment));
  }

  /// 按类型分组的订阅
  Map<String, List<Subscription>> get subscriptionsByType {
    final Map<String, List<Subscription>> grouped = {};
    for (final subscription in subscriptions) {
      if (!grouped.containsKey(subscription.type)) {
        grouped[subscription.type] = [];
      }
      grouped[subscription.type]!.add(subscription);
    }
    return grouped;
  }

  /// 检查是否有错误
  bool get hasError => error != null && error!.isNotEmpty;

  /// 检查是否有订阅
  bool get hasSubscriptions => subscriptions.isNotEmpty;

  /// 检查是否有月度历史
  bool get hasMonthlyHistories => monthlyHistories.isNotEmpty;
}