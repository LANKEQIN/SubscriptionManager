// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncState {
  /// 是否正在同步
  bool get isLoading => throw _privateConstructorUsedError;

  /// 同步错误信息
  String? get error => throw _privateConstructorUsedError;

  /// 最后同步时间
  DateTime? get lastSyncTime => throw _privateConstructorUsedError;

  /// 网络状态
  NetworkStatus get networkStatus => throw _privateConstructorUsedError;

  /// 待同步的项目数量
  int get pendingSyncCount => throw _privateConstructorUsedError;

  /// 冲突的项目数量
  int get conflictCount => throw _privateConstructorUsedError;

  /// 同步进度 (0.0 - 1.0)
  double get progress => throw _privateConstructorUsedError;

  /// 同步状态描述
  String? get statusMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SyncStateCopyWith<SyncState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStateCopyWith<$Res> {
  factory $SyncStateCopyWith(SyncState value, $Res Function(SyncState) then) =
      _$SyncStateCopyWithImpl<$Res, SyncState>;
  @useResult
  $Res call(
      {bool isLoading,
      String? error,
      DateTime? lastSyncTime,
      NetworkStatus networkStatus,
      int pendingSyncCount,
      int conflictCount,
      double progress,
      String? statusMessage});
}

/// @nodoc
class _$SyncStateCopyWithImpl<$Res, $Val extends SyncState>
    implements $SyncStateCopyWith<$Res> {
  _$SyncStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? lastSyncTime = freezed,
    Object? networkStatus = null,
    Object? pendingSyncCount = null,
    Object? conflictCount = null,
    Object? progress = null,
    Object? statusMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSyncTime: freezed == lastSyncTime
          ? _value.lastSyncTime
          : lastSyncTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      networkStatus: null == networkStatus
          ? _value.networkStatus
          : networkStatus // ignore: cast_nullable_to_non_nullable
              as NetworkStatus,
      pendingSyncCount: null == pendingSyncCount
          ? _value.pendingSyncCount
          : pendingSyncCount // ignore: cast_nullable_to_non_nullable
              as int,
      conflictCount: null == conflictCount
          ? _value.conflictCount
          : conflictCount // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStateImplCopyWith<$Res>
    implements $SyncStateCopyWith<$Res> {
  factory _$$SyncStateImplCopyWith(
          _$SyncStateImpl value, $Res Function(_$SyncStateImpl) then) =
      __$$SyncStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String? error,
      DateTime? lastSyncTime,
      NetworkStatus networkStatus,
      int pendingSyncCount,
      int conflictCount,
      double progress,
      String? statusMessage});
}

/// @nodoc
class __$$SyncStateImplCopyWithImpl<$Res>
    extends _$SyncStateCopyWithImpl<$Res, _$SyncStateImpl>
    implements _$$SyncStateImplCopyWith<$Res> {
  __$$SyncStateImplCopyWithImpl(
      _$SyncStateImpl _value, $Res Function(_$SyncStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = freezed,
    Object? lastSyncTime = freezed,
    Object? networkStatus = null,
    Object? pendingSyncCount = null,
    Object? conflictCount = null,
    Object? progress = null,
    Object? statusMessage = freezed,
  }) {
    return _then(_$SyncStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSyncTime: freezed == lastSyncTime
          ? _value.lastSyncTime
          : lastSyncTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      networkStatus: null == networkStatus
          ? _value.networkStatus
          : networkStatus // ignore: cast_nullable_to_non_nullable
              as NetworkStatus,
      pendingSyncCount: null == pendingSyncCount
          ? _value.pendingSyncCount
          : pendingSyncCount // ignore: cast_nullable_to_non_nullable
              as int,
      conflictCount: null == conflictCount
          ? _value.conflictCount
          : conflictCount // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SyncStateImpl extends _SyncState {
  const _$SyncStateImpl(
      {this.isLoading = false,
      this.error,
      this.lastSyncTime,
      this.networkStatus = NetworkStatus.unknown,
      this.pendingSyncCount = 0,
      this.conflictCount = 0,
      this.progress = 0.0,
      this.statusMessage})
      : super._();

  /// 是否正在同步
  @override
  @JsonKey()
  final bool isLoading;

  /// 同步错误信息
  @override
  final String? error;

  /// 最后同步时间
  @override
  final DateTime? lastSyncTime;

  /// 网络状态
  @override
  @JsonKey()
  final NetworkStatus networkStatus;

  /// 待同步的项目数量
  @override
  @JsonKey()
  final int pendingSyncCount;

  /// 冲突的项目数量
  @override
  @JsonKey()
  final int conflictCount;

  /// 同步进度 (0.0 - 1.0)
  @override
  @JsonKey()
  final double progress;

  /// 同步状态描述
  @override
  final String? statusMessage;

  @override
  String toString() {
    return 'SyncState(isLoading: $isLoading, error: $error, lastSyncTime: $lastSyncTime, networkStatus: $networkStatus, pendingSyncCount: $pendingSyncCount, conflictCount: $conflictCount, progress: $progress, statusMessage: $statusMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.lastSyncTime, lastSyncTime) ||
                other.lastSyncTime == lastSyncTime) &&
            (identical(other.networkStatus, networkStatus) ||
                other.networkStatus == networkStatus) &&
            (identical(other.pendingSyncCount, pendingSyncCount) ||
                other.pendingSyncCount == pendingSyncCount) &&
            (identical(other.conflictCount, conflictCount) ||
                other.conflictCount == conflictCount) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, error, lastSyncTime,
      networkStatus, pendingSyncCount, conflictCount, progress, statusMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      __$$SyncStateImplCopyWithImpl<_$SyncStateImpl>(this, _$identity);
}

abstract class _SyncState extends SyncState {
  const factory _SyncState(
      {final bool isLoading,
      final String? error,
      final DateTime? lastSyncTime,
      final NetworkStatus networkStatus,
      final int pendingSyncCount,
      final int conflictCount,
      final double progress,
      final String? statusMessage}) = _$SyncStateImpl;
  const _SyncState._() : super._();

  @override

  /// 是否正在同步
  bool get isLoading;
  @override

  /// 同步错误信息
  String? get error;
  @override

  /// 最后同步时间
  DateTime? get lastSyncTime;
  @override

  /// 网络状态
  NetworkStatus get networkStatus;
  @override

  /// 待同步的项目数量
  int get pendingSyncCount;
  @override

  /// 冲突的项目数量
  int get conflictCount;
  @override

  /// 同步进度 (0.0 - 1.0)
  double get progress;
  @override

  /// 同步状态描述
  String? get statusMessage;
  @override
  @JsonKey(ignore: true)
  _$$SyncStateImplCopyWith<_$SyncStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
