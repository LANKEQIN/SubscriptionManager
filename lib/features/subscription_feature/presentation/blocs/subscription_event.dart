import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';

part 'subscription_event.freezed.dart';

@freezed
class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.loadSubscriptions() = LoadSubscriptions;
  const factory SubscriptionEvent.addSubscription(Subscription subscription) = AddSubscription;
  const factory SubscriptionEvent.updateSubscription(Subscription subscription) = UpdateSubscription;
  const factory SubscriptionEvent.deleteSubscription(String id) = DeleteSubscription;
}