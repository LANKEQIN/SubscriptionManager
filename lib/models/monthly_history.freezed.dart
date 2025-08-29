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
  int get year => throw _privateConstructorUsedError;
  int get month => throw _privateConstructorUsedError;
  double get totalCost => throw _privateConstructorUsedError;

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
  $Res call({int year, int month, double totalCost});
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
    Object? year = null,
    Object? month = null,
    Object? totalCost = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
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
  $Res call({int year, int month, double totalCost});
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
    Object? year = null,
    Object? month = null,
    Object? totalCost = null,
  }) {
    return _then(_$MonthlyHistoryImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      totalCost: null == totalCost
          ? _value.totalCost
          : totalCost // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$MonthlyHistoryImpl implements _MonthlyHistory {
  const _$MonthlyHistoryImpl(
      {required this.year, required this.month, required this.totalCost});

  @override
  final int year;
  @override
  final int month;
  @override
  final double totalCost;

  @override
  String toString() {
    return 'MonthlyHistory(year: $year, month: $month, totalCost: $totalCost)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyHistoryImpl &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.totalCost, totalCost) ||
                other.totalCost == totalCost));
  }

  @override
  int get hashCode => Object.hash(runtimeType, year, month, totalCost);

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyHistoryImplCopyWith<_$MonthlyHistoryImpl> get copyWith =>
      __$$MonthlyHistoryImplCopyWithImpl<_$MonthlyHistoryImpl>(
          this, _$identity);
}

abstract class _MonthlyHistory implements MonthlyHistory {
  const factory _MonthlyHistory(
      {required final int year,
      required final int month,
      required final double totalCost}) = _$MonthlyHistoryImpl;

  @override
  int get year;
  @override
  int get month;
  @override
  double get totalCost;

  /// Create a copy of MonthlyHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MonthlyHistoryImplCopyWith<_$MonthlyHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
