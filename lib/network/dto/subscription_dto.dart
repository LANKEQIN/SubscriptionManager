import 'package:json_annotation/json_annotation.dart';
import '../../models/subscription.dart';

part 'subscription_dto.g.dart';

/// 订阅数据传输对象
/// 用于 API 通信的数据模型
@JsonSerializable()
class SubscriptionDto {
  final String id;
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
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  
  const SubscriptionDto({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.nextRenewalDate,
    required this.autoRenewal,
    this.description,
    this.iconName,
    this.userId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory SubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDtoFromJson(json);
  
  Map<String, dynamic> toJson() => _$SubscriptionDtoToJson(this);
  
  /// 从领域模型转换为 DTO
  factory SubscriptionDto.fromDomain(Subscription subscription) {
    return SubscriptionDto(
      id: subscription.id,
      name: subscription.name,
      price: subscription.price,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextRenewalDate: subscription.nextPaymentDate,
      autoRenewal: subscription.autoRenewal,
      description: subscription.notes,
      iconName: subscription.icon,
      isActive: true, // 默认为活跃状态
      createdAt: subscription.createdAt ?? DateTime.now(),
      updatedAt: subscription.updatedAt ?? DateTime.now(),
    );
  }
  
  /// 转换为领域模型
  Subscription toDomain() {
    return Subscription(
      id: id,
      name: name,
      icon: iconName,
      type: '', // 暂时使用空字符串，后续根据需要映射
      price: price,
      currency: currency,
      billingCycle: billingCycle,
      nextPaymentDate: nextRenewalDate,
      autoRenewal: autoRenewal,
      notes: description,
      serverId: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  /// 创建副本，支持部分字段更新
  SubscriptionDto copyWith({
    String? id,
    String? name,
    double? price,
    String? currency,
    String? billingCycle,
    DateTime? nextRenewalDate,
    bool? autoRenewal,
    String? description,
    String? iconName,
    String? userId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionDto(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      billingCycle: billingCycle ?? this.billingCycle,
      nextRenewalDate: nextRenewalDate ?? this.nextRenewalDate,
      autoRenewal: autoRenewal ?? this.autoRenewal,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}