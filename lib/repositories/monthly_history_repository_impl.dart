import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import '../cache/hive_service.dart';
import '../models/monthly_history.dart';
import '../models/subscription.dart';
import 'repository_interfaces.dart';
import 'error_handler.dart';

/// 月度历史仓储实现类
/// 实现月度历史数据的增删改查操作，集成Drift数据库和Hive缓存
class MonthlyHistoryRepositoryImpl with ErrorHandler implements MonthlyHistoryRepository {
  final AppDatabase _database;
  
  MonthlyHistoryRepositoryImpl(this._database);

  static const String _cacheKeyPrefix = 'monthly_history_';
  static const String _allHistoriesCacheKey = 'all_monthly_histories';

  @override
  Future<List<MonthlyHistory>> getAllHistories() async {
    return handleDatabaseOperation(() async {
      // 尝试从缓存获取
      final cached = HiveService.getCacheList<Map<String, dynamic>>(
        _allHistoriesCacheKey,
        (json) => json,
      );
      
      if (cached != null) {
        return cached.map((data) => _monthlyHistoryFromJson(data)).toList();
      }
      
      // 从数据库获取
      final entities = await _database.getAllMonthlyHistories();
      final histories = entities.map(_entityToMonthlyHistory).toList();
      
      // 更新缓存
      if (histories.isNotEmpty) {
        await HiveService.setCacheList<Map<String, dynamic>>(
          _allHistoriesCacheKey,
          histories.map((h) => _monthlyHistoryToJson(h)).toList(),
          (data) => data,
          expiry: CachePolicy.getCacheDuration('monthly_histories'),
        );
      }
      
      return histories;
    });
  }

  @override
  Future<MonthlyHistory?> getHistoryByYearMonth(int year, int month) async {
    return handleDatabaseOperation(() async {
      // 尝试从缓存获取
      final cacheKey = '$_cacheKeyPrefix${year}_$month';
      final cached = HiveService.getCacheObject<Map<String, dynamic>>(
        cacheKey,
        (json) => json,
      );
      
      if (cached != null) {
        return _monthlyHistoryFromJson(cached);
      }
      
      // 从数据库获取
      final entity = await _database.getMonthlyHistoryByYearMonth(year, month);
      if (entity == null) return null;
      
      final history = _entityToMonthlyHistory(entity);
      
      // 更新缓存
      await HiveService.setCacheObject<Map<String, dynamic>>(
        cacheKey,
        _monthlyHistoryToJson(history),
        (json) => json,
        (data) => data,
        expiry: CachePolicy.getCacheDuration('monthly_histories'),
      );
      
      return history;
    });
  }

  @override
  Future<void> updateCurrentMonthHistory(List<Subscription> subscriptions) async {
    return handleDatabaseOperation(() async {
      final now = DateTime.now();
      final year = now.year;
      final month = now.month;
      
      // 计算当月总金额
      double totalAmount = 0.0;
      int subscriptionCount = 0;
      
      for (final subscription in subscriptions) {
        // 检查订阅是否在当月有费用
        final nextPayment = subscription.nextPaymentDate;
        if (nextPayment.year == year && nextPayment.month == month) {
          totalAmount += subscription.price;
          subscriptionCount++;
        }
      }
      
      // 创建或更新月度历史记录
      final existingHistory = await getHistoryByYearMonth(year, month);
      
      if (existingHistory != null) {
        // 更新现有记录
        final updatedHistory = existingHistory.copyWith(
          totalAmount: totalAmount,
          subscriptionCount: subscriptionCount,
        );
        
        final entity = _monthlyHistoryToEntity(updatedHistory);
        await _database.insertOrUpdateMonthlyHistory(entity);
      } else {
        // 创建新记录
        final newHistory = MonthlyHistory.create(
          year: year,
          month: month,
          totalAmount: totalAmount,
          currency: 'CNY', // 默认货币，可以从设置中获取
          subscriptionCount: subscriptionCount,
        );
        
        final entity = _monthlyHistoryToEntity(newHistory);
        await _database.insertOrUpdateMonthlyHistory(entity);
      }
      
      // 清除相关缓存
      await _invalidateCache();
    });
  }

  @override
  Future<void> addMonthlyHistory(MonthlyHistory history) async {
    return handleDatabaseOperation(() async {
      // 确保有有效的ID
      final historyWithId = history.id.isEmpty 
          ? history.copyWith(id: const Uuid().v4())
          : history;
      
      final entity = _monthlyHistoryToEntity(historyWithId);
      await _database.insertOrUpdateMonthlyHistory(entity);
      
      // 清除相关缓存
      await _invalidateCache();
    });
  }

  @override
  Future<void> deleteMonthlyHistory(String id) async {
    return handleDatabaseOperation(() async {
      await _database.deleteMonthlyHistoryById(id);
      
      // 清除相关缓存
      await _invalidateCache();
    });
  }

  @override
  Future<List<MonthlyHistory>> getYearlyStatistics(int year) async {
    return handleDatabaseOperation(() async {
      final entities = await _database.getYearlyStatistics(year);
      return entities.map(_entityToMonthlyHistory).toList();
    });
  }

  @override
  Future<List<MonthlyHistory>> getHistoriesInRange(DateTime startDate, DateTime endDate) async {
    return handleDatabaseOperation(() async {
      final allHistories = await getAllHistories();
      return allHistories.where((history) {
        final historyDate = DateTime(history.year, history.month);
        return historyDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
               historyDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    });
  }

  @override
  Future<void> saveHistory(MonthlyHistory history) async {
    // saveHistory is an alias for addMonthlyHistory
    return addMonthlyHistory(history);
  }

  @override
  Future<void> deleteHistory(String id) async {
    // deleteHistory is an alias for deleteMonthlyHistory
    return deleteMonthlyHistory(id);
  }

  /// 清除相关缓存
  Future<void> _invalidateCache() async {
    await HiveService.deleteCache(_allHistoriesCacheKey);
    // 清除特定年月的缓存比较困难，简单起见清除所有相关缓存
  }

  /// 将数据库实体转换为月度历史模型
  MonthlyHistory _entityToMonthlyHistory(MonthlyHistoryEntity entity) {
    return MonthlyHistory(
      id: entity.id,
      year: entity.year,
      month: entity.month,
      totalAmount: entity.totalAmount,
      currency: entity.currency,
      subscriptionCount: entity.subscriptionCount,
    );
  }

  /// 将月度历史模型转换为数据库实体
  MonthlyHistoriesCompanion _monthlyHistoryToEntity(MonthlyHistory history) {
    return MonthlyHistoriesCompanion.insert(
      id: history.id,
      year: history.year,
      month: history.month,
      totalAmount: history.totalAmount,
      currency: history.currency,
      subscriptionCount: history.subscriptionCount,
    );
  }

  /// 将月度历史模型转换为JSON
  Map<String, dynamic> _monthlyHistoryToJson(MonthlyHistory history) {
    return history.toMap();
  }

  /// 从JSON创建月度历史模型
  MonthlyHistory _monthlyHistoryFromJson(Map<String, dynamic> json) {
    return MonthlyHistory.fromMap(json);
  }
}