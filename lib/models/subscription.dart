import 'package:uuid/uuid.dart';
import '../utils/currency_constants.dart';
import 'package:flutter/material.dart';
import '../utils/icon_utils.dart';
import '../utils/subscription_constants.dart';

/// 价格格式化常量
/// 提供订阅价格显示的后缀格式
class PriceFormatConstants {
  /// 每月订阅的价格后缀
  static const String monthlySuffix = '/月';
  
  /// 每年订阅的价格后缀
  static const String yearlySuffix = '/年';
}

/// 订阅模型类
/// 用于表示一个订阅服务的完整信息
class Subscription {
  /// 订阅的唯一标识符
  final String id;
  
  /// 订阅名称
  final String name;
  
  /// 订阅图标（可选）
  final String? icon;
  
  /// 订阅类型
  final String type;
  
  /// 订阅价格
  final double price;
  
  /// 货币类型，默认为CNY
  final String currency;
  
  /// 计费周期：每月/每年/一次性
  final String billingCycle;
  
  /// 下次付款日期
  final DateTime nextPaymentDate;
  
  /// 是否自动续费
  final bool autoRenewal;
  
  /// 备注信息（可选）
  final String? notes;

  /// 构造函数
  /// 创建一个新的订阅实例
  /// 如果未提供id，则自动生成UUID
  /// currency默认为'CNY'
  Subscription({
    String? id,
    required this.name,
    this.icon,
    required this.type,
    required this.price,
    this.currency = 'CNY',
    required this.billingCycle,
    required this.nextPaymentDate,
    required this.autoRenewal,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  /// 创建一个Subscription实例的副本，用于更新操作
  /// 允许只更新指定的字段，其他字段保持不变
  Subscription copyWith({
    String? id,
    String? name,
    String? icon,
    String? type,
    double? price,
    String? currency,
    String? billingCycle,
    DateTime? nextPaymentDate,
    bool? autoRenewal,
    String? notes,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      autoRenewal: autoRenewal ?? this.autoRenewal,
      notes: notes ?? this.notes,
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

  /// 从Map创建Subscription对象
  /// 用于从SharedPreferences恢复数据
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      type: map['type'],
      price: map['price'],
      currency: map['currency'] ?? 'CNY', // 为向后兼容设置默认值
      billingCycle: map['billingCycle'],
      nextPaymentDate: DateTime.fromMillisecondsSinceEpoch(map['nextPaymentDate']),
      autoRenewal: map['autoRenewal'],
      notes: map['notes'],
    );
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          type == other.type &&
          price == other.price &&
          currency == other.currency &&
          billingCycle == other.billingCycle &&
          nextPaymentDate == other.nextPaymentDate &&
          autoRenewal == other.autoRenewal &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      icon.hashCode ^
      type.hashCode ^
      price.hashCode ^
      currency.hashCode ^
      billingCycle.hashCode ^
      nextPaymentDate.hashCode ^
      autoRenewal.hashCode ^
      notes.hashCode;
}