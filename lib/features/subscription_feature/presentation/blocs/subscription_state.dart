import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState.initial() = _Initial;
  const factory SubscriptionState.loading() = Loading;
  const factory SubscriptionState.loaded(List<Subscription> subscriptions) = Loaded;
  const factory SubscriptionState.error(String message) = Error;
}