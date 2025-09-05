import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';

class AddSubscriptionUseCase {
  final SubscriptionRepository repository;

  AddSubscriptionUseCase({required this.repository});

  Future<String> call(Subscription subscription) async {
    return await repository.addSubscription(subscription);
  }
}