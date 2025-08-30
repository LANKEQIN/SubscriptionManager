import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subscription_manager/models/subscription.dart';
import 'package:subscription_manager/providers/subscription_notifier.dart';

void main() {
  group('订阅货币转换测试', () {
    late ProviderContainer container;

    setUp(() async {
      // 模拟SharedPreferences
      SharedPreferences.setMockInitialValues({});
      
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('测试多货币订阅的月度费用计算', () async {
      // 创建测试订阅 - CNY月付订阅
      final subscription1 = Subscription(
        id: 'test1',
        name: 'Netflix CN',
        price: 68.0,
        currency: 'CNY',
        billingCycle: '每月',
        nextPaymentDate: DateTime.now().add(const Duration(days: 30)),
        type: '视频',
        icon: 'video',
        autoRenewal: true,
      );

      // 创建测试订阅 - USD年付订阅
      final subscription2 = Subscription(
        id: 'test2',
        name: 'Spotify US',
        price: 120.0,
        currency: 'USD',
        billingCycle: '每年',
        nextPaymentDate: DateTime.now().add(const Duration(days: 365)),
        type: '音乐',
        icon: 'music',
        autoRenewal: true,
      );

      // 等待provider初始化
      await container.read(subscriptionNotifierProvider.future);
      
      // 添加订阅
      await container.read(subscriptionNotifierProvider.notifier).addSubscription(subscription1);
      await container.read(subscriptionNotifierProvider.notifier).addSubscription(subscription2);

      // 获取月度费用（应该转换为基准货币CNY）
      final monthlyCost = await container.read(subscriptionNotifierProvider.notifier).getMonthlyCost();

      // 验证计算结果
      // subscription1: 68 CNY (已经是CNY，无需转换)
      // subscription2: 120 USD / 12 = 10 USD/月，转换为CNY约为 10 * 7.2 = 72 CNY
      // 总计应该约为: 68 + 72 = 140 CNY
      expect(monthlyCost, closeTo(140.0, 1.0));
    });

    test('测试计费周期字段匹配', () async {
      // 等待provider初始化  
      await container.read(subscriptionNotifierProvider.future);
      
      // 创建测试订阅使用中文计费周期
      final subscription = Subscription(
        id: 'test3',
        name: 'Test Subscription',
        price: 100.0,
        currency: 'CNY',
        billingCycle: '每月',
        nextPaymentDate: DateTime.now().add(const Duration(days: 30)),
        type: '测试',
        icon: 'test',
        autoRenewal: true,
      );

      // 添加订阅
      await container.read(subscriptionNotifierProvider.notifier).addSubscription(subscription);

      // 获取月度费用
      final monthlyCost = await container.read(subscriptionNotifierProvider.notifier).getMonthlyCost();

      // 验证计费周期匹配正确（如果不匹配，费用应该为0）
      expect(monthlyCost, greaterThan(0));
    });

    test('测试年度费用计算', () async {
      // 创建测试订阅
      final subscription = Subscription(
        id: 'test4',
        name: 'Annual Subscription',
        price: 50.0,
        currency: 'CNY',
        billingCycle: '每月',
        nextPaymentDate: DateTime.now().add(const Duration(days: 30)),
        type: '测试',
        icon: 'test',
        autoRenewal: true,
      );

      // 等待provider初始化
      await container.read(subscriptionNotifierProvider.future);
      
      // 添加订阅
      await container.read(subscriptionNotifierProvider.notifier).addSubscription(subscription);

      // 获取年度费用
      final yearlyCost = await container.read(subscriptionNotifierProvider.notifier).getYearlyCost();

      // 验证年度费用计算 (50 * 12 = 600)
      expect(yearlyCost, closeTo(600.0, 1.0));
    });
  });
}