import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import '../utils/currency_constants.dart';
import '../utils/icon_utils.dart';
import '../utils/subscription_constants.dart';

part 'subscription.freezed.dart';

/// 价格格式化常量
/// 提供订阅价格显示的后缀格式
class PriceFormatConstants {
  /// 每月订阅的价格后缀
  static const String monthlySuffix = '/月';
  
  /// 每年订阅的价格后缀
  static const String yearlySuffix = '/年';
}

@freezed
class Subscription with _$Subscription {
  /// 构造函数
  /// 创建一个新的订阅实例
  /// 如果未提供id，则自动生成UUID
  /// currency默认为'CNY'
  const factory Subscription({
    /// 订阅的唯一标识符
    @Default('') String id,
    
    /// 订阅名称
    required String name,
    
    /// 订阅图标（可选）
    String? icon,
    
    /// 订阅类型
    required String type,
    
    /// 订阅价格
    required double price,
    
    /// 货币类型，默认为CNY
    @Default('CNY') String currency,
    
    /// 计费周期：每月/每年/一次性
    required String billingCycle,
    
    /// 下次付款日期
    required DateTime nextPaymentDate,
    
    /// 是否自动续费
    @Default(false) bool autoRenewal,
    
    /// 备注信息（可选）
    String? notes,
  }) = _Subscription;
  
  const Subscription._();
  
  /// 创建新的订阅实例（自动生成UUID）
  factory Subscription.create({
    required String name,
    String? icon,
    required String type,
    required double price,
    String currency = 'CNY',
    required String billingCycle,
    required DateTime nextPaymentDate,
    bool autoRenewal = false,
    String? notes,
  }) {
    return Subscription(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      type: type,
      price: price,
      currency: currency,
      billingCycle: billingCycle,
      nextPaymentDate: nextPaymentDate,
      autoRenewal: autoRenewal,
      notes: notes,
    );
  }
  
  /// 从旧的Map格式创建Subscription对象
  /// 用于向后兼容，从SharedPreferences恢复数据
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'] ?? const Uuid().v4(),
      name: map['name'] ?? '',
      icon: map['icon'],
      type: map['type'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'CNY',
      billingCycle: map['billingCycle'] ?? '',
      nextPaymentDate: map['nextPaymentDate'] is int 
        ? DateTime.fromMillisecondsSinceEpoch(map['nextPaymentDate'])
        : DateTime.now(),
      autoRenewal: map['autoRenewal'] ?? false,
      notes: map['notes'],
    );
  }
  
  /// 将Subscription对象转换为Map，便于存储到SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
      'price': price,
      'currency': currency,
      'billingCycle': billingCycle,
      'nextPaymentDate': nextPaymentDate.millisecondsSinceEpoch,
      'autoRenewal': autoRenewal,
      'notes': notes,
    };
  }

  /// 计算下次付款前剩余天数
  /// 返回距离下次付款的天数，负数表示已过期
  int get daysUntilPayment {
    final now = DateTime.now();
    final difference = nextPaymentDate.difference(now);
    return difference.inDays;
  }

  /// 格式化价格显示
  /// 根据计费周期和货币类型格式化显示价格
  String get formattedPrice {
    // 使用外部定义的货币符号映射
    final symbol = currencySymbols[currency] ?? currency;
    
    switch (billingCycle) {
      case SubscriptionConstants.billingCycleMonthly:
        return '$symbol${price.toStringAsFixed(2)}${PriceFormatConstants.monthlySuffix}';
      case SubscriptionConstants.billingCycleYearly:
        return '$symbol${price.toStringAsFixed(2)}${PriceFormatConstants.yearlySuffix}';
      default:
        return '$symbol${price.toStringAsFixed(2)}';
    }
  }

  /// 获取续费状态描述
  /// 根据距离下次付款天数返回相应的状态描述
  String get renewalStatus {
    if (daysUntilPayment < 0) {
      return '已过期';
    } else if (daysUntilPayment == 0) {
      return '今天到期';
    } else if (daysUntilPayment == 1) {
      return '明天到期';
    } else if (daysUntilPayment <= 7) {
      return '$daysUntilPayment天后到期';
    } else {
      return '自动续费';
    }
  }

  /// 获取订阅图标
  /// 将字符串形式的图标转换为IconData
  IconData get iconData {
    return IconUtils.getIconData(icon);
  }
}