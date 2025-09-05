import 'package:drift/drift.dart';
import 'package:subscription_manager/database/app_database.dart';
import 'package:subscription_manager/features/subscription_feature/data/models/subscription_dto.dart';

abstract class SubscriptionLocalDatasource {
  Future<List<SubscriptionDto>> getAllSubscriptions();
  Future<SubscriptionDto?> getSubscriptionById(String id);
  Future<String> addSubscription(SubscriptionDto subscription);
  Future<void> updateSubscription(SubscriptionDto subscription);
  Future<void> deleteSubscription(String id);
}

class SubscriptionLocalDatasourceImpl implements SubscriptionLocalDatasource {
  final AppDatabase database;

  SubscriptionLocalDatasourceImpl(this.database);

  @override
  Future<List<SubscriptionDto>> getAllSubscriptions() async {
    final subscriptions = await database.select(database.subscriptions).get();
    return subscriptions
        .map((s) => SubscriptionDto(
              id: s.id,
              name: s.name,
              price: s.price,
              currency: s.currency,
              billingCycle: s.billingCycle,
              nextRenewalDate: s.nextPaymentDate,
              icon: s.icon ?? '',
              color: 0, // 기본颜色값
              notes: s.notes,
              isActive: s.autoRenewal,
              createdAt: s.createdAt,
              updatedAt: s.updatedAt,
            ))
        .toList();
  }

  @override
  Future<SubscriptionDto?> getSubscriptionById(String id) async {
    final subscription = await (database.select(database.subscriptions)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (subscription == null) return null;

    return SubscriptionDto(
      id: subscription.id,
      name: subscription.name,
      price: subscription.price,
      currency: subscription.currency,
      billingCycle: subscription.billingCycle,
      nextRenewalDate: subscription.nextPaymentDate,
      icon: subscription.icon ?? '',
      color: 0, // 기본颜色값
      notes: subscription.notes,
      isActive: subscription.autoRenewal,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    );
  }

  @override
  Future<String> addSubscription(SubscriptionDto subscription) async {
    await database.into(database.subscriptions).insertReturning(
        SubscriptionsCompanion.insert(
      id: subscription.id,
      name: subscription.name,
      price: subscription.price,
      currency: Value(subscription.currency),
      billingCycle: subscription.billingCycle,
      nextPaymentDate: subscription.nextRenewalDate,
      icon: Value(subscription.icon),
      type: '', // 修复 타입 문제
      autoRenewal: Value(subscription.isActive),
      notes: Value(subscription.notes),
      createdAt: Value(subscription.createdAt),
      updatedAt: Value(subscription.updatedAt),
    ));
    return subscription.id;
  }

  @override
  Future<void> updateSubscription(SubscriptionDto subscription) async {
    await database.update(database.subscriptions).replace(SubscriptionsCompanion(
      id: Value(subscription.id),
      name: Value(subscription.name),
      price: Value(subscription.price),
      currency: Value(subscription.currency),
      billingCycle: Value(subscription.billingCycle),
      nextPaymentDate: Value(subscription.nextRenewalDate),
      icon: Value(subscription.icon),
      type: Value(''), // 修复 타입 문제
      autoRenewal: Value(subscription.isActive),
      notes: Value(subscription.notes),
      createdAt: Value(subscription.createdAt),
      updatedAt: Value(subscription.updatedAt),
    ));
  }

  @override
  Future<void> deleteSubscription(String id) async {
    await (database.delete(database.subscriptions)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}