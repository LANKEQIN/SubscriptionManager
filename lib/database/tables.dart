import 'package:drift/drift.dart';

/// 订阅表定义
/// 存储用户的所有订阅服务信息
@DataClassName('SubscriptionEntity')
class Subscriptions extends Table {
  /// 订阅唯一标识符
  TextColumn get id => text()();
  
  /// 订阅服务名称
  TextColumn get name => text()();
  
  /// 订阅图标（可选）
  TextColumn get icon => text().nullable()();
  
  /// 订阅类型/分类
  TextColumn get type => text()();
  
  /// 订阅价格
  RealColumn get price => real()();
  
  /// 货币类型，默认为CNY
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  
  /// 计费周期：monthly, yearly, one-time
  TextColumn get billingCycle => text()();
  
  /// 下次付款日期
  DateTimeColumn get nextPaymentDate => dateTime()();
  
  /// 是否自动续费
  BoolColumn get autoRenewal => boolean().withDefault(const Constant(false))();
  
  /// 备注信息（可选）
  TextColumn get notes => text().nullable()();
  
  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  
  /// 更新时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [];
}

/// 月度历史记录表
/// 存储每月的订阅统计信息
@DataClassName('MonthlyHistoryEntity')
class MonthlyHistories extends Table {
  /// 历史记录唯一标识符
  TextColumn get id => text()();
  
  /// 年份
  IntColumn get year => integer()();
  
  /// 月份 (1-12)
  IntColumn get month => integer()();
  
  /// 当月总金额
  RealColumn get totalAmount => real()();
  
  /// 货币类型
  TextColumn get currency => text()();
  
  /// 当月订阅数量
  IntColumn get subscriptionCount => integer()();
  
  /// 创建时间
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {year, month} // 年月组合唯一
  ];
}