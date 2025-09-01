import 'package:json_annotation/json_annotation.dart';
import 'subscription_dto.dart';

part 'subscription_responses.g.dart';

/// API 响应基础类
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;
  final PaginationMeta? pagination;
  
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.pagination,
  });
  
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
  
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
  
  /// 成功响应
  factory ApiResponse.success({
    T? data,
    String? message,
    PaginationMeta? pagination,
  }) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      pagination: pagination,
    );
  }
  
  /// 错误响应
  factory ApiResponse.error({
    required String message,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse(
      success: false,
      message: message,
      errors: errors,
    );
  }
}

/// 分页元数据
@JsonSerializable()
class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'has_next')
  final bool hasNext;
  @JsonKey(name: 'has_previous')
  final bool hasPrevious;
  
  const PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
  
  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaginationMetaToJson(this);
}

/// 订阅列表响应
@JsonSerializable()
class SubscriptionListResponse {
  final List<SubscriptionDto> subscriptions;
  final PaginationMeta? pagination;
  
  const SubscriptionListResponse({
    required this.subscriptions,
    this.pagination,
  });
  
  factory SubscriptionListResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionListResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionListResponseToJson(this);
}

/// 订阅统计响应
@JsonSerializable()
class SubscriptionStatsResponse {
  @JsonKey(name: 'total_cost')
  final double totalCost;
  @JsonKey(name: 'monthly_cost')
  final double monthlyCost;
  @JsonKey(name: 'yearly_cost')
  final double yearlyCost;
  @JsonKey(name: 'active_subscriptions')
  final int activeSubscriptions;
  @JsonKey(name: 'total_subscriptions')
  final int totalSubscriptions;
  @JsonKey(name: 'currency_breakdown')
  final Map<String, double> currencyBreakdown;
  @JsonKey(name: 'category_breakdown')
  final Map<String, double>? categoryBreakdown;
  @JsonKey(name: 'monthly_trend')
  final List<MonthlyTrendData>? monthlyTrend;
  
  const SubscriptionStatsResponse({
    required this.totalCost,
    required this.monthlyCost,
    required this.yearlyCost,
    required this.activeSubscriptions,
    required this.totalSubscriptions,
    required this.currencyBreakdown,
    this.categoryBreakdown,
    this.monthlyTrend,
  });
  
  factory SubscriptionStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatsResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionStatsResponseToJson(this);
}

/// 月度趋势数据
@JsonSerializable()
class MonthlyTrendData {
  final String month;
  final double amount;
  final int count;
  
  const MonthlyTrendData({
    required this.month,
    required this.amount,
    required this.count,
  });
  
  factory MonthlyTrendData.fromJson(Map<String, dynamic> json) =>
      _$MonthlyTrendDataFromJson(json);
  
  Map<String, dynamic> toJson() => _$MonthlyTrendDataToJson(this);
}

/// 批量操作响应
@JsonSerializable()
class BatchOperationResponse {
  @JsonKey(name: 'affected_count')
  final int affectedCount;
  @JsonKey(name: 'failed_ids')
  final List<String> failedIds;
  final List<String>? errors;
  
  const BatchOperationResponse({
    required this.affectedCount,
    required this.failedIds,
    this.errors,
  });
  
  factory BatchOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchOperationResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$BatchOperationResponseToJson(this);
}