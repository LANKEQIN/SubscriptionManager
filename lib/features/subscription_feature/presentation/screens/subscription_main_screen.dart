import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscription_manager/features/subscription_feature/presentation/blocs/subscription_bloc.dart';
import 'package:subscription_manager/features/subscription_feature/presentation/blocs/subscription_event.dart';
import 'package:subscription_manager/features/subscription_feature/presentation/blocs/subscription_state.dart';

class SubscriptionMainScreen extends StatelessWidget {
  const SubscriptionMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionBloc(
        repository: context.read(), // 使用 repository 参数而不是 getAllSubscriptionsUseCase
      )..add(const LoadSubscriptions()),
      child: const SubscriptionMainView(),
    );
  }
}

class SubscriptionMainView extends StatelessWidget {
  const SubscriptionMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('订阅'),
        actions: [
        ],
      ),
      body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (subscriptions) {
              if (subscriptions.isEmpty) {
                return const Center(
                  child: Text('暂无订阅'),
                );
              }
              return ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final subscription = subscriptions[index];
                  return ListTile(
                    leading: const Icon(Icons.subscriptions),
                    title: Text(subscription.name),
                    subtitle: Text('${subscription.price} ${subscription.currency}'),
                    trailing: Text(
                      subscription.nextRenewalDate.toString().split(' ')[0],
                    ),
                  );
                },
              );
            },
            error: (message) => Center(
              child: Text('加载失败: $message'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加订阅的逻辑
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}