import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_dto.freezed.dart';
part 'subscription_dto.g.dart';

@freezed
class SubscriptionDto with _$SubscriptionDto {
  const factory SubscriptionDto({
    required String id,
    required String name,
    required double price,
    required String currency,
    required String billingCycle,
    required DateTime nextRenewalDate,
    required String icon,
    required int color,
    String? notes,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SubscriptionDto;

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionDtoFromJson(json);
}