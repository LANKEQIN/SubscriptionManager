import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';

class DeleteSubscriptionUseCase {
  final SubscriptionRepository repository;

  DeleteSubscriptionUseCase({required this.repository});

  Future<void> call(String id) async {
    return await repository.deleteSubscription(id);
  }
}