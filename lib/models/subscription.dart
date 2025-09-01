import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import '../utils/currency_constants.dart';
import '../utils/icon_utils.dart';
import '../utils/subscription_constants.dart';
import 'sync_types.dart';

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
    
    // 同步相关字段
    /// 服务器端ID（用于同步）
    String? serverId,
    
    /// 创建时间
    DateTime? createdAt,
    
    /// 最后更新时间
    DateTime? updatedAt,
    
    /// 最后同步时间
    DateTime? lastSyncedAt,
    
    /// 是否需要同步
    @Default(false) bool needsSync,
    
    /// 同步状态
    @Default(SyncStatus.synced) SyncStatus syncStatus,
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
    final now = DateTime.now();
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
      createdAt: now,
      updatedAt: now,
      needsSync: true,
      syncStatus: SyncStatus.pending,
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
  
  /// 标记为需要同步
  Subscription markForSync() {
    return copyWith(
      needsSync: true,
      syncStatus: SyncStatus.pending,
      updatedAt: DateTime.now(),
    );
  }
  
  /// 标记为已同步
  Subscription markAsSynced({
    String? serverId,
  }) {
    return copyWith(
      serverId: serverId ?? this.serverId,
      needsSync: false,
      syncStatus: SyncStatus.synced,
      lastSyncedAt: DateTime.now(),
    );
  }
  
  /// 标记同步失败
  Subscription markSyncError() {
    return copyWith(
      syncStatus: SyncStatus.error,
    );
  }
  
  /// 标记为冲突状态
  Subscription markAsConflict() {
    return copyWith(
      syncStatus: SyncStatus.conflict,
    );
  }
  
  /// 转换为Supabase JSON格式
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': serverId,
      'name': name,
      'price': price,
      'currency': currency,
      'billing_cycle': billingCycle,
      'next_payment_date': nextPaymentDate.toIso8601String().split('T')[0],
      'description': notes,
      'icon_name': icon,
      'color': null, // TODO: 如果需要颜色支持
      'is_active': true,
      'local_id': id,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
  
  /// 从Supabase JSON创建Subscription
  factory Subscription.fromSupabaseJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['local_id'] ?? const Uuid().v4(),
      serverId: json['id'],
      name: json['name'] ?? '',
      icon: json['icon_name'],
      type: json['billing_cycle'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'CNY',
      billingCycle: json['billing_cycle'] ?? '',
      nextPaymentDate: DateTime.parse(json['next_payment_date']),
      autoRenewal: true, // Supabase中默认为活跃状态
      notes: json['description'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      lastSyncedAt: DateTime.now(),
      needsSync: false,
      syncStatus: SyncStatus.synced,
    );
  }
}