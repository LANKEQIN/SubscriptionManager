import 'package:subscription_manager/features/subscription_feature/data/datasources/subscription_local_datasource.dart';
import 'package:subscription_manager/features/subscription_feature/data/models/subscription_dto.dart';
import 'package:subscription_manager/features/subscription_feature/domain/entities/subscription.dart';
import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionLocalDatasource localDatasource;

  SubscriptionRepositoryImpl({required this.localDatasource});

  @override
  Future<List<Subscription>> getAllSubscriptions() async {
    final subscriptionDtos = await localDatasource.getAllSubscriptions();
    return subscriptionDtos
        .map((dto) => Subscription(
              id: dto.id,
              name: dto.name,
              price: dto.price,
              currency: dto.currency,
              billingCycle: dto.billingCycle,
              nextRenewalDate: dto.nextRenewalDate,
              icon: dto.icon,
              color: dto.color,
              notes: dto.notes,
              isActive: dto.isActive,
              createdAt: dto.createdAt,
              updatedAt: dto.updatedAt,
            ))
        .toList();
  }

  @override
  Future<Subscription?> getSubscriptionById(String id) async {
    final subscriptionDto = await localDatasource.getSubscriptionById(id);
    if (subscriptionDto == null) return null;

    return Subscription(
      id: subscriptionDto.id,
      name: subscriptionDto.name,
      price: subscriptionDto.price,
      currency: subscriptionDto.currency,
      billingCycle: subscriptionDto.billingCycle,
      nextRenewalDate: subscriptionDto.nextRenewalDate,
      icon: subscriptionDto.icon,
      color: subscriptionDto.color,
      notes: subscriptionDto.notes,
      isActive: subscriptionDto.isActive,
      createdAt: subscriptionDto.createdAt,
      updatedAt: subscriptionDto.updatedAt,
    );
  }

  @override
  Future<String> addSubscription(Subscription subscription) async {
    final subscriptionDto = SubscriptionDto(
      id: subscription.id,
      name: subscription.name,
      price: subscription.price,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextRenewalDate: subscription.nextRenewalDate,
      icon: subscription.icon,
      color: subscription.color,
      notes: subscription.notes,
      isActive: subscription.isActive,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    );

    return await localDatasource.addSubscription(subscriptionDto);
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    final subscriptionDto = SubscriptionDto(
      id: subscription.id,
      name: subscription.name,
      price: subscription.price,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextRenewalDate: subscription.nextRenewalDate,
      icon: subscription.icon,
      color: subscription.color,
      notes: subscription.notes,
      isActive: subscription.isActive,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    );

    await localDatasource.updateSubscription(subscriptionDto);
  }

  @override
  Future<void> deleteSubscription(String id) async {
    await localDatasource.deleteSubscription(id);
  }
}