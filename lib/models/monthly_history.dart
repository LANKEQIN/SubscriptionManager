import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'monthly_history.freezed.dart';

@freezed
class MonthlyHistory with _$MonthlyHistory {
  const factory MonthlyHistory({
    /// 历史记录唯一标识符
    @Default('') String id,
    
    /// 年份
    required int year,
    
    /// 月份 (1-12)
    required int month,
    
    /// 当月总金额
    required double totalAmount,
    
    /// 货币类型
    @Default('CNY') String currency,
    
    /// 当月订阅数量
    required int subscriptionCount,
    
    /// 创建时间
    DateTime? createdAt,
    
    /// 最后更新时间
    DateTime? updatedAt,
    
    /// 最后同步时间
    DateTime? lastSyncedAt,
  }) = _MonthlyHistory;
  
  const MonthlyHistory._();
  
  /// 创建新的月度历史记录（自动生成UUID）
  factory MonthlyHistory.create({
    required int year,
    required int month,
    required double totalAmount,
    String currency = 'CNY',
    required int subscriptionCount,
  }) {
    final now = DateTime.now();
    return MonthlyHistory(
      id: const Uuid().v4(),
      year: year,
      month: month,
      totalAmount: totalAmount,
      currency: currency,
      subscriptionCount: subscriptionCount,
      createdAt: now,
      updatedAt: now,
    );
  }
  
  /// 从旧的Map格式创建MonthlyHistory对象（向后兼容）
  factory MonthlyHistory.fromMap(Map<String, dynamic> map) {
    return MonthlyHistory(
      id: map['id'] ?? const Uuid().v4(),
      year: map['year'] ?? 0,
      month: map['month'] ?? 0,
      totalAmount: (map['totalAmount'] ?? map['totalCost'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? 'CNY',
      subscriptionCount: map['subscriptionCount'] ?? 0,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) : null,
    );
  }
  
  /// 从 Supabase JSON 创建 MonthlyHistory 对象
  factory MonthlyHistory.fromSupabaseJson(Map<String, dynamic> json) {
    return MonthlyHistory(
      id: json['id'] ?? const Uuid().v4(),
      year: json['year'] ?? 0,
      month: json['month'] ?? 0,
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'CNY',
      subscriptionCount: json['subscription_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      lastSyncedAt: DateTime.now(),
    );
  }
}

/// MonthlyHistory 的扩展方法，用于向后兼容
extension MonthlyHistoryExtension on MonthlyHistory {
  /// 将MonthlyHistory对象转换为Map，便于存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'totalAmount': totalAmount,
      'currency': currency,
      'subscriptionCount': subscriptionCount,
      // 为了向后兼容，保留旧字段
      'totalCost': totalAmount,
    };
  }
  
  /// 转换为 Supabase JSON 格式
  Map<String, dynamic> toSupabaseJson() {
    return {
      'id': id,
      'year': year,
      'month': month,
      'total_amount': totalAmount,
      'currency': currency,
      'subscription_count': subscriptionCount,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}