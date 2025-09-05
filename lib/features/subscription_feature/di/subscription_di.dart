import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:subscription_manager/features/subscription_feature/data/datasources/subscription_local_datasource.dart';
import 'package:subscription_manager/features/subscription_feature/data/repositories/subscription_repository_impl.dart';
import 'package:subscription_manager/features/subscription_feature/domain/repositories/subscription_repository.dart';
import 'package:subscription_manager/features/subscription_feature/domain/usecases/get_all_subscriptions_usecase.dart';
import 'package:subscription_manager/features/subscription_feature/presentation/blocs/subscription_bloc.dart';
import 'package:subscription_manager/providers/app_providers.dart';

final subscriptionLocalDatasourceProvider = Provider<SubscriptionLocalDatasource>((ref) {
  final database = ref.read(appDatabaseProvider);
  return SubscriptionLocalDatasourceImpl(database);
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final localDatasource = ref.read(subscriptionLocalDatasourceProvider);
  return SubscriptionRepositoryImpl(localDatasource: localDatasource);
});

final getAllSubscriptionsUseCaseProvider = Provider<GetAllSubscriptionsUseCase>((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return GetAllSubscriptionsUseCase(repository: repository);
});

final subscriptionBlocProvider = Provider<SubscriptionBloc>((ref) {
  final repository = ref.read(subscriptionRepositoryProvider);
  return SubscriptionBloc(repository: repository);
});