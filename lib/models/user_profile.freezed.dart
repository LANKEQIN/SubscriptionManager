// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserProfile {
  /// 用户ID (对应Supabase auth.users.id)
  String get userId => throw _privateConstructorUsedError;

  /// 显示名称
  String? get displayName => throw _privateConstructorUsedError;

  /// 头像URL
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// 基础货币
  String get baseCurrency => throw _privateConstructorUsedError;

  /// 主题模式
  String get themeMode => throw _privateConstructorUsedError;

  /// 字体大小
  double get fontSize => throw _privateConstructorUsedError;

  /// 主题颜色
  String? get themeColor => throw _privateConstructorUsedError;

  /// 是否启用同步
  bool get syncEnabled => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String userId,
      String? displayName,
      String? avatarUrl,
      String baseCurrency,
      String themeMode,
      double fontSize,
      String? themeColor,
      bool syncEnabled,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? baseCurrency = null,
    Object? themeMode = null,
    Object? fontSize = null,
    Object? themeColor = freezed,
    Object? syncEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      baseCurrency: null == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      themeColor: freezed == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as String?,
      syncEnabled: null == syncEnabled
          ? _value.syncEnabled
          : syncEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String? displayName,
      String? avatarUrl,
      String baseCurrency,
      String themeMode,
      double fontSize,
      String? themeColor,
      bool syncEnabled,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? baseCurrency = null,
    Object? themeMode = null,
    Object? fontSize = null,
    Object? themeColor = freezed,
    Object? syncEnabled = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$UserProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      baseCurrency: null == baseCurrency
          ? _value.baseCurrency
          : baseCurrency // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as String,
      fontSize: null == fontSize
          ? _value.fontSize
          : fontSize // ignore: cast_nullable_to_non_nullable
              as double,
      themeColor: freezed == themeColor
          ? _value.themeColor
          : themeColor // ignore: cast_nullable_to_non_nullable
              as String?,
      syncEnabled: null == syncEnabled
          ? _value.syncEnabled
          : syncEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$UserProfileImpl extends _UserProfile {
  const _$UserProfileImpl(
      {required this.userId,
      this.displayName,
      this.avatarUrl,
      this.baseCurrency = 'CNY',
      this.themeMode = 'system',
      this.fontSize = 14.0,
      this.themeColor,
      this.syncEnabled = true,
      this.createdAt,
      this.updatedAt})
      : super._();

  /// 用户ID (对应Supabase auth.users.id)
  @override
  final String userId;

  /// 显示名称
  @override
  final String? displayName;

  /// 头像URL
  @override
  final String? avatarUrl;

  /// 基础货币
  @override
  @JsonKey()
  final String baseCurrency;

  /// 主题模式
  @override
  @JsonKey()
  final String themeMode;

  /// 字体大小
  @override
  @JsonKey()
  final double fontSize;

  /// 主题颜色
  @override
  final String? themeColor;

  /// 是否启用同步
  @override
  @JsonKey()
  final bool syncEnabled;

  /// 创建时间
  @override
  final DateTime? createdAt;

  /// 最后更新时间
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, displayName: $displayName, avatarUrl: $avatarUrl, baseCurrency: $baseCurrency, themeMode: $themeMode, fontSize: $fontSize, themeColor: $themeColor, syncEnabled: $syncEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.themeColor, themeColor) ||
                other.themeColor == themeColor) &&
            (identical(other.syncEnabled, syncEnabled) ||
                other.syncEnabled == syncEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      displayName,
      avatarUrl,
      baseCurrency,
      themeMode,
      fontSize,
      themeColor,
      syncEnabled,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);
}

abstract class _UserProfile extends UserProfile {
  const factory _UserProfile(
      {required final String userId,
      final String? displayName,
      final String? avatarUrl,
      final String baseCurrency,
      final String themeMode,
      final double fontSize,
      final String? themeColor,
      final bool syncEnabled,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$UserProfileImpl;
  const _UserProfile._() : super._();

  @override

  /// 用户ID (对应Supabase auth.users.id)
  String get userId;
  @override

  /// 显示名称
  String? get displayName;
  @override

  /// 头像URL
  String? get avatarUrl;
  @override

  /// 基础货币
  String get baseCurrency;
  @override

  /// 主题模式
  String get themeMode;
  @override

  /// 字体大小
  double get fontSize;
  @override

  /// 主题颜色
  String? get themeColor;
  @override

  /// 是否启用同步
  bool get syncEnabled;
  @override

  /// 创建时间
  DateTime? get createdAt;
  @override

  /// 最后更新时间
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
