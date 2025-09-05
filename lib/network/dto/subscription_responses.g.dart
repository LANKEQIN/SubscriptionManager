// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    $checkedCreate(
      'ApiResponse',
      json,
      ($checkedConvert) {
        final val = ApiResponse<T>(
          success: $checkedConvert('success', (v) => v as bool),
          message: $checkedConvert('message', (v) => v as String?),
          data: $checkedConvert(
              'data', (v) => _$nullableGenericFromJson(v, fromJsonT)),
          errors: $checkedConvert('errors', (v) => v as Map<String, dynamic>?),
          pagination: $checkedConvert(
              'pagination',
              (v) => v == null
                  ? null
                  : PaginationMeta.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) {
  final val = <String, dynamic>{
    'success': instance.success,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull('data', _$nullableGenericToJson(instance.data, toJsonT));
  writeNotNull('errors', instance.errors);
  writeNotNull('pagination', instance.pagination?.toJson());
  return val;
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

PaginationMeta _$PaginationMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'PaginationMeta',
      json,
      ($checkedConvert) {
        final val = PaginationMeta(
          total: $checkedConvert('total', (v) => (v as num).toInt()),
          page: $checkedConvert('page', (v) => (v as num).toInt()),
          limit: $checkedConvert('limit', (v) => (v as num).toInt()),
          totalPages: $checkedConvert('total_pages', (v) => (v as num).toInt()),
          hasNext: $checkedConvert('has_next', (v) => v as bool),
          hasPrevious: $checkedConvert('has_previous', (v) => v as bool),
        );
        return val;
      },
      fieldKeyMap: const {
        'totalPages': 'total_pages',
        'hasNext': 'has_next',
        'hasPrevious': 'has_previous'
      },
    );

Map<String, dynamic> _$PaginationMetaToJson(PaginationMeta instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'total_pages': instance.totalPages,
      'has_next': instance.hasNext,
      'has_previous': instance.hasPrevious,
    };

SubscriptionListResponse _$SubscriptionListResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionListResponse',
      json,
      ($checkedConvert) {
        final val = SubscriptionListResponse(
          subscriptions: $checkedConvert(
              'subscriptions',
              (v) => (v as List<dynamic>)
                  .map((e) =>
                      SubscriptionDto.fromJson(e as Map<String, dynamic>))
                  .toList()),
          pagination: $checkedConvert(
              'pagination',
              (v) => v == null
                  ? null
                  : PaginationMeta.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$SubscriptionListResponseToJson(
    SubscriptionListResponse instance) {
  final val = <String, dynamic>{
    'subscriptions': instance.subscriptions.map((e) => e.toJson()).toList(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('pagination', instance.pagination?.toJson());
  return val;
}

SubscriptionStatsResponse _$SubscriptionStatsResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'SubscriptionStatsResponse',
      json,
      ($checkedConvert) {
        final val = SubscriptionStatsResponse(
          totalCost:
              $checkedConvert('total_cost', (v) => (v as num).toDouble()),
          monthlyCost:
              $checkedConvert('monthly_cost', (v) => (v as num).toDouble()),
          yearlyCost:
              $checkedConvert('yearly_cost', (v) => (v as num).toDouble()),
          activeSubscriptions: $checkedConvert(
              'active_subscriptions', (v) => (v as num).toInt()),
          totalSubscriptions:
              $checkedConvert('total_subscriptions', (v) => (v as num).toInt()),
          currencyBreakdown: $checkedConvert(
              'currency_breakdown',
              (v) => (v as Map<String, dynamic>).map(
                    (k, e) => MapEntry(k, (e as num).toDouble()),
                  )),
          categoryBreakdown: $checkedConvert(
              'category_breakdown',
              (v) => (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k, (e as num).toDouble()),
                  )),
          monthlyTrend: $checkedConvert(
              'monthly_trend',
              (v) => (v as List<dynamic>?)
                  ?.map((e) =>
                      MonthlyTrendData.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'totalCost': 'total_cost',
        'monthlyCost': 'monthly_cost',
        'yearlyCost': 'yearly_cost',
        'activeSubscriptions': 'active_subscriptions',
        'totalSubscriptions': 'total_subscriptions',
        'currencyBreakdown': 'currency_breakdown',
        'categoryBreakdown': 'category_breakdown',
        'monthlyTrend': 'monthly_trend'
      },
    );

Map<String, dynamic> _$SubscriptionStatsResponseToJson(
    SubscriptionStatsResponse instance) {
  final val = <String, dynamic>{
    'total_cost': instance.totalCost,
    'monthly_cost': instance.monthlyCost,
    'yearly_cost': instance.yearlyCost,
    'active_subscriptions': instance.activeSubscriptions,
    'total_subscriptions': instance.totalSubscriptions,
    'currency_breakdown': instance.currencyBreakdown,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('category_breakdown', instance.categoryBreakdown);
  writeNotNull(
      'monthly_trend', instance.monthlyTrend?.map((e) => e.toJson()).toList());
  return val;
}

MonthlyTrendData _$MonthlyTrendDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MonthlyTrendData',
      json,
      ($checkedConvert) {
        final val = MonthlyTrendData(
          month: $checkedConvert('month', (v) => v as String),
          amount: $checkedConvert('amount', (v) => (v as num).toDouble()),
          count: $checkedConvert('count', (v) => (v as num).toInt()),
        );
        return val;
      },
    );

Map<String, dynamic> _$MonthlyTrendDataToJson(MonthlyTrendData instance) =>
    <String, dynamic>{
      'month': instance.month,
      'amount': instance.amount,
      'count': instance.count,
    };

BatchOperationResponse _$BatchOperationResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'BatchOperationResponse',
      json,
      ($checkedConvert) {
        final val = BatchOperationResponse(
          affectedCount:
              $checkedConvert('affected_count', (v) => (v as num).toInt()),
          failedIds: $checkedConvert('failed_ids',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          errors: $checkedConvert('errors',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'affectedCount': 'affected_count',
        'failedIds': 'failed_ids'
      },
    );

Map<String, dynamic> _$BatchOperationResponseToJson(
    BatchOperationResponse instance) {
  final val = <String, dynamic>{
    'affected_count': instance.affectedCount,
    'failed_ids': instance.failedIds,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('errors', instance.errors);
  return val;
}
