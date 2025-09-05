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
    CreateSubscriptionRequest instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'price': instance.price,
    'currency': instance.currency,
    'billing_cycle': instance.billingCycle,
    'next_renewal_date': instance.nextRenewalDate.toIso8601String(),
    'auto_renewal': instance.autoRenewal,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('icon_name', instance.iconName);
  writeNotNull('user_id', instance.userId);
  return val;
}

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
    UpdateSubscriptionRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('price', instance.price);
  writeNotNull('currency', instance.currency);
  writeNotNull('billing_cycle', instance.billingCycle);
  writeNotNull(
      'next_renewal_date', instance.nextRenewalDate?.toIso8601String());
  writeNotNull('auto_renewal', instance.autoRenewal);
  writeNotNull('description', instance.description);
  writeNotNull('icon_name', instance.iconName);
  writeNotNull('is_active', instance.isActive);
  writeNotNull('updated_at', instance.updatedAt?.toIso8601String());
  return val;
}

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
    SubscriptionSearchRequest instance) {
  final val = <String, dynamic>{
    'query': instance.query,
    'user_id': instance.userId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('currency', instance.currency);
  writeNotNull('billing_cycle', instance.billingCycle);
  writeNotNull('min_price', instance.minPrice);
  writeNotNull('max_price', instance.maxPrice);
  writeNotNull('is_active', instance.isActive);
  writeNotNull('limit', instance.limit);
  writeNotNull('offset', instance.offset);
  return val;
}

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
    SubscriptionStatsRequest instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('start_date', instance.startDate?.toIso8601String());
  writeNotNull('end_date', instance.endDate?.toIso8601String());
  writeNotNull('currency', instance.currency);
  writeNotNull('group_by', instance.groupBy);
  return val;
}
