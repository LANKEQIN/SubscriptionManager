import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import '../models/sync_types.dart';
import '../services/connectivity_service.dart';
import '../services/auth_service.dart';
import 'repository_interfaces.dart';
import 'remote_subscription_repository.dart';
import 'error_handler.dart';
import '../providers/app_providers.dart';

part 'hybrid_subscription_repository.g.dart';

/// 混合订阅数据仓库
/// 
/// 结合本地和远程数据源，提供离线优先的数据访问
class HybridSubscriptionRepository with ErrorHandler implements SubscriptionRepository {
  final SubscriptionRepository _localRepo;
  final RemoteSubscriptionRepository _remoteRepo;
  final ConnectivityService _connectivity;
  final AuthService _authService;
  
  HybridSubscriptionRepository({
    required SubscriptionRepository localRepo,
    required RemoteSubscriptionRepository remoteRepo,
    required ConnectivityService connectivity,
    required AuthService authService,
  }) : _localRepo = localRepo,
       _remoteRepo = remoteRepo,
       _connectivity = connectivity,
       _authService = authService;
  
  /// 检查是否应该尝试远程操作
  bool get _shouldTryRemote => 
      _connectivity.isConnected && _authService.isLoggedIn;
  
  @override
  Future<List<Subscription>> getAllSubscriptions() async {
    try {
      // 优先返回本地数据（离线优先策略）
      final localSubscriptions = await _localRepo.getAllSubscriptions();
      
      // 如果网络可用且用户已登录，后台同步远程数据
      if (_shouldTryRemote) {
        _syncInBackground();
      }
      
      return localSubscriptions;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<Subscription?> getSubscriptionById(String id) async {
    try {
      // 先从本地查找
      final localSubscription = await _localRepo.getSubscriptionById(id);
      
      if (localSubscription != null) {
        return localSubscription;
      }
      
      // 如果本地没有且网络可用，尝试从远程获取
      if (_shouldTryRemote) {
        try {
          final remoteSubscription = await _remoteRepo.getSubscriptionById(id);
          if (remoteSubscription != null) {
            // 保存到本地以供离线使用
            await _localRepo.addSubscription(remoteSubscription);
            return remoteSubscription;
          }
        } catch (e) {
          // 远程获取失败，继续使用本地数据
          debugPrint('远程获取订阅失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
      
      return null;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> addSubscription(Subscription subscription) async {
    try {
      // 立即保存到本地
      final localSubscription = subscription.copyWith(
        needsSync: true,
        syncStatus: SyncStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _localRepo.addSubscription(localSubscription);
      
      // 如果网络可用，尝试同步到远程
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.addSubscription(localSubscription);
          
          // 获取服务器生成的ID并更新本地记录
          final serverSubscription = await _remoteRepo.getSubscriptionByLocalId(localSubscription.id);
          if (serverSubscription != null) {
            final synced = localSubscription.markAsSynced(serverId: serverSubscription.serverId);
            await _localRepo.updateSubscription(synced);
          }
        } catch (e) {
          // 远程同步失败，标记错误状态
          final errorSubscription = localSubscription.markSyncError();
          await _localRepo.updateSubscription(errorSubscription);
          debugPrint('远程添加订阅失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      // 更新本地数据
      final updatedSubscription = subscription.copyWith(
        needsSync: true,
        syncStatus: SyncStatus.pending,
        updatedAt: DateTime.now(),
      );
      
      await _localRepo.updateSubscription(updatedSubscription);
      
      // 如果网络可用，尝试同步到远程
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.updateSubscription(updatedSubscription);
          
          // 更新成功，标记为已同步
          final synced = updatedSubscription.markAsSynced();
          await _localRepo.updateSubscription(synced);
        } catch (e) {
          // 远程同步失败，标记错误状态
          final errorSubscription = updatedSubscription.markSyncError();
          await _localRepo.updateSubscription(errorSubscription);
          debugPrint('远程更新订阅失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> deleteSubscription(String id) async {
    try {
      final subscription = await _localRepo.getSubscriptionById(id);
      
      // 删除本地数据
      await _localRepo.deleteSubscription(id);
      
      // 如果网络可用且有服务器ID，删除远程数据
      if (_shouldTryRemote && subscription?.serverId != null) {
        try {
          await _remoteRepo.deleteSubscription(subscription!.serverId!);
        } catch (e) {
          // 远程删除失败，记录日志但不影响本地删除
          debugPrint('远程删除订阅失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> searchSubscriptions(String query) async {
    try {
      // 主要从本地搜索
      final localResults = await _localRepo.searchSubscriptions(query);
      
      // 如果网络可用，也从远程搜索以获得更全面的结果
      if (_shouldTryRemote) {
        try {
          final remoteResults = await _remoteRepo.searchSubscriptions(query);
          
          // 合并结果，避免重复
          final combinedResults = <Subscription>[];
          combinedResults.addAll(localResults);
          
          for (final remote in remoteResults) {
            final exists = localResults.any((local) => 
              local.serverId == remote.serverId || 
              local.id == remote.id
            );
            if (!exists) {
              combinedResults.add(remote);
              // 保存到本地供后续使用
              await _localRepo.addSubscription(remote);
            }
          }
          
          return combinedResults;
        } catch (e) {
          // 远程搜索失败，返回本地结果
          debugPrint('远程搜索失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
      
      return localResults;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getUpcomingSubscriptions({int daysAhead = 7}) async {
    try {
      final localSubscriptions = await _localRepo.getUpcomingSubscriptions(daysAhead: daysAhead);
      
      if (_shouldTryRemote) {
        _syncInBackground();
      }
      
      return localSubscriptions;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getExpiredSubscriptions() async {
    try {
      final localSubscriptions = await _localRepo.getExpiredSubscriptions();
      
      if (_shouldTryRemote) {
        _syncInBackground();
      }
      
      return localSubscriptions;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<Subscription>> getSubscriptionsByType(String type) async {
    try {
      final localSubscriptions = await _localRepo.getSubscriptionsByType(type);
      
      if (_shouldTryRemote) {
        _syncInBackground();
      }
      
      return localSubscriptions;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  @override
  Future<double> getTotalMonthlyAmount() async {
    try {
      // 计算本地数据
      final localTotal = await _localRepo.getTotalMonthlyAmount();
      
      // 如果网络可用，验证远程计算是否一致
      if (_shouldTryRemote) {
        try {
          final remoteTotal = await _remoteRepo.getTotalMonthlyAmount();
          
          // 如果差异很大，可能需要同步数据
          const tolerance = 0.01; // 1分钱的容差
          if ((localTotal - remoteTotal).abs() > tolerance) {
            debugPrint('本地和远程总金额不一致: 本地=$localTotal, 远程=$remoteTotal');
            // 触发后台同步
            _syncInBackground();
          }
        } catch (e) {
          debugPrint('获取远程总金额失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
      
      return localTotal;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 获取需要同步的订阅
  Future<List<Subscription>> getUnsyncedSubscriptions() async {
    try {
      final allSubscriptions = await _localRepo.getAllSubscriptions();
      return allSubscriptions.where((s) => s.needsSync).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 获取冲突的订阅
  Future<List<Subscription>> getConflictSubscriptions() async {
    try {
      final allSubscriptions = await _localRepo.getAllSubscriptions();
      return allSubscriptions.where((s) => s.syncStatus == SyncStatus.conflict).toList();
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 更新同步状态
  Future<void> updateSyncStatus(String id, SyncStatus status) async {
    try {
      final subscription = await _localRepo.getSubscriptionById(id);
      if (subscription != null) {
        final updated = subscription.copyWith(
          syncStatus: status,
          needsSync: status == SyncStatus.pending,
          lastSyncedAt: status == SyncStatus.synced ? DateTime.now() : subscription.lastSyncedAt,
        );
        await _localRepo.updateSubscription(updated);
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 后台同步
  void _syncInBackground() {
    // 这里应该调用 SyncService 进行后台同步
    // 为了避免循环依赖，这里只是一个占位符
    debugPrint('触发后台同步...');
  }
  
  /// 批量保存从服务器获取的数据
  Future<void> saveFromServer(List<Subscription> subscriptions) async {
    try {
      for (final subscription in subscriptions) {
        final existing = await _findExistingSubscription(subscription);
        
        if (existing == null) {
          // 新记录
          await _localRepo.addSubscription(subscription);
        } else {
          // 更新现有记录
          final updated = subscription.copyWith(
            id: existing.id, // 保持本地ID
            syncStatus: SyncStatus.synced,
            needsSync: false,
            lastSyncedAt: DateTime.now(),
          );
          await _localRepo.updateSubscription(updated);
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  /// 查找现有的订阅记录
  Future<Subscription?> _findExistingSubscription(Subscription serverSubscription) async {
    final allSubscriptions = await _localRepo.getAllSubscriptions();
    
    // 按服务器ID查找
    if (serverSubscription.serverId != null) {
      final found = allSubscriptions
          .where((s) => s.serverId == serverSubscription.serverId)
          .firstOrNull;
      if (found != null) return found;
    }
    
    // 按本地ID查找
    final foundById = allSubscriptions
        .where((s) => s.id == serverSubscription.id)
        .firstOrNull;
    if (foundById != null) return foundById;
    
    // 按名称和特征匹配
    return allSubscriptions
        .where((s) => 
          s.name == serverSubscription.name && 
          s.price == serverSubscription.price &&
          s.currency == serverSubscription.currency
        )
        .firstOrNull;
  }
}

/// 混合月度历史数据仓库
class HybridMonthlyHistoryRepository with ErrorHandler implements MonthlyHistoryRepository {
  final MonthlyHistoryRepository _localRepo;
  final RemoteMonthlyHistoryRepository _remoteRepo;
  final ConnectivityService _connectivity;
  final AuthService _authService;
  
  HybridMonthlyHistoryRepository({
    required MonthlyHistoryRepository localRepo,
    required RemoteMonthlyHistoryRepository remoteRepo,
    required ConnectivityService connectivity,
    required AuthService authService,
  }) : _localRepo = localRepo,
       _remoteRepo = remoteRepo,
       _connectivity = connectivity,
       _authService = authService;
  
  bool get _shouldTryRemote => 
      _connectivity.isConnected && _authService.isLoggedIn;
  
  @override
  Future<List<MonthlyHistory>> getAllHistories() async {
    try {
      final localHistory = await _localRepo.getAllHistories();
      
      if (_shouldTryRemote) {
        _syncHistoryInBackground();
      }
      
      return localHistory;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<MonthlyHistory?> getHistoryByYearMonth(int year, int month) async {
    try {
      final localHistory = await _localRepo.getHistoryByYearMonth(year, month);
      
      if (localHistory != null) {
        return localHistory;
      }
      
      if (_shouldTryRemote) {
        try {
          final remoteHistory = await _remoteRepo.getHistoryByYearMonth(year, month);
          if (remoteHistory != null) {
            await _localRepo.addMonthlyHistory(remoteHistory);
            return remoteHistory;
          }
        } catch (e) {
          debugPrint('获取远程历史记录失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
      
      return null;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> updateCurrentMonthHistory(List<Subscription> subscriptions) async {
    try {
      await _localRepo.updateCurrentMonthHistory(subscriptions);
        
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.updateCurrentMonthHistory(subscriptions);
        } catch (e) {
          debugPrint('更新远程当前月度历史失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> addMonthlyHistory(MonthlyHistory history) async {
    try {
      await _localRepo.addMonthlyHistory(history);
        
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.addMonthlyHistory(history);
        } catch (e) {
          debugPrint('添加远程历史记录失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> deleteMonthlyHistory(String id) async {
    try {
      await _localRepo.deleteMonthlyHistory(id);
        
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.deleteMonthlyHistory(id);
        } catch (e) {
          debugPrint('删除远程历史记录失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<MonthlyHistory>> getYearlyStatistics(int year) async {
    try {
      final localHistory = await _localRepo.getYearlyStatistics(year);
        
      if (_shouldTryRemote) {
        try {
          final remoteHistory = await _remoteRepo.getYearlyStatistics(year);
            
          // 合并和同步历史记录
          for (final remote in remoteHistory) {
            final existing = localHistory.where((local) => 
              local.year == remote.year && local.month == remote.month
            ).firstOrNull;
              
            if (existing == null) {
              await _localRepo.addMonthlyHistory(remote);
              localHistory.add(remote);
            }
          }
        } catch (e) {
          debugPrint('获取远程年度历史失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
        
      return localHistory;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<List<MonthlyHistory>> getHistoriesInRange(DateTime startDate, DateTime endDate) async {
    try {
      final localHistory = await _localRepo.getHistoriesInRange(startDate, endDate);
        
      if (_shouldTryRemote) {
        _syncHistoryInBackground();
      }
        
      return localHistory;
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> saveHistory(MonthlyHistory history) async {
    try {
      await _localRepo.saveHistory(history);
      
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.saveHistory(history);
        } catch (e) {
          debugPrint('保存远程历史记录失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  @override
  Future<void> deleteHistory(String id) async {
    try {
      await _localRepo.deleteHistory(id);
      
      if (_shouldTryRemote) {
        try {
          await _remoteRepo.deleteHistory(id);
        } catch (e) {
          debugPrint('删除远程历史记录失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
        }
      }
    } catch (e) {
      throw Exception(getErrorMessage(e is Exception ? e : Exception(e.toString())));
    }
  }
  
  void _syncHistoryInBackground() {
    debugPrint('触发历史记录后台同步...');
  }
}

/// Provider for hybrid repositories
@riverpod
HybridSubscriptionRepository hybridSubscriptionRepository(Ref ref) {
  final localRepo = ref.watch(subscriptionRepositoryProvider);
  final remoteRepo = RemoteSubscriptionRepository();
  final connectivity = ref.watch(connectivityServiceProvider.notifier);
  final authService = ref.watch(authServiceProvider.notifier);
  
  return HybridSubscriptionRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    connectivity: connectivity,
    authService: authService,
  );
}

@riverpod
HybridMonthlyHistoryRepository hybridMonthlyHistoryRepository(Ref ref) {
  final localRepo = ref.watch(monthlyHistoryRepositoryProvider);
  final remoteRepo = RemoteMonthlyHistoryRepository();
  final connectivity = ref.watch(connectivityServiceProvider.notifier);
  final authService = ref.watch(authServiceProvider.notifier);
  
  return HybridMonthlyHistoryRepository(
    localRepo: localRepo,
    remoteRepo: remoteRepo,
    connectivity: connectivity,
    authService: authService,
  );
}

/// 扩展方法支持firstOrNull
extension IterableExtensionHybrid<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}