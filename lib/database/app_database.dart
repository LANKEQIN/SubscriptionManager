import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'tables.dart';

part 'app_database.g.dart';

/// SubscriptionManager应用程序的数据库类
/// 使用Drift实现现代化的SQL数据库管理
@DriftDatabase(tables: [Subscriptions, MonthlyHistories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // 未来的数据库升级逻辑将在这里实现
    },
  );

  /// 获取所有订阅
  Future<List<SubscriptionEntity>> getAllSubscriptions() {
    return select(subscriptions).get();
  }

  /// 根据ID获取订阅
  Future<SubscriptionEntity?> getSubscriptionById(String id) {
    return (select(subscriptions)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// 添加订阅
  Future<void> insertSubscription(SubscriptionsCompanion subscription) {
    return into(subscriptions).insert(subscription);
  }

  /// 更新订阅
  Future<void> updateSubscriptionById(String id, SubscriptionsCompanion subscription) {
    return (update(subscriptions)..where((tbl) => tbl.id.equals(id))).write(subscription);
  }

  /// 删除订阅
  Future<void> deleteSubscriptionById(String id) {
    return (delete(subscriptions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 搜索订阅
  Future<List<SubscriptionEntity>> searchSubscriptions(String query) {
    return (select(subscriptions)
      ..where((tbl) => tbl.name.like('%$query%') | tbl.type.like('%$query%'))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)])
    ).get();
  }

  /// 获取即将到期的订阅
  Future<List<SubscriptionEntity>> getUpcomingSubscriptions(DateTime fromDate, DateTime toDate) {
    return (select(subscriptions)
      ..where((tbl) => tbl.nextPaymentDate.isBetweenValues(fromDate, toDate))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.nextPaymentDate)])
    ).get();
  }

  /// 获取所有月度历史记录
  Future<List<MonthlyHistoryEntity>> getAllMonthlyHistories() {
    return (select(monthlyHistories)
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.year, mode: OrderingMode.desc),
                 (tbl) => OrderingTerm(expression: tbl.month, mode: OrderingMode.desc)])
    ).get();
  }

  /// 根据年月获取历史记录
  Future<MonthlyHistoryEntity?> getMonthlyHistoryByYearMonth(int year, int month) {
    return (select(monthlyHistories)
      ..where((tbl) => tbl.year.equals(year) & tbl.month.equals(month))
    ).getSingleOrNull();
  }

  /// 插入或更新月度历史记录
  Future<void> insertOrUpdateMonthlyHistory(MonthlyHistoriesCompanion history) {
    return into(monthlyHistories).insertOnConflictUpdate(history);
  }

  /// 删除月度历史记录
  Future<void> deleteMonthlyHistoryById(String id) {
    return (delete(monthlyHistories)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// 获取年度统计数据
  Future<List<MonthlyHistoryEntity>> getYearlyStatistics(int year) {
    return (select(monthlyHistories)
      ..where((tbl) => tbl.year.equals(year))
      ..orderBy([(tbl) => OrderingTerm(expression: tbl.month)])
    ).get();
  }
}

/// 创建数据库连接
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'subscription_manager.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}