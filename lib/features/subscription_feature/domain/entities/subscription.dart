import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
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
  }) = _Subscription;
}