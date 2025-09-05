import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';

class UpdateSubscriptionUseCase {
  final SubscriptionRepository repository;

  UpdateSubscriptionUseCase({required this.repository});

  Future<void> call(Subscription subscription) async {
    return await repository.updateSubscription(subscription);
  }
}