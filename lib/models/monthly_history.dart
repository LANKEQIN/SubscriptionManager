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
    return MonthlyHistory(
      id: const Uuid().v4(),
      year: year,
      month: month,
      totalAmount: totalAmount,
      currency: currency,
      subscriptionCount: subscriptionCount,
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
}