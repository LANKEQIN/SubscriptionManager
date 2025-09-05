import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';

class GetAllSubscriptionsUseCase {
  final SubscriptionRepository repository;

  GetAllSubscriptionsUseCase({required this.repository});

  Future<List<Subscription>> call() async {
    return await repository.getAllSubscriptions();
  }
}