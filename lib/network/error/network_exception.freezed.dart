// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NetworkException {
  String get message => throw _privateConstructorUsedError;
  NetworkErrorType get type => throw _privateConstructorUsedError;
  int? get statusCode => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)
        $default, {
    required TResult Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)
        simple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)?
        $default, {
    TResult? Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)?
        simple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)?
        $default, {
    TResult Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)?
        simple,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NetworkException value) $default, {
    required TResult Function(_SimpleNetworkException value) simple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NetworkException value)? $default, {
    TResult? Function(_SimpleNetworkException value)? simple,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NetworkException value)? $default, {
    TResult Function(_SimpleNetworkException value)? simple,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NetworkExceptionCopyWith<NetworkException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkExceptionCopyWith<$Res> {
  factory $NetworkExceptionCopyWith(
          NetworkException value, $Res Function(NetworkException) then) =
      _$NetworkExceptionCopyWithImpl<$Res, NetworkException>;
  @useResult
  $Res call({String message, NetworkErrorType type, int? statusCode});
}

/// @nodoc
class _$NetworkExceptionCopyWithImpl<$Res, $Val extends NetworkException>
    implements $NetworkExceptionCopyWith<$Res> {
  _$NetworkExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? statusCode = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NetworkErrorType,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkExceptionImplCopyWith<$Res>
    implements $NetworkExceptionCopyWith<$Res> {
  factory _$$NetworkExceptionImplCopyWith(_$NetworkExceptionImpl value,
          $Res Function(_$NetworkExceptionImpl) then) =
      __$$NetworkExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      NetworkErrorType type,
      Exception originalException,
      Uri uri,
      int? statusCode,
      String? stackTrace,
      Map<String, dynamic>? responseData});
}

/// @nodoc
class __$$NetworkExceptionImplCopyWithImpl<$Res>
    extends _$NetworkExceptionCopyWithImpl<$Res, _$NetworkExceptionImpl>
    implements _$$NetworkExceptionImplCopyWith<$Res> {
  __$$NetworkExceptionImplCopyWithImpl(_$NetworkExceptionImpl _value,
      $Res Function(_$NetworkExceptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? originalException = null,
    Object? uri = null,
    Object? statusCode = freezed,
    Object? stackTrace = freezed,
    Object? responseData = freezed,
  }) {
    return _then(_$NetworkExceptionImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NetworkErrorType,
      originalException: null == originalException
          ? _value.originalException
          : originalException // ignore: cast_nullable_to_non_nullable
              as Exception,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String?,
      responseData: freezed == responseData
          ? _value._responseData
          : responseData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$NetworkExceptionImpl implements _NetworkException {
  const _$NetworkExceptionImpl(
      {required this.message,
      required this.type,
      required this.originalException,
      required this.uri,
      this.statusCode,
      this.stackTrace,
      final Map<String, dynamic>? responseData})
      : _responseData = responseData;

  @override
  final String message;
  @override
  final NetworkErrorType type;
  @override
  final Exception originalException;
  @override
  final Uri uri;
  @override
  final int? statusCode;
  @override
  final String? stackTrace;
  final Map<String, dynamic>? _responseData;
  @override
  Map<String, dynamic>? get responseData {
    final value = _responseData;
    if (value == null) return null;
    if (_responseData is EqualUnmodifiableMapView) return _responseData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NetworkException(message: $message, type: $type, originalException: $originalException, uri: $uri, statusCode: $statusCode, stackTrace: $stackTrace, responseData: $responseData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkExceptionImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.originalException, originalException) ||
                other.originalException == originalException) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            const DeepCollectionEquality()
                .equals(other._responseData, _responseData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      type,
      originalException,
      uri,
      statusCode,
      stackTrace,
      const DeepCollectionEquality().hash(_responseData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkExceptionImplCopyWith<_$NetworkExceptionImpl> get copyWith =>
      __$$NetworkExceptionImplCopyWithImpl<_$NetworkExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)
        $default, {
    required TResult Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)
        simple,
  }) {
    return $default(message, type, originalException, uri, statusCode,
        stackTrace, responseData);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)?
        $default, {
    TResult? Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)?
        simple,
  }) {
    return $default?.call(message, type, originalException, uri, statusCode,
        stackTrace, responseData);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)?
        $default, {
    TResult Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)?
        simple,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(message, type, originalException, uri, statusCode,
          stackTrace, responseData);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NetworkException value) $default, {
    required TResult Function(_SimpleNetworkException value) simple,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NetworkException value)? $default, {
    TResult? Function(_SimpleNetworkException value)? simple,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NetworkException value)? $default, {
    TResult Function(_SimpleNetworkException value)? simple,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }
}

abstract class _NetworkException implements NetworkException {
  const factory _NetworkException(
      {required final String message,
      required final NetworkErrorType type,
      required final Exception originalException,
      required final Uri uri,
      final int? statusCode,
      final String? stackTrace,
      final Map<String, dynamic>? responseData}) = _$NetworkExceptionImpl;

  @override
  String get message;
  @override
  NetworkErrorType get type;
  Exception get originalException;
  Uri get uri;
  @override
  int? get statusCode;
  String? get stackTrace;
  Map<String, dynamic>? get responseData;
  @override
  @JsonKey(ignore: true)
  _$$NetworkExceptionImplCopyWith<_$NetworkExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SimpleNetworkExceptionImplCopyWith<$Res>
    implements $NetworkExceptionCopyWith<$Res> {
  factory _$$SimpleNetworkExceptionImplCopyWith(
          _$SimpleNetworkExceptionImpl value,
          $Res Function(_$SimpleNetworkExceptionImpl) then) =
      __$$SimpleNetworkExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      NetworkErrorType type,
      Exception? originalError,
      int? statusCode});
}

/// @nodoc
class __$$SimpleNetworkExceptionImplCopyWithImpl<$Res>
    extends _$NetworkExceptionCopyWithImpl<$Res, _$SimpleNetworkExceptionImpl>
    implements _$$SimpleNetworkExceptionImplCopyWith<$Res> {
  __$$SimpleNetworkExceptionImplCopyWithImpl(
      _$SimpleNetworkExceptionImpl _value,
      $Res Function(_$SimpleNetworkExceptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? originalError = freezed,
    Object? statusCode = freezed,
  }) {
    return _then(_$SimpleNetworkExceptionImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NetworkErrorType,
      originalError: freezed == originalError
          ? _value.originalError
          : originalError // ignore: cast_nullable_to_non_nullable
              as Exception?,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SimpleNetworkExceptionImpl implements _SimpleNetworkException {
  const _$SimpleNetworkExceptionImpl(
      {required this.message,
      required this.type,
      this.originalError,
      this.statusCode});

  @override
  final String message;
  @override
  final NetworkErrorType type;
  @override
  final Exception? originalError;
  @override
  final int? statusCode;

  @override
  String toString() {
    return 'NetworkException.simple(message: $message, type: $type, originalError: $originalError, statusCode: $statusCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SimpleNetworkExceptionImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.originalError, originalError) ||
                other.originalError == originalError) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, message, type, originalError, statusCode);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SimpleNetworkExceptionImplCopyWith<_$SimpleNetworkExceptionImpl>
      get copyWith => __$$SimpleNetworkExceptionImplCopyWithImpl<
          _$SimpleNetworkExceptionImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)
        $default, {
    required TResult Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)
        simple,
  }) {
    return simple(message, type, originalError, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)?
        $default, {
    TResult? Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)?
        simple,
  }) {
    return simple?.call(message, type, originalError, statusCode);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String message,
            NetworkErrorType type,
            Exception originalException,
            Uri uri,
            int? statusCode,
            String? stackTrace,
            Map<String, dynamic>? responseData)?
        $default, {
    TResult Function(String message, NetworkErrorType type,
            Exception? originalError, int? statusCode)?
        simple,
    required TResult orElse(),
  }) {
    if (simple != null) {
      return simple(message, type, originalError, statusCode);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NetworkException value) $default, {
    required TResult Function(_SimpleNetworkException value) simple,
  }) {
    return simple(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NetworkException value)? $default, {
    TResult? Function(_SimpleNetworkException value)? simple,
  }) {
    return simple?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NetworkException value)? $default, {
    TResult Function(_SimpleNetworkException value)? simple,
    required TResult orElse(),
  }) {
    if (simple != null) {
      return simple(this);
    }
    return orElse();
  }
}

abstract class _SimpleNetworkException implements NetworkException {
  const factory _SimpleNetworkException(
      {required final String message,
      required final NetworkErrorType type,
      final Exception? originalError,
      final int? statusCode}) = _$SimpleNetworkExceptionImpl;

  @override
  String get message;
  @override
  NetworkErrorType get type;
  Exception? get originalError;
  @override
  int? get statusCode;
  @override
  @JsonKey(ignore: true)
  _$$SimpleNetworkExceptionImplCopyWith<_$SimpleNetworkExceptionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AppNetworkException {
  String get message => throw _privateConstructorUsedError;
  NetworkErrorType get type => throw _privateConstructorUsedError;
  Exception get originalException => throw _privateConstructorUsedError;
  Uri get uri => throw _privateConstructorUsedError;
  int? get statusCode => throw _privateConstructorUsedError;
  String? get stackTrace => throw _privateConstructorUsedError;
  Map<String, dynamic>? get responseData => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppNetworkExceptionCopyWith<AppNetworkException> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppNetworkExceptionCopyWith<$Res> {
  factory $AppNetworkExceptionCopyWith(
          AppNetworkException value, $Res Function(AppNetworkException) then) =
      _$AppNetworkExceptionCopyWithImpl<$Res, AppNetworkException>;
  @useResult
  $Res call(
      {String message,
      NetworkErrorType type,
      Exception originalException,
      Uri uri,
      int? statusCode,
      String? stackTrace,
      Map<String, dynamic>? responseData});
}

/// @nodoc
class _$AppNetworkExceptionCopyWithImpl<$Res, $Val extends AppNetworkException>
    implements $AppNetworkExceptionCopyWith<$Res> {
  _$AppNetworkExceptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? originalException = null,
    Object? uri = null,
    Object? statusCode = freezed,
    Object? stackTrace = freezed,
    Object? responseData = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NetworkErrorType,
      originalException: null == originalException
          ? _value.originalException
          : originalException // ignore: cast_nullable_to_non_nullable
              as Exception,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String?,
      responseData: freezed == responseData
          ? _value.responseData
          : responseData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppNetworkExceptionImplCopyWith<$Res>
    implements $AppNetworkExceptionCopyWith<$Res> {
  factory _$$AppNetworkExceptionImplCopyWith(_$AppNetworkExceptionImpl value,
          $Res Function(_$AppNetworkExceptionImpl) then) =
      __$$AppNetworkExceptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      NetworkErrorType type,
      Exception originalException,
      Uri uri,
      int? statusCode,
      String? stackTrace,
      Map<String, dynamic>? responseData});
}

/// @nodoc
class __$$AppNetworkExceptionImplCopyWithImpl<$Res>
    extends _$AppNetworkExceptionCopyWithImpl<$Res, _$AppNetworkExceptionImpl>
    implements _$$AppNetworkExceptionImplCopyWith<$Res> {
  __$$AppNetworkExceptionImplCopyWithImpl(_$AppNetworkExceptionImpl _value,
      $Res Function(_$AppNetworkExceptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? originalException = null,
    Object? uri = null,
    Object? statusCode = freezed,
    Object? stackTrace = freezed,
    Object? responseData = freezed,
  }) {
    return _then(_$AppNetworkExceptionImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as NetworkErrorType,
      originalException: null == originalException
          ? _value.originalException
          : originalException // ignore: cast_nullable_to_non_nullable
              as Exception,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as Uri,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      stackTrace: freezed == stackTrace
          ? _value.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as String?,
      responseData: freezed == responseData
          ? _value._responseData
          : responseData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class _$AppNetworkExceptionImpl implements _AppNetworkException {
  const _$AppNetworkExceptionImpl(
      {required this.message,
      required this.type,
      required this.originalException,
      required this.uri,
      this.statusCode,
      this.stackTrace,
      final Map<String, dynamic>? responseData})
      : _responseData = responseData;

  @override
  final String message;
  @override
  final NetworkErrorType type;
  @override
  final Exception originalException;
  @override
  final Uri uri;
  @override
  final int? statusCode;
  @override
  final String? stackTrace;
  final Map<String, dynamic>? _responseData;
  @override
  Map<String, dynamic>? get responseData {
    final value = _responseData;
    if (value == null) return null;
    if (_responseData is EqualUnmodifiableMapView) return _responseData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AppNetworkException(message: $message, type: $type, originalException: $originalException, uri: $uri, statusCode: $statusCode, stackTrace: $stackTrace, responseData: $responseData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppNetworkExceptionImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.originalException, originalException) ||
                other.originalException == originalException) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace) &&
            const DeepCollectionEquality()
                .equals(other._responseData, _responseData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      message,
      type,
      originalException,
      uri,
      statusCode,
      stackTrace,
      const DeepCollectionEquality().hash(_responseData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppNetworkExceptionImplCopyWith<_$AppNetworkExceptionImpl> get copyWith =>
      __$$AppNetworkExceptionImplCopyWithImpl<_$AppNetworkExceptionImpl>(
          this, _$identity);
}

abstract class _AppNetworkException implements AppNetworkException {
  const factory _AppNetworkException(
      {required final String message,
      required final NetworkErrorType type,
      required final Exception originalException,
      required final Uri uri,
      final int? statusCode,
      final String? stackTrace,
      final Map<String, dynamic>? responseData}) = _$AppNetworkExceptionImpl;

  @override
  String get message;
  @override
  NetworkErrorType get type;
  @override
  Exception get originalException;
  @override
  Uri get uri;
  @override
  int? get statusCode;
  @override
  String? get stackTrace;
  @override
  Map<String, dynamic>? get responseData;
  @override
  @JsonKey(ignore: true)
  _$$AppNetworkExceptionImplCopyWith<_$AppNetworkExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
