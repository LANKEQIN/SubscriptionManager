// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSubscriptionRequest _$CreateSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'CreateSubscriptionRequest',
      json,
      ($checkedConvert) {
        final val = CreateSubscriptionRequest(
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
        );
        return val;
      },
      fieldKeyMap: const {
        'billingCycle': 'billing_cycle',
        'nextRenewalDate': 'next_renewal_date',
        'autoRenewal': 'auto_renewal',
        'iconName': 'icon_name',
        'userId': 'user_id'
      },
    );

Map<String, dynamic> _$CreateSubscriptionRequestToJson(
        CreateSubscriptionRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'currency': instance.currency,
      'billing_cycle': instance.billingCycle,
      'next_renewal_date': instance.nextRenewalDate.toIso8601String(),
      'auto_renewal': instance.autoRenewal,
      if (instance.description case final value?) 'description': value,
      if (instance.iconName case final value?) 'icon_name': value,
      if (instance.userId case final value?) 'user_id': value,
    };

UpdateSubscriptionRequest _$UpdateSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'UpdateSubscriptionRequest',
      json,
      ($checkedConvert) {
        final val = UpdateSubscriptionRequest(
          name: $checkedConvert('name', (v) => v as String?),
          price: $checkedConvert('price', (v) => (v as num?)?.toDouble()),
          currency: $checkedConvert('currency', (v) => v as String?),
          billingCycle: $checkedConvert('billing_cycle', (v) => v as String?),
          nextRenewalDate: $checkedConvert('next_renewal_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          autoRenewal: $checkedConvert('auto_renewal', (v) => v as bool?),
          description: $checkedConvert('description', (v) => v as String?),
          iconName: $checkedConvert('icon_name', (v) => v as String?),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
          updatedAt: $checkedConvert('updated_at',
              (v) => v == null ? null : DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'billingCycle': 'billing_cycle',
        'nextRenewalDate': 'next_renewal_date',
        'autoRenewal': 'auto_renewal',
        'iconName': 'icon_name',
        'isActive': 'is_active',
        'updatedAt': 'updated_at'
      },
    );

Map<String, dynamic> _$UpdateSubscriptionRequestToJson(
        UpdateSubscriptionRequest instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.price case final value?) 'price': value,
      if (instance.currency case final value?) 'currency': value,
      if (instance.billingCycle case final value?) 'billing_cycle': value,
      if (instance.nextRenewalDate?.toIso8601String() case final value?)
        'next_renewal_date': value,
      if (instance.autoRenewal case final value?) 'auto_renewal': value,
      if (instance.description case final value?) 'description': value,
      if (instance.iconName case final value?) 'icon_name': value,
      if (instance.isActive case final value?) 'is_active': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

BatchSubscriptionRequest _$BatchSubscriptionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'BatchSubscriptionRequest',
      json,
      ($checkedConvert) {
        final val = BatchSubscriptionRequest(
          ids: $checkedConvert('ids',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          action: $checkedConvert('action', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$BatchSubscriptionRequestToJson(
        BatchSubscriptionRequest instance) =>
    <String, dynamic>{
      'ids': instance.ids,
      'action': instance.action,
    };

SubscriptionSearchRequest _$SubscriptionSearchRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionSearchRequest',
      json,
      ($checkedConvert) {
        final val = SubscriptionSearchRequest(
          query: $checkedConvert('query', (v) => v as String),
          userId: $checkedConvert('user_id', (v) => v as String),
          currency: $checkedConvert('currency', (v) => v as String?),
          billingCycle: $checkedConvert('billing_cycle', (v) => v as String?),
          minPrice:
              $checkedConvert('min_price', (v) => (v as num?)?.toDouble()),
          maxPrice:
              $checkedConvert('max_price', (v) => (v as num?)?.toDouble()),
          isActive: $checkedConvert('is_active', (v) => v as bool?),
          limit: $checkedConvert('limit', (v) => (v as num?)?.toInt()),
          offset: $checkedConvert('offset', (v) => (v as num?)?.toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'billingCycle': 'billing_cycle',
        'minPrice': 'min_price',
        'maxPrice': 'max_price',
        'isActive': 'is_active'
      },
    );

Map<String, dynamic> _$SubscriptionSearchRequestToJson(
        SubscriptionSearchRequest instance) =>
    <String, dynamic>{
      'query': instance.query,
      'user_id': instance.userId,
      if (instance.currency case final value?) 'currency': value,
      if (instance.billingCycle case final value?) 'billing_cycle': value,
      if (instance.minPrice case final value?) 'min_price': value,
      if (instance.maxPrice case final value?) 'max_price': value,
      if (instance.isActive case final value?) 'is_active': value,
      if (instance.limit case final value?) 'limit': value,
      if (instance.offset case final value?) 'offset': value,
    };

SubscriptionStatsRequest _$SubscriptionStatsRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionStatsRequest',
      json,
      ($checkedConvert) {
        final val = SubscriptionStatsRequest(
          userId: $checkedConvert('user_id', (v) => v as String),
          startDate: $checkedConvert('start_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          endDate: $checkedConvert('end_date',
              (v) => v == null ? null : DateTime.parse(v as String)),
          currency: $checkedConvert('currency', (v) => v as String?),
          groupBy: $checkedConvert('group_by', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'startDate': 'start_date',
        'endDate': 'end_date',
        'groupBy': 'group_by'
      },
    );

Map<String, dynamic> _$SubscriptionStatsRequestToJson(
        SubscriptionStatsRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      if (instance.startDate?.toIso8601String() case final value?)
        'start_date': value,
      if (instance.endDate?.toIso8601String() case final value?)
        'end_date': value,
      if (instance.currency case final value?) 'currency': value,
      if (instance.groupBy case final value?) 'group_by': value,
    };
