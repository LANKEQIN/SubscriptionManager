// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SignUpResponse',
      json,
      ($checkedConvert) {
        final val = SignUpResponse(
          accessToken: $checkedConvert('accessToken', (v) => v as String?),
          refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
          expiresIn: $checkedConvert('expiresIn', (v) => (v as num?)?.toInt()),
          tokenType: $checkedConvert('tokenType', (v) => v as String?),
          user: $checkedConvert(
              'user',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) =>
    <String, dynamic>{
      if (instance.accessToken case final value?) 'accessToken': value,
      if (instance.refreshToken case final value?) 'refreshToken': value,
      if (instance.expiresIn case final value?) 'expiresIn': value,
      if (instance.tokenType case final value?) 'tokenType': value,
      if (instance.user?.toJson() case final value?) 'user': value,
    };

SignInResponse _$SignInResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'SignInResponse',
      json,
      ($checkedConvert) {
        final val = SignInResponse(
          accessToken: $checkedConvert('accessToken', (v) => v as String?),
          refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
          expiresIn: $checkedConvert('expiresIn', (v) => (v as num?)?.toInt()),
          tokenType: $checkedConvert('tokenType', (v) => v as String?),
          user: $checkedConvert(
              'user',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$SignInResponseToJson(SignInResponse instance) =>
    <String, dynamic>{
      if (instance.accessToken case final value?) 'accessToken': value,
      if (instance.refreshToken case final value?) 'refreshToken': value,
      if (instance.expiresIn case final value?) 'expiresIn': value,
      if (instance.tokenType case final value?) 'tokenType': value,
      if (instance.user?.toJson() case final value?) 'user': value,
    };

RefreshTokenResponse _$RefreshTokenResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'RefreshTokenResponse',
      json,
      ($checkedConvert) {
        final val = RefreshTokenResponse(
          accessToken: $checkedConvert('accessToken', (v) => v as String?),
          refreshToken: $checkedConvert('refreshToken', (v) => v as String?),
          expiresIn: $checkedConvert('expiresIn', (v) => (v as num?)?.toInt()),
          tokenType: $checkedConvert('tokenType', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$RefreshTokenResponseToJson(
        RefreshTokenResponse instance) =>
    <String, dynamic>{
      if (instance.accessToken case final value?) 'accessToken': value,
      if (instance.refreshToken case final value?) 'refreshToken': value,
      if (instance.expiresIn case final value?) 'expiresIn': value,
      if (instance.tokenType case final value?) 'tokenType': value,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserResponse',
      json,
      ($checkedConvert) {
        final val = UserResponse(
          user: $checkedConvert(
              'user', (v) => User.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
    };

User _$UserFromJson(Map<String, dynamic> json) => $checkedCreate(
      'User',
      json,
      ($checkedConvert) {
        final val = User(
          id: $checkedConvert('id', (v) => v as String),
          email: $checkedConvert('email', (v) => v as String?),
          name: $checkedConvert('name', (v) => v as String?),
          avatarUrl: $checkedConvert('avatarUrl', (v) => v as String?),
          createdAt: $checkedConvert('createdAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          updatedAt: $checkedConvert('updatedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          accessToken: $checkedConvert('accessToken', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      if (instance.email case final value?) 'email': value,
      if (instance.name case final value?) 'name': value,
      if (instance.avatarUrl case final value?) 'avatarUrl': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.accessToken case final value?) 'accessToken': value,
    };
