// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubscriptionState {
  /// 订阅列表
  List<Subscription> get subscriptions => throw _privateConstructorUsedError;

  /// 月度历史记录
  List<MonthlyHistory> get monthlyHistories =>
      throw _privateConstructorUsedError;

  /// 主题模式
  ThemeMode get themeMode => throw _privateConstructorUsedError;

  /// 字体大小
  double get fontSize => throw _privateConstructorUsedError;

  /// 主题颜色
  Color? get themeColor => throw _privateConstructorUsedError;

  /// 是否有未读通知
  bool get hasUnreadNotifications => throw _privateConstructorUsedError;

  /// 基础货币
  String get baseCurrency => throw _privateConstructorUsedError;

  /// 是否正在加载
  bool get isLoading => throw _privateConstructorUsedError;

  /// 错误信息
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionStateCopyWith<SubscriptionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionStateCopyWith<$Res> {
  factory $SubscriptionStateCopyWith(
          SubscriptionState value, $Res Function(SubscriptionState) then) =
      _$SubscriptionStateCopyWithImpl<$Res, SubscriptionState>;
  @useResult
  $Res call(
      {List<Subscription> subscriptions,
      List<MonthlyHistory> monthlyHistories,
      ThemeMode themeMode,
      double fontSize,
      Color? themeColor,
      bool hasUnreadNotifications,
      String baseCurrency,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$SubscriptionStateCopyWithImpl<$Res, $Val extends SubscriptionState>
    implements $SubscriptionStateCopyWith<$Res> {
  _$SubscriptionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptions = null,
    Object? monthlyHistories = null,
    Object? themeMode = null,
    Object? fontSize = null,
    Object? themeColor = freezed,
    Object? hasUnreadNotifications = null,
    Object? baseCurrency = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      subscriptions: null == subscriptions
          ? _value.subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<Subscription>,
      monthlyHistories: null == monthlyHistories
          ? _value.monthlyHistories
          : monthlyHistories // ignore: cast_nullable_to_non_nullable
              as List<MonthlyHistory>,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      themeColor: freezed == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      hasUnreadNotifications: null == hasUnreadNotifications
          ? _value.hasUnreadNotifications
          : hasUnreadNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      baseCurrency: null == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionStateImplCopyWith<$Res>
    implements $SubscriptionStateCopyWith<$Res> {
  factory _$$SubscriptionStateImplCopyWith(_$SubscriptionStateImpl value,
          $Res Function(_$SubscriptionStateImpl) then) =
      __$$SubscriptionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Subscription> subscriptions,
      List<MonthlyHistory> monthlyHistories,
      ThemeMode themeMode,
      double fontSize,
      Color? themeColor,
      bool hasUnreadNotifications,
      String baseCurrency,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$SubscriptionStateImplCopyWithImpl<$Res>
    extends _$SubscriptionStateCopyWithImpl<$Res, _$SubscriptionStateImpl>
    implements _$$SubscriptionStateImplCopyWith<$Res> {
  __$$SubscriptionStateImplCopyWithImpl(_$SubscriptionStateImpl _value,
      $Res Function(_$SubscriptionStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subscriptions = null,
    Object? monthlyHistories = null,
    Object? themeMode = null,
    Object? fontSize = null,
    Object? themeColor = freezed,
    Object? hasUnreadNotifications = null,
    Object? baseCurrency = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$SubscriptionStateImpl(
      subscriptions: null == subscriptions
          ? _value._subscriptions
          : subscriptions // ignore: cast_nullable_to_non_nullable
              as List<Subscription>,
      monthlyHistories: null == monthlyHistories
          ? _value._monthlyHistories
          : monthlyHistories // ignore: cast_nullable_to_non_nullable
              as List<MonthlyHistory>,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      themeColor: freezed == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as Color?,
      hasUnreadNotifications: null == hasUnreadNotifications
          ? _value.hasUnreadNotifications
          : hasUnreadNotifications // ignore: cast_nullable_to_non_nullable
              as bool,
      baseCurrency: null == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SubscriptionStateImpl extends _SubscriptionState {
  const _$SubscriptionStateImpl(
      {final List<Subscription> subscriptions = const [],
      final List<MonthlyHistory> monthlyHistories = const [],
      this.themeMode = ThemeMode.system,
      this.fontSize = 14.0,
      this.themeColor,
      this.hasUnreadNotifications = false,
      this.baseCurrency = 'CNY',
      this.isLoading = false,
      this.error})
      : _subscriptions = subscriptions,
        _monthlyHistories = monthlyHistories,
        super._();

  /// 订阅列表
  final List<Subscription> _subscriptions;

  /// 订阅列表
  @override
  @JsonKey()
  List<Subscription> get subscriptions {
    if (_subscriptions is EqualUnmodifiableListView) return _subscriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscriptions);
  }

  /// 月度历史记录
  final List<MonthlyHistory> _monthlyHistories;

  /// 月度历史记录
  @override
  @JsonKey()
  List<MonthlyHistory> get monthlyHistories {
    if (_monthlyHistories is EqualUnmodifiableListView)
      return _monthlyHistories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_monthlyHistories);
  }

  /// 主题模式
  @override
  @JsonKey()
  final ThemeMode themeMode;

  /// 字体大小
  @override
  @JsonKey()
  final double fontSize;

  /// 主题颜色
  @override
  final Color? themeColor;

  /// 是否有未读通知
  @override
  @JsonKey()
  final bool hasUnreadNotifications;

  /// 基础货币
  @override
  @JsonKey()
  final String baseCurrency;

  /// 是否正在加载
  @override
  @JsonKey()
  final bool isLoading;

  /// 错误信息
  @override
  final String? error;

  @override
  String toString() {
    return 'SubscriptionState(subscriptions: $subscriptions, monthlyHistories: $monthlyHistories, themeMode: $themeMode, fontSize: $fontSize, themeColor: $themeColor, hasUnreadNotifications: $hasUnreadNotifications, baseCurrency: $baseCurrency, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionStateImpl &&
            const DeepCollectionEquality()
                .equals(other._subscriptions, _subscriptions) &&
            const DeepCollectionEquality()
                .equals(other._monthlyHistories, _monthlyHistories) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.hasUnreadNotifications, hasUnreadNotifications) ||
                other.hasUnreadNotifications == hasUnreadNotifications) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_subscriptions),
      const DeepCollectionEquality().hash(_monthlyHistories),
      themeMode,
      fontSize,
      themeColor,
      hasUnreadNotifications,
      baseCurrency,
      isLoading,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionStateImplCopyWith<_$SubscriptionStateImpl> get copyWith =>
      __$$SubscriptionStateImplCopyWithImpl<_$SubscriptionStateImpl>(
          this, _$identity);
}

abstract class _SubscriptionState extends SubscriptionState {
  const factory _SubscriptionState(
      {final List<Subscription> subscriptions,
      final List<MonthlyHistory> monthlyHistories,
      final ThemeMode themeMode,
      final double fontSize,
      final Color? themeColor,
      final bool hasUnreadNotifications,
      final String baseCurrency,
      final bool isLoading,
      final String? error}) = _$SubscriptionStateImpl;
  const _SubscriptionState._() : super._();

  @override

  /// 订阅列表
  List<Subscription> get subscriptions;
  @override

  /// 月度历史记录
  List<MonthlyHistory> get monthlyHistories;
  @override

  /// 主题模式
  ThemeMode get themeMode;
  @override

  /// 字体大小
  double get fontSize;
  @override

  /// 主题颜色
  Color? get themeColor;
  @override

  /// 是否有未读通知
  bool get hasUnreadNotifications;
  @override

  /// 基础货币
  String get baseCurrency;
  @override

  /// 是否正在加载
  bool get isLoading;
  @override

  /// 错误信息
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionStateImplCopyWith<_$SubscriptionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
