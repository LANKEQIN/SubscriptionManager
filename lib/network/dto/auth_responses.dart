import 'package:json_annotation/json_annotation.dart';

part 'auth_responses.g.dart';

/// 认证响应基类
abstract class AuthResponse {
  const AuthResponse();
}

/// 注册响应
@JsonSerializable()
class SignUpResponse extends AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
  final User? user;
  
  const SignUpResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.user,
  });
  
  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}

/// 登录响应
@JsonSerializable()
class SignInResponse extends AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
  final User? user;
  
  const SignInResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
    this.user,
  });
  
  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}

/// 刷新令牌响应
@JsonSerializable()
class RefreshTokenResponse extends AuthResponse {
  final String? accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
  
  const RefreshTokenResponse({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
  });
  
  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$RefreshTokenResponseToJson(this);
}

/// 用户信息响应
@JsonSerializable()
class UserResponse extends AuthResponse {
  final User user;
  
  const UserResponse({
    required this.user,
  });
  
  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
      
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

/// 用户模型
@JsonSerializable()
class User {
  final String id;
  final String? email;
  final String? name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  /// 访问令牌 - 用于兼容现有代码
  final String? accessToken;
  
  const User({
    required this.id,
    this.email,
    this.name,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
  });
  
  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
      
  Map<String, dynamic> toJson() => _$UserToJson(this);
}