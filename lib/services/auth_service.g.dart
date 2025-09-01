// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authServiceHash() => r'e2749a041893319aface7547e70f89a45c466f5f';

/// 认证服务
///
/// 管理用户的注册、登录、登出等认证功能
///
/// Copied from [AuthService].
@ProviderFor(AuthService)
final authServiceProvider =
    AutoDisposeNotifierProvider<AuthService, AsyncValue<User?>>.internal(
  AuthService.new,
  name: r'authServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthService = AutoDisposeNotifier<AsyncValue<User?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
