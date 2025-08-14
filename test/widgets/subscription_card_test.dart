import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:subscription_manager/models/subscription.dart';
import 'package:subscription_manager/providers/subscription_provider.dart';
import 'package:subscription_manager/widgets/subscription_card.dart';
import 'package:subscription_manager/utils/subscription_constants.dart';

void main() {
  group('SubscriptionCard', () {
    late SubscriptionProvider provider;

    setUp(() {
      provider = SubscriptionProvider();
    });

    testWidgets('SubscriptionCard displays subscription information',
        (WidgetTester tester) async {
      final subscription = Subscription(
        id: 'test-id',
        name: 'Netflix',
        type: 'Entertainment',
        price: 15.99,
        currency: 'USD',
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime.now().add(Duration(days: 10)),
        autoRenewal: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: Scaffold(
              body: SubscriptionCard(subscription: subscription),
            ),
          ),
        ),
      );

      expect(find.text('Netflix'), findsOneWidget);
      expect(find.text('\$15.99/月'), findsOneWidget);
      expect(find.text('10天后'), findsOneWidget);
    });

    testWidgets('SubscriptionCard shows expired status for past dates',
        (WidgetTester tester) async {
      final subscription = Subscription(
        id: 'test-id',
        name: 'Expired Service',
        type: 'Entertainment',
        price: 15.99,
        currency: 'USD',
        billingCycle: SubscriptionConstants.BILLING_CYCLE_MONTHLY,
        nextPaymentDate: DateTime.now().subtract(Duration(days: 5)),
        autoRenewal: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider.value(
            value: provider,
            child: Scaffold(
              body: SubscriptionCard(subscription: subscription),
            ),
          ),
        ),
      );

      expect(find.text('已过期'), findsOneWidget);
    });
  });
});