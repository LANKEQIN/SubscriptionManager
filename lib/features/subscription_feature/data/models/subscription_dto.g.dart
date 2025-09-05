// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionDtoImpl _$$SubscriptionDtoImplFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$SubscriptionDtoImpl',
      json,
      ($checkedConvert) {
        final val = _$SubscriptionDtoImpl(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          price: $checkedConvert('price', (v) => (v as num).toDouble()),
          currency: $checkedConvert('currency', (v) => v as String),
          billingCycle: $checkedConvert('billingCycle', (v) => v as String),
          nextRenewalDate: $checkedConvert(
              'nextRenewalDate', (v) => DateTime.parse(v as String)),
          icon: $checkedConvert('icon', (v) => v as String),
          color: $checkedConvert('color', (v) => (v as num).toInt()),
          notes: $checkedConvert('notes', (v) => v as String?),
          isActive: $checkedConvert('isActive', (v) => v as bool),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
    );

Map<String, dynamic> _$$SubscriptionDtoImplToJson(
    _$SubscriptionDtoImpl instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'price': instance.price,
    'currency': instance.currency,
    'billingCycle': instance.billingCycle,
    'nextRenewalDate': instance.nextRenewalDate.toIso8601String(),
    'icon': instance.icon,
    'color': instance.color,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notes', instance.notes);
  val['isActive'] = instance.isActive;
  val['createdAt'] = instance.createdAt.toIso8601String();
  val['updatedAt'] = instance.updatedAt.toIso8601String();
  return val;
}
