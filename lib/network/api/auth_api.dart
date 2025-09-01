import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../dto/auth_responses.dart';

part 'auth_api.g.dart';

/// 认证服务 API 接口
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;
  
  /// 用户注册
  @POST('/auth/v1/signup')
  Future<SignUpResponse> signUp(
    @Body() Map<String, String> credentials,
  );
  
  /// 用户登录
  @POST('/auth/v1/token')
  Future<SignInResponse> signIn(
    @Body() Map<String, String> credentials,
    @Header('grant_type') String grantType,
  );
  
  /// 刷新令牌
  @POST('/auth/v1/token')
  Future<RefreshTokenResponse> refreshToken(
    @Body() Map<String, String> refreshData,
    @Header('grant_type') String grantType,
  );
  
  /// 用户登出
  @POST('/auth/v1/logout')
  Future<void> signOut();
  
  /// 重置密码
  @POST('/auth/v1/recover')
  Future<void> resetPassword(
    @Body() Map<String, String> resetData,
  );
  
  /// 获取用户信息
  @GET('/auth/v1/user')
  Future<UserResponse> getUser();
  
  /// 更新用户信息
  @PUT('/auth/v1/user')
  Future<UserResponse> updateUser(
    @Body() Map<String, dynamic> userData,
  );
}