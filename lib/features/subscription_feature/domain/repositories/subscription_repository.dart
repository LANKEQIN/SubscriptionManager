import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getAllSubscriptions();
  Future<Subscription?> getSubscriptionById(String id);
  Future<String> addSubscription(Subscription subscription);
  Future<void> updateSubscription(Subscription subscription);
  Future<void> deleteSubscription(String id);
}