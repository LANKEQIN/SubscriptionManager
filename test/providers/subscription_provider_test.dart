import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_manager/providers/subscription_provider.dart';
import 'package:subscription_manager/models/subscription.dart';
import 'package:subscription_manager/utils/subscription_constants.dart';

void main() {
  group('SubscriptionProvider', () {
    late SubscriptionProvider provider;

    setUp(() {
      provider = SubscriptionProvider();
    });

    test('Provider initializes with empty lists', () {
      expect(provider.subscriptions, isEmpty);
      expect(provider.monthlyHistories, isEmpty);
    });

    test('addSubscription adds a subscription', () {
      final subscription = Subscription(
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      provider.addSubscription(subscription);
      expect(provider.subscriptions, hasLength(1));
      expect(provider.subscriptions.first, subscription);
    });

    test('removeSubscription removes a subscription', () {
      final subscription = Subscription(
        id: 'test-id',
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      provider.addSubscription(subscription);
      expect(provider.subscriptions, hasLength(1));

      provider.removeSubscription('test-id');
      expect(provider.subscriptions, isEmpty);
    });

    test('updateSubscription updates an existing subscription', () {
      final original = Subscription(
        id: 'test-id',
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      provider.addSubscription(original);
      expect(provider.subscriptions.first.name, 'Netflix');

      final updated = original.copyWith(name: 'Amazon Prime');
      provider.updateSubscription(updated);

      expect(provider.subscriptions, hasLength(1));
      expect(provider.subscriptions.first.name, 'Amazon Prime');
    });

    test('getSubscriptionsByType returns filtered subscriptions', () {
      final netflix = Subscription(
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      final gym = Subscription(
        name: 'Gym Membership',
        type: 'Fitness',
        price: 30.00,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      provider.addSubscription(netflix);
      provider.addSubscription(gym);

      final entertainmentSubscriptions = provider.getSubscriptionsByType('Entertainment');
      expect(entertainmentSubscriptions, hasLength(1));
      expect(entertainmentSubscriptions.first.name, 'Netflix');
    });
  });
});