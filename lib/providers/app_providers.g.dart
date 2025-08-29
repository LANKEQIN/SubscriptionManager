// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'3d3a397d2ea952fc020fce0506793a5564e93530';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$cacheBoxHash() => r'2c81ae898dbfdd99a5ecee2ccf491c57c1c4879e';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CacheBoxRef = FutureProviderRef<Box<CachedData>>;
String _$userPrefsBoxHash() => r'bccf091519bc8fd1bfb3833c98087efe3f86ccd3';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPrefsBoxRef = FutureProviderRef<Box<String>>;
String _$subscriptionRepositoryHash() =>
    r'6922e898273b9df3fbf4e5ae1a16bda7e757832b';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscriptionRepositoryRef = ProviderRef<SubscriptionRepository>;
String _$monthlyHistoryRepositoryHash() =>
    r'6df618f96ea81adc338359a749676bfe47400dd5';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MonthlyHistoryRepositoryRef = ProviderRef<MonthlyHistoryRepository>;
String _$appInitializationHash() => r'a080b96d9aed19b613208eb2a047eefca7c93862';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppInitializationRef = AutoDisposeFutureProviderRef<bool>;
String _$cacheStatsHash() => r'bd4799d31fdfb38fa0c37a40e7d016a6e1f3596a';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CacheStatsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$databaseStatsHash() => r'9cf5fbc64f070c05463e0d33695f25a55d9ef1ed';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseStatsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$themeModeProviderHash() => r'090ae1e9c69b9edd9552137b3273c448ac655382';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThemeModeProviderRef = AutoDisposeProviderRef<ThemeMode>;
String _$fontSizeProviderHash() => r'f25a8593cbf4d4295d73f57efa4da9faeb402ec0';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FontSizeProviderRef = AutoDisposeProviderRef<double>;
String _$themeColorProviderHash() =>
    r'e357092b0a5368062adf965d843ad9a98c343136';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThemeColorProviderRef = AutoDisposeProviderRef<Color?>;
String _$baseCurrencyProviderHash() =>
    r'e820847571564fabc35cec0927c60ad2a28762fb';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BaseCurrencyProviderRef = AutoDisposeProviderRef<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
