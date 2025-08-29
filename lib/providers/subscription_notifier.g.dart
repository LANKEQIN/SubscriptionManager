// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$subscriptionNotifierHash() =>
    r'1e726682dfa8d8910693a36f4a8727b13fb1d45a';

/// 升级后的订阅状态管理器
/// 使用Repository模式和现代Riverpod架构
///
/// Copied from [SubscriptionNotifier].
@ProviderFor(SubscriptionNotifier)
final subscriptionNotifierProvider = AutoDisposeAsyncNotifierProvider<
    SubscriptionNotifier, SubscriptionState>.internal(
  SubscriptionNotifier.new,
  name: r'subscriptionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SubscriptionNotifier = AutoDisposeAsyncNotifier<SubscriptionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
