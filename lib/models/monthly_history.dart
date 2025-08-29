import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_history.freezed.dart';

@freezed
class MonthlyHistory with _$MonthlyHistory {
  const factory MonthlyHistory({
    required int year,
    required int month,
    required double totalCost,
  }) = _MonthlyHistory;
  
  /// 从旧的Map格式创建MonthlyHistory对象（向后兼容）
  factory MonthlyHistory.fromMap(Map<String, dynamic> map) {
    return MonthlyHistory(
      year: map['year'] ?? 0,
      month: map['month'] ?? 0,
      totalCost: (map['totalCost'] ?? 0.0).toDouble(),
    );
  }
}

/// MonthlyHistory 的扩展方法，用于向后兼容
extension MonthlyHistoryExtension on MonthlyHistory {
  /// 将MonthlyHistory对象转换为Map，便于存储
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'totalCost': totalCost,
    };
  }
}