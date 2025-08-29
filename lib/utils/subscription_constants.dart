/// 订阅相关常量定义
class SubscriptionConstants {
  /// 订阅类型常量
  static const String typeEntertainment = '娱乐';
  static const String typeWork = '工作';
  static const String typeLife = '生活';
  static const String typeLearning = '学习';
  static const String typeOther = '其他';

  /// 所有订阅类型列表
  static const List<String> subscriptionTypes = [
    typeEntertainment,
    typeWork,
    typeLife,
    typeLearning,
    typeOther,
  ];

  /// 计费周期常量
  static const String billingCycleMonthly = '每月';
  static const String billingCycleYearly = '每年';
  static const String billingCycleOneTime = '一次性';

  /// 所有计费周期列表
  static const List<String> billingCycles = [
    billingCycleMonthly,
    billingCycleYearly,
    billingCycleOneTime,
  ];
}