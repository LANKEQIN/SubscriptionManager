// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'8c69eb46d45206533c176c88a926608e79ca927d';

/// 数据库Provider
/// 提供AppDatabase单例
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$cacheBoxHash() => r'cb443ab92359d4d8aacd0f2dd1d658a55a41052a';

/// 缓存Box Provider
/// 提供Hive缓存Box
///
/// Copied from [cacheBox].
@ProviderFor(cacheBox)
final cacheBoxProvider = FutureProvider<Box<CachedData>>.internal(
  cacheBox,
  name: r'cacheBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cacheBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheBoxRef = FutureProviderRef<Box<CachedData>>;
String _$userPrefsBoxHash() => r'0e0f1931233f27f7352bb4940781e79f322d7695';

/// 用户偏好Box Provider
/// 提供用户偏好设置Box
///
/// Copied from [userPrefsBox].
@ProviderFor(userPrefsBox)
final userPrefsBoxProvider = FutureProvider<Box<String>>.internal(
  userPrefsBox,
  name: r'userPrefsBoxProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userPrefsBoxHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserPrefsBoxRef = FutureProviderRef<Box<String>>;
String _$subscriptionRepositoryHash() =>
    r'485575c4dfd8d01ad8fae6c31b25314c147a1519';

/// 订阅仓储Provider
/// 提供SubscriptionRepository实例
///
/// Copied from [subscriptionRepository].
@ProviderFor(subscriptionRepository)
final subscriptionRepositoryProvider =
    Provider<SubscriptionRepository>.internal(
  subscriptionRepository,
  name: r'subscriptionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$subscriptionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SubscriptionRepositoryRef = ProviderRef<SubscriptionRepository>;
String _$monthlyHistoryRepositoryHash() =>
    r'8c2f8c4eb6d7e9d7b3322653a6c0be7005354556';

/// 月度历史仓储Provider
/// 提供MonthlyHistoryRepository实例
///
/// Copied from [monthlyHistoryRepository].
@ProviderFor(monthlyHistoryRepository)
final monthlyHistoryRepositoryProvider =
    Provider<MonthlyHistoryRepository>.internal(
  monthlyHistoryRepository,
  name: r'monthlyHistoryRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$monthlyHistoryRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MonthlyHistoryRepositoryRef = ProviderRef<MonthlyHistoryRepository>;
String _$appInitializationHash() => r'b4d9a0e201eee00cc0714275eec92cce8140da26';

/// 应用初始化Provider
/// 处理应用启动时的所有初始化工作
///
/// Copied from [appInitialization].
@ProviderFor(appInitialization)
final appInitializationProvider = AutoDisposeFutureProvider<bool>.internal(
  appInitialization,
  name: r'appInitializationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appInitializationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppInitializationRef = AutoDisposeFutureProviderRef<bool>;
String _$cacheStatsHash() => r'01f784500ee46884a0c61d26dd49a0033a475729';

/// 缓存统计信息Provider
/// 提供缓存使用情况的统计信息
///
/// Copied from [cacheStats].
@ProviderFor(cacheStats)
final cacheStatsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  cacheStats,
  name: r'cacheStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cacheStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheStatsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$databaseStatsHash() => r'c7289315ccf3320014d79cc76c808b7574ac2767';

/// 数据库统计信息Provider
/// 提供数据库使用情况的统计信息
///
/// Copied from [databaseStats].
@ProviderFor(databaseStats)
final databaseStatsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  databaseStats,
  name: r'databaseStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DatabaseStatsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$themeModeProviderHash() => r'c9777daa0a4572448f4fabe7ece594b429689624';

/// 主题模式Provider
/// 提供当前主题模式
///
/// Copied from [themeModeProvider].
@ProviderFor(themeModeProvider)
final themeModeProviderProvider = AutoDisposeProvider<ThemeMode>.internal(
  themeModeProvider,
  name: r'themeModeProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeModeProviderRef = AutoDisposeProviderRef<ThemeMode>;
String _$fontSizeProviderHash() => r'4f8dbbab10a15be936deefc15115d2148b4da0db';

/// 字体大小Provider
/// 提供当前字体大小
///
/// Copied from [fontSizeProvider].
@ProviderFor(fontSizeProvider)
final fontSizeProviderProvider = AutoDisposeProvider<double>.internal(
  fontSizeProvider,
  name: r'fontSizeProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fontSizeProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FontSizeProviderRef = AutoDisposeProviderRef<double>;
String _$themeColorProviderHash() =>
    r'8db7d3b7063b26682955c332c1534073dc54b70e';

/// 主题颜色Provider
/// 提供当前主题颜色
///
/// Copied from [themeColorProvider].
@ProviderFor(themeColorProvider)
final themeColorProviderProvider = AutoDisposeProvider<Color?>.internal(
  themeColorProvider,
  name: r'themeColorProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeColorProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ThemeColorProviderRef = AutoDisposeProviderRef<Color?>;
String _$baseCurrencyProviderHash() =>
    r'55fed0fe9c0a33b123f3ac7aa158c39e1918bc70';

/// 基准货币Provider
/// 提供当前基准货币
///
/// Copied from [baseCurrencyProvider].
@ProviderFor(baseCurrencyProvider)
final baseCurrencyProviderProvider = AutoDisposeProvider<String>.internal(
  baseCurrencyProvider,
  name: r'baseCurrencyProviderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$baseCurrencyProviderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BaseCurrencyProviderRef = AutoDisposeProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
