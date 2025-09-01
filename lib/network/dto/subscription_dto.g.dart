// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionDto _$SubscriptionDtoFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionDto',
      json,
      ($checkedConvert) {
        final val = SubscriptionDto(
          id: $checkedConvert('id', (v) => v as String),
          name: $checkedConvert('name', (v) => v as String),
          price: $checkedConvert('price', (v) => (v as num).toDouble()),
          currency: $checkedConvert('currency', (v) => v as String),
          billingCycle: $checkedConvert('billing_cycle', (v) => v as String),
          nextRenewalDate: $checkedConvert(
              'next_renewal_date', (v) => DateTime.parse(v as String)),
          autoRenewal: $checkedConvert('auto_renewal', (v) => v as bool),
          description: $checkedConvert('description', (v) => v as String?),
          iconName: $checkedConvert('icon_name', (v) => v as String?),
          userId: $checkedConvert('user_id', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool? ?? true),
          createdAt:
              $checkedConvert('created_at', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updated_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'billingCycle': 'billing_cycle',
        'nextRenewalDate': 'next_renewal_date',
        'autoRenewal': 'auto_renewal',
        'iconName': 'icon_name',
        'userId': 'user_id',
        'isActive': 'is_active',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at'
      },
    );

Map<String, dynamic> _$SubscriptionDtoToJson(SubscriptionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'billing_cycle': instance.billingCycle,
      'next_renewal_date': instance.nextRenewalDate.toIso8601String(),
      'auto_renewal': instance.autoRenewal,
      if (instance.description case final value?) 'description': value,
      if (instance.iconName case final value?) 'icon_name': value,
      if (instance.userId case final value?) 'user_id': value,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
