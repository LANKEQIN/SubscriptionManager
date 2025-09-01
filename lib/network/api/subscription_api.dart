import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../dto/subscription_dto.dart';
import '../dto/subscription_requests.dart';

part 'subscription_api.g.dart';

/// 订阅服务 API 接口
/// 使用 Retrofit 生成类型安全的 HTTP 客户端
@RestApi()
abstract class SubscriptionApi {
  factory SubscriptionApi(Dio dio, {String? baseUrl}) = _SubscriptionApi;
  
  /// 获取用户的所有订阅
  @GET('/rest/v1/subscriptions')
  Future<List<SubscriptionDto>> getSubscriptions(
    @Query('select') String select,
    @Query('user_id') String userId,
    @Query('is_active') String isActive,
    @Query('order') String order,
  );
  
  /// 根据 ID 获取单个订阅
  @GET('/rest/v1/subscriptions')
  Future<List<SubscriptionDto>> getSubscription(
    @Query('select') String select,
    @Query('id') String id,
  );
  
  /// 创建新订阅
  @POST('/rest/v1/subscriptions')
  Future<List<SubscriptionDto>> createSubscription(
    @Body() CreateSubscriptionRequest request,
    @Header('Prefer') String prefer,
  );
  
  /// 更新订阅
  @PATCH('/rest/v1/subscriptions')
  Future<List<SubscriptionDto>> updateSubscription(
    @Query('id') String id,
    @Body() UpdateSubscriptionRequest request,
    @Header('Prefer') String prefer,
  );
  
  /// 删除订阅
  @DELETE('/rest/v1/subscriptions')
  Future<void> deleteSubscription(
    @Query('id') String id,
  );
  
  /// 搜索订阅
  @GET('/rest/v1/subscriptions')
  Future<List<SubscriptionDto>> searchSubscriptions(
    @Query('select') String select,
    @Query('user_id') String userId,
    @Query('name') String nameFilter,
    @Query('is_active') String isActive,
    @Query('order') String order,
    @Query('limit') int? limit,
    @Query('offset') int? offset,
  );
  
  /// 获取即将到期的订阅
  @GET('/rest/v1/subscriptions')
  Future<List<SubscriptionDto>> getUpcomingSubscriptions(
    @Query('select') String select,
    @Query('user_id') String userId,
    @Query('next_renewal_date') String dateFilter,
    @Query('is_active') String isActive,
    @Query('order') String order,
  );
  
  /// 批量操作订阅
  @PATCH('/rest/v1/subscriptions')
  Future<void> batchUpdateSubscriptions(
    @Query('id') String idFilter,
    @Body() Map<String, dynamic> updates,
  );
  
  /// 获取订阅统计
  @GET('/rest/v1/rpc/get_subscription_stats')
  Future<String> getSubscriptionStats(
    @Query('user_id_param') String userId,
  );
  
  /// 按货币分组统计
  @GET('/rest/v1/rpc/get_subscription_stats_by_currency')
  Future<String> getSubscriptionStatsByCurrency(
    @Query('user_id_param') String userId,
  );
  
  /// 获取月度趋势数据
  @GET('/rest/v1/rpc/get_monthly_subscription_trend')
  Future<String> getMonthlySubscriptionTrend(
    @Query('user_id_param') String userId,
    @Query('months_param') int months,
  );
}