// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$networkEventsHash() => r'24f8bf3fb8e33466f0ce23c577e8a7ce4ee352fe';

/// 网络连接监听器 Provider
///
/// Copied from [networkEvents].
@ProviderFor(networkEvents)
final networkEventsProvider =
    AutoDisposeStreamProvider<NetworkConnectivityEvent>.internal(
  networkEvents,
  name: r'networkEventsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$networkEventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NetworkEventsRef
    = AutoDisposeStreamProviderRef<NetworkConnectivityEvent>;
String _$connectivityServiceHash() =>
    r'e66d2c12b4b8089152cea6ff940ae8ca2998d3d3';

/// 网络连接服务
///
/// 监控网络连接状态并提供连接状态信息
///
/// Copied from [ConnectivityService].
@ProviderFor(ConnectivityService)
final connectivityServiceProvider =
    AutoDisposeNotifierProvider<ConnectivityService, NetworkStatus>.internal(
  ConnectivityService.new,
  name: r'connectivityServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectivityServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectivityService = AutoDisposeNotifier<NetworkStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
