// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncServiceHash() => r'09396bb5b8f9cfda871eb561289e222ada2fea61';

/// 数据同步服务
///
/// 管理本地和远程数据的同步，处理冲突解决和实时更新
///
/// Copied from [SyncService].
@ProviderFor(SyncService)
final syncServiceProvider =
    AutoDisposeNotifierProvider<SyncService, SyncState>.internal(
  SyncService.new,
  name: r'syncServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$syncServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncService = AutoDisposeNotifier<SyncState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
