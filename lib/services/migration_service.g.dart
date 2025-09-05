// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$migrationServiceHash() => r'2dda33ea22f50b709ae20b47056d78fd6806b2dc';

/// 增强数据迁移服务
/// 负责将数据从SharedPreferences迁移到新的同步架构
///
/// Copied from [migrationService].
@ProviderFor(migrationService)
final migrationServiceProvider = AutoDisposeProvider<MigrationService>.internal(
  migrationService,
  name: r'migrationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$migrationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MigrationServiceRef = AutoDisposeProviderRef<MigrationService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
