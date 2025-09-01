import '../models/subscription.dart';
import '../models/monthly_history.dart';

/// 订阅数据仓储接口
/// 定义所有订阅相关的数据操作
abstract class SubscriptionRepository {
  /// 获取所有订阅
  Future<List<Subscription>> getAllSubscriptions();

  /// 根据ID获取订阅
  Future<Subscription?> getSubscriptionById(String id);

  /// 添加订阅
  Future<void> addSubscription(Subscription subscription);

  /// 更新订阅
  Future<void> updateSubscription(Subscription subscription);

  /// 删除订阅
  Future<void> deleteSubscription(String id);

  /// 搜索订阅
  Future<List<Subscription>> searchSubscriptions(String query);

  /// 获取即将到期的订阅
  Future<List<Subscription>> getUpcomingSubscriptions({int daysAhead = 7});

  /// 获取过期的订阅
  Future<List<Subscription>> getExpiredSubscriptions();

  /// 根据类型获取订阅
  Future<List<Subscription>> getSubscriptionsByType(String type);

  /// 获取总月度费用
  Future<double> getTotalMonthlyAmount();
}

/// 月度历史数据仓储接口
/// 定义所有月度历史相关的数据操作
abstract class MonthlyHistoryRepository {
  /// 获取所有月度历史记录
  Future<List<MonthlyHistory>> getAllHistories();

  /// 根据年月获取历史记录
  Future<MonthlyHistory?> getHistoryByYearMonth(int year, int month);

  /// 更新当前月度历史
  Future<void> updateCurrentMonthHistory(List<Subscription> subscriptions);

  /// 添加月度历史记录
  Future<void> addMonthlyHistory(MonthlyHistory history);

  /// 删除月度历史记录
  Future<void> deleteMonthlyHistory(String id);

  /// 获取年度统计数据
  Future<List<MonthlyHistory>> getYearlyStatistics(int year);

  /// 获取指定范围内的历史记录
  Future<List<MonthlyHistory>> getHistoriesInRange(DateTime startDate, DateTime endDate);

  /// 保存历史记录
  Future<void> saveHistory(MonthlyHistory history);

  /// 删除历史记录
  Future<void> deleteHistory(String id);
}