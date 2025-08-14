import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_manager/models/subscription.dart';
import 'package:subscription_manager/utils/subscription_constants.dart';

void main() {
  group('Subscription Model', () {
    test('Subscription can be created with required parameters', () {
      final subscription = Subscription(
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      expect(subscription.name, 'Netflix');
      expect(subscription.type, 'Entertainment');
      expect(subscription.price, 15.99);
      expect(subscription.billingCycle, SubscriptionConstants.BILLING_CYCLE_MONTHLY);
      expect(subscription.autoRenewal, true);
      expect(subscription.id, isNotNull);
    });

    test('Subscription can be created with optional parameters', () {
      final subscription = Subscription(
        id: 'test-id',
        name: 'Netflix',
        icon: 'netflix_icon',
        type: 'Entertainment',
        price: 15.99,
        currency: 'USD',
        billingCycle: SubscriptionConstants.BILLING_CYCLE_YEARLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
        notes: 'Premium plan',
      );

      expect(subscription.id, 'test-id');
      expect(subscription.icon, 'netflix_icon');
      expect(subscription.currency, 'USD');
      expect(subscription.notes, 'Premium plan');
    });

    test('Subscription copyWith creates a new instance with updated values', () {
      final original = Subscription(
        id: 'test-id',
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
      );

      final updated = original.copyWith(name: 'Amazon Prime');

      expect(updated.id, original.id);
      expect(updated.name, 'Amazon Prime');
      expect(updated.type, original.type);
      expect(updated.price, original.price);
    });

    test('Subscription toMap and fromMap work correctly', () {
      final original = Subscription(
        id: 'test-id',
        name: 'Netflix',
        icon: 'netflix_icon',
        type: 'Entertainment',
        price: 15.99,
        currency: 'USD',
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime(2023, 12, 31),
        autoRenewal: true,
        notes: 'Premium plan',
      );

      final map = original.toMap();
      final fromMap = Subscription.fromMap(map);

      expect(fromMap.id, original.id);
      expect(fromMap.name, original.name);
      expect(fromMap.icon, original.icon);
      expect(fromMap.type, original.type);
      expect(fromMap.price, original.price);
      expect(fromMap.currency, original.currency);
      expect(fromMap.billingCycle, original.billingCycle);
      expect(fromMap.nextPaymentDate, original.nextPaymentDate);
      expect(fromMap.autoRenewal, original.autoRenewal);
      expect(fromMap.notes, original.notes);
    });

    test('daysUntilPayment calculates correctly', () {
      final now = DateTime.now();
      final subscription = Subscription(
        name: 'Test',
        type: 'Test',
        price: 10.0,
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: now.add(Duration(days: 5)),
        autoRenewal: true,
      );

      expect(subscription.daysUntilPayment, 5);
    });

    test('formattedPrice formats correctly for different billing cycles', () {
      final monthlySubscription = Subscription(
        name: 'Test',
        type: 'Test',
        price: 10.0,
        currency: 'USD',
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime.now(),
        autoRenewal: true,
      );

      final yearlySubscription = Subscription(
        name: 'Test',
        type: 'Test',
        price: 100.0,
        currency: 'USD',
        billingCycle: SubscriptionConstants.BILLING_CYCLE_YEARLY,
        nextPaymentDate: DateTime.now(),
        autoRenewal: true,
      );

      expect(monthlySubscription.formattedPrice, '\$10.00/月');
      expect(yearlySubscription.formattedPrice, '\$100.00/年');
    });
  });
});