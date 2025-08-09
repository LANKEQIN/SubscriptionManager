class MonthlyHistory {
  final int year;
  final int month;
  final double totalCost;

  MonthlyHistory({
    required this.year,
    required this.month,
    required this.totalCost,
  });

  /// 将MonthlyHistory对象转换为Map，便于存储
  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'month': month,
      'totalCost': totalCost,
    };
  }

  /// 从Map创建MonthlyHistory对象
  factory MonthlyHistory.fromMap(Map<String, dynamic> map) {
    return MonthlyHistory(
      year: map['year'],
      month: map['month'],
      totalCost: map['totalCost'],
    );
  }

  @override
  String toString() {
    return 'MonthlyHistory{year: $year, month: $month, totalCost: $totalCost}';
  }
}