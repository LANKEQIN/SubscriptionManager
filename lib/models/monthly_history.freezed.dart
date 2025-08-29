// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MonthlyHistory {
  /// 历史记录唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 年份
  int get year => throw _privateConstructorUsedError;

  /// 月份 (1-12)
  int get month => throw _privateConstructorUsedError;

  /// 当月总金额
  double get totalAmount => throw _privateConstructorUsedError;

  /// 货币类型
  String get currency => throw _privateConstructorUsedError;

  /// 当月订阅数量
  int get subscriptionCount => throw _privateConstructorUsedError;

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MonthlyHistoryCopyWith<MonthlyHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyHistoryCopyWith<$Res> {
  factory $MonthlyHistoryCopyWith(
          MonthlyHistory value, $Res Function(MonthlyHistory) then) =
      _$MonthlyHistoryCopyWithImpl<$Res, MonthlyHistory>;
  @useResult
  $Res call(
      {String id,
      int year,
      int month,
      double totalAmount,
      String currency,
      int subscriptionCount});
}

/// @nodoc
class _$MonthlyHistoryCopyWithImpl<$Res, $Val extends MonthlyHistory>
    implements $MonthlyHistoryCopyWith<$Res> {
  _$MonthlyHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? year = null,
    Object? month = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? subscriptionCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionCount: null == subscriptionCount
          ? _value.subscriptionCount
          : subscriptionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyHistoryImplCopyWith<$Res>
    implements $MonthlyHistoryCopyWith<$Res> {
  factory _$$MonthlyHistoryImplCopyWith(_$MonthlyHistoryImpl value,
          $Res Function(_$MonthlyHistoryImpl) then) =
      __$$MonthlyHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int year,
      int month,
      double totalAmount,
      String currency,
      int subscriptionCount});
}

/// @nodoc
class __$$MonthlyHistoryImplCopyWithImpl<$Res>
    extends _$MonthlyHistoryCopyWithImpl<$Res, _$MonthlyHistoryImpl>
    implements _$$MonthlyHistoryImplCopyWith<$Res> {
  __$$MonthlyHistoryImplCopyWithImpl(
      _$MonthlyHistoryImpl _value, $Res Function(_$MonthlyHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? year = null,
    Object? month = null,
    Object? totalAmount = null,
    Object? currency = null,
    Object? subscriptionCount = null,
  }) {
    return _then(_$MonthlyHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      subscriptionCount: null == subscriptionCount
          ? _value.subscriptionCount
          : subscriptionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MonthlyHistoryImpl extends _MonthlyHistory {
  const _$MonthlyHistoryImpl(
      {this.id = '',
      required this.year,
      required this.month,
      required this.totalAmount,
      this.currency = 'CNY',
      required this.subscriptionCount})
      : super._();

  /// 历史记录唯一标识符
  @override
  @JsonKey()
  final String id;

  /// 年份
  @override
  final int year;

  /// 月份 (1-12)
  @override
  final int month;

  /// 当月总金额
  @override
  final double totalAmount;

  /// 货币类型
  @override
  @JsonKey()
  final String currency;

  /// 当月订阅数量
  @override
  final int subscriptionCount;

  @override
  String toString() {
    return 'MonthlyHistory(id: $id, year: $year, month: $month, totalAmount: $totalAmount, currency: $currency, subscriptionCount: $subscriptionCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.subscriptionCount, subscriptionCount) ||
                other.subscriptionCount == subscriptionCount));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, year, month, totalAmount, currency, subscriptionCount);

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyHistoryImplCopyWith<_$MonthlyHistoryImpl> get copyWith =>
      __$$MonthlyHistoryImplCopyWithImpl<_$MonthlyHistoryImpl>(
          this, _$identity);
}

abstract class _MonthlyHistory extends MonthlyHistory {
  const factory _MonthlyHistory(
      {final String id,
      required final int year,
      required final int month,
      required final double totalAmount,
      final String currency,
      required final int subscriptionCount}) = _$MonthlyHistoryImpl;
  const _MonthlyHistory._() : super._();

  /// 历史记录唯一标识符
  @override
  String get id;

  /// 年份
  @override
  int get year;

  /// 月份 (1-12)
  @override
  int get month;

  /// 当月总金额
  @override
  double get totalAmount;

  /// 货币类型
  @override
  String get currency;

  /// 当月订阅数量
  @override
  int get subscriptionCount;

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyHistoryImplCopyWith<_$MonthlyHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
