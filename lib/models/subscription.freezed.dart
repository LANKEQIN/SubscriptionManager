// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Subscription {
  /// 订阅的唯一标识符
  String get id => throw _privateConstructorUsedError;

  /// 订阅名称
  String get name => throw _privateConstructorUsedError;

  /// 订阅图标（可选）
  String? get icon => throw _privateConstructorUsedError;

  /// 订阅类型
  String get type => throw _privateConstructorUsedError;

  /// 订阅价格
  double get price => throw _privateConstructorUsedError;

  /// 货币类型，默认为CNY
  String get currency => throw _privateConstructorUsedError;

  /// 计费周期：每月/每年/一次性
  String get billingCycle => throw _privateConstructorUsedError;

  /// 下次付款日期
  DateTime get nextPaymentDate => throw _privateConstructorUsedError;

  /// 是否自动续费
  bool get autoRenewal => throw _privateConstructorUsedError;

  /// 备注信息（可选）
  String? get notes => throw _privateConstructorUsedError; // 同步相关字段
  /// 服务器端ID（用于同步）
  String? get serverId => throw _privateConstructorUsedError;

  /// 创建时间
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 最后更新时间
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 最后同步时间
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// 是否需要同步
  bool get needsSync => throw _privateConstructorUsedError;

  /// 同步状态
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
          Subscription value, $Res Function(Subscription) then) =
      _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? icon,
      String type,
      double price,
      String currency,
      String billingCycle,
      DateTime nextPaymentDate,
      bool autoRenewal,
      String? notes,
      String? serverId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastSyncedAt,
      bool needsSync,
      SyncStatus syncStatus});
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = freezed,
    Object? type = null,
    Object? price = null,
    Object? currency = null,
    Object? billingCycle = null,
    Object? nextPaymentDate = null,
    Object? autoRenewal = null,
    Object? notes = freezed,
    Object? serverId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? needsSync = null,
    Object? syncStatus = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      billingCycle: null == billingCycle
          ? _value.billingCycle
          : billingCycle // ignore: cast_nullable_to_non_nullable
              as String,
      nextPaymentDate: null == nextPaymentDate
          ? _value.nextPaymentDate
          : nextPaymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      autoRenewal: null == autoRenewal
          ? _value.autoRenewal
          : autoRenewal // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsSync: null == needsSync
          ? _value.needsSync
          : needsSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
          _$SubscriptionImpl value, $Res Function(_$SubscriptionImpl) then) =
      __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? icon,
      String type,
      double price,
      String currency,
      String billingCycle,
      DateTime nextPaymentDate,
      bool autoRenewal,
      String? notes,
      String? serverId,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? lastSyncedAt,
      bool needsSync,
      SyncStatus syncStatus});
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
      _$SubscriptionImpl _value, $Res Function(_$SubscriptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = freezed,
    Object? type = null,
    Object? price = null,
    Object? currency = null,
    Object? billingCycle = null,
    Object? nextPaymentDate = null,
    Object? autoRenewal = null,
    Object? notes = freezed,
    Object? serverId = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? lastSyncedAt = freezed,
    Object? needsSync = null,
    Object? syncStatus = null,
  }) {
    return _then(_$SubscriptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      billingCycle: null == billingCycle
          ? _value.billingCycle
          : billingCycle // ignore: cast_nullable_to_non_nullable
              as String,
      nextPaymentDate: null == nextPaymentDate
          ? _value.nextPaymentDate
          : nextPaymentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      autoRenewal: null == autoRenewal
          ? _value.autoRenewal
          : autoRenewal // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsSync: null == needsSync
          ? _value.needsSync
          : needsSync // ignore: cast_nullable_to_non_nullable
              as bool,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// @nodoc

class _$SubscriptionImpl extends _Subscription {
  const _$SubscriptionImpl(
      {this.id = '',
      required this.name,
      this.icon,
      required this.type,
      required this.price,
      this.currency = 'CNY',
      required this.billingCycle,
      required this.nextPaymentDate,
      this.autoRenewal = false,
      this.notes,
      this.serverId,
      this.createdAt,
      this.updatedAt,
      this.lastSyncedAt,
      this.needsSync = false,
      this.syncStatus = SyncStatus.synced})
      : super._();

  /// 订阅的唯一标识符
  @override
  @JsonKey()
  final String id;

  /// 订阅名称
  @override
  final String name;

  /// 订阅图标（可选）
  @override
  final String? icon;

  /// 订阅类型
  @override
  final String type;

  /// 订阅价格
  @override
  final double price;

  /// 货币类型，默认为CNY
  @override
  @JsonKey()
  final String currency;

  /// 计费周期：每月/每年/一次性
  @override
  final String billingCycle;

  /// 下次付款日期
  @override
  final DateTime nextPaymentDate;

  /// 是否自动续费
  @override
  @JsonKey()
  final bool autoRenewal;

  /// 备注信息（可选）
  @override
  final String? notes;
// 同步相关字段
  /// 服务器端ID（用于同步）
  @override
  final String? serverId;

  /// 创建时间
  @override
  final DateTime? createdAt;

  /// 最后更新时间
  @override
  final DateTime? updatedAt;

  /// 最后同步时间
  @override
  final DateTime? lastSyncedAt;

  /// 是否需要同步
  @override
  @JsonKey()
  final bool needsSync;

  /// 同步状态
  @override
  @JsonKey()
  final SyncStatus syncStatus;

  @override
  String toString() {
    return 'Subscription(id: $id, name: $name, icon: $icon, type: $type, price: $price, currency: $currency, billingCycle: $billingCycle, nextPaymentDate: $nextPaymentDate, autoRenewal: $autoRenewal, notes: $notes, serverId: $serverId, createdAt: $createdAt, updatedAt: $updatedAt, lastSyncedAt: $lastSyncedAt, needsSync: $needsSync, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.billingCycle, billingCycle) ||
                other.billingCycle == billingCycle) &&
            (identical(other.nextPaymentDate, nextPaymentDate) ||
                other.nextPaymentDate == nextPaymentDate) &&
            (identical(other.autoRenewal, autoRenewal) ||
                other.autoRenewal == autoRenewal) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.needsSync, needsSync) ||
                other.needsSync == needsSync) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      icon,
      type,
      price,
      currency,
      billingCycle,
      nextPaymentDate,
      autoRenewal,
      notes,
      serverId,
      createdAt,
      updatedAt,
      lastSyncedAt,
      needsSync,
      syncStatus);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);
}

abstract class _Subscription extends Subscription {
  const factory _Subscription(
      {final String id,
      required final String name,
      final String? icon,
      required final String type,
      required final double price,
      final String currency,
      required final String billingCycle,
      required final DateTime nextPaymentDate,
      final bool autoRenewal,
      final String? notes,
      final String? serverId,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final DateTime? lastSyncedAt,
      final bool needsSync,
      final SyncStatus syncStatus}) = _$SubscriptionImpl;
  const _Subscription._() : super._();

  @override

  /// 订阅的唯一标识符
  String get id;
  @override

  /// 订阅名称
  String get name;
  @override

  /// 订阅图标（可选）
  String? get icon;
  @override

  /// 订阅类型
  String get type;
  @override

  /// 订阅价格
  double get price;
  @override

  /// 货币类型，默认为CNY
  String get currency;
  @override

  /// 计费周期：每月/每年/一次性
  String get billingCycle;
  @override

  /// 下次付款日期
  DateTime get nextPaymentDate;
  @override

  /// 是否自动续费
  bool get autoRenewal;
  @override

  /// 备注信息（可选）
  String? get notes;
  @override // 同步相关字段
  /// 服务器端ID（用于同步）
  String? get serverId;
  @override

  /// 创建时间
  DateTime? get createdAt;
  @override

  /// 最后更新时间
  DateTime? get updatedAt;
  @override

  /// 最后同步时间
  DateTime? get lastSyncedAt;
  @override

  /// 是否需要同步
  bool get needsSync;
  @override

  /// 同步状态
  SyncStatus get syncStatus;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
