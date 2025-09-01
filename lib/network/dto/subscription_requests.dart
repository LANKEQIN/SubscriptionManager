import 'package:json_annotation/json_annotation.dart';

part 'subscription_requests.g.dart';

/// 创建订阅请求模型
@JsonSerializable()
class CreateSubscriptionRequest {
  final String name;
  final double price;
  final String currency;
  @JsonKey(name: 'billing_cycle')
  final String billingCycle;
  @JsonKey(name: 'next_renewal_date')
  final DateTime nextRenewalDate;
  @JsonKey(name: 'auto_renewal')
  final bool autoRenewal;
  final String? description;
  @JsonKey(name: 'icon_name')
  final String? iconName;
  @JsonKey(name: 'user_id')
  final String? userId;
  
  const CreateSubscriptionRequest({
    required this.name,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.nextRenewalDate,
    required this.autoRenewal,
    this.description,
    this.iconName,
    this.userId,
  });
  
  factory CreateSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSubscriptionRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$CreateSubscriptionRequestToJson(this);
}

/// 更新订阅请求模型
@JsonSerializable()
class UpdateSubscriptionRequest {
  final String? name;
  final double? price;
  final String? currency;
  @JsonKey(name: 'billing_cycle')
  final String? billingCycle;
  @JsonKey(name: 'next_renewal_date')
  final DateTime? nextRenewalDate;
  @JsonKey(name: 'auto_renewal')
  final bool? autoRenewal;
  final String? description;
  @JsonKey(name: 'icon_name')
  final String? iconName;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  
  const UpdateSubscriptionRequest({
    this.name,
    this.price,
    this.currency,
    this.billingCycle,
    this.nextRenewalDate,
    this.autoRenewal,
    this.description,
    this.iconName,
    this.isActive,
    this.updatedAt,
  });
  
  factory UpdateSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSubscriptionRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$UpdateSubscriptionRequestToJson(this);
}

/// 批量操作请求模型
@JsonSerializable()
class BatchSubscriptionRequest {
  final List<String> ids;
  final String action; // 'delete', 'activate', 'deactivate'
  
  const BatchSubscriptionRequest({
    required this.ids,
    required this.action,
  });
  
  factory BatchSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchSubscriptionRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$BatchSubscriptionRequestToJson(this);
}

/// 订阅搜索请求模型
@JsonSerializable()
class SubscriptionSearchRequest {
  final String query;
  @JsonKey(name: 'user_id')
  final String userId;
  final String? currency;
  @JsonKey(name: 'billing_cycle')
  final String? billingCycle;
  @JsonKey(name: 'min_price')
  final double? minPrice;
  @JsonKey(name: 'max_price')
  final double? maxPrice;
  @JsonKey(name: 'is_active')
  final bool? isActive;
  final int? limit;
  final int? offset;
  
  const SubscriptionSearchRequest({
    required this.query,
    required this.userId,
    this.currency,
    this.billingCycle,
    this.minPrice,
    this.maxPrice,
    this.isActive,
    this.limit,
    this.offset,
  });
  
  factory SubscriptionSearchRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionSearchRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionSearchRequestToJson(this);
}

/// 订阅统计请求模型
@JsonSerializable()
class SubscriptionStatsRequest {
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final String? currency;
  @JsonKey(name: 'group_by')
  final String? groupBy; // 'month', 'category', 'currency'
  
  const SubscriptionStatsRequest({
    required this.userId,
    this.startDate,
    this.endDate,
    this.currency,
    this.groupBy,
  });
  
  factory SubscriptionStatsRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStatsRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionStatsRequestToJson(this);
}