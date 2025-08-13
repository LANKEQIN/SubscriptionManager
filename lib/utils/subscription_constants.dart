/// 订阅相关常量定义
class SubscriptionConstants {
  /// 订阅类型常量
  static const String TYPE_ENTERTAINMENT = '娱乐';
  static const String TYPE_WORK = '工作';
  static const String TYPE_LIFE = '生活';
  static const String TYPE_LEARNING = '学习';
  static const String TYPE_OTHER = '其他';

  /// 所有订阅类型列表
  static const List<String> SUBSCRIPTION_TYPES = [
    TYPE_ENTERTAINMENT,
    TYPE_WORK,
    TYPE_LIFE,
    TYPE_LEARNING,
    TYPE_OTHER,
  ];

  /// 计费周期常量
  static const String BILLING_CYCLE_MONTHLY = '每月';
  static const String BILLING_CYCLE_YEARLY = '每年';
  static const String BILLING_CYCLE_ONE_TIME = '一次性';

  /// 所有计费周期列表
  static const List<String> BILLING_CYCLES = [
    BILLING_CYCLE_MONTHLY,
    BILLING_CYCLE_YEARLY,
    BILLING_CYCLE_ONE_TIME,
  ];
}