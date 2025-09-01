import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/sync_state.dart';
import '../models/sync_types.dart';
import '../models/subscription.dart';
import '../repositories/remote_subscription_repository.dart';
import '../repositories/error_handler.dart';
import '../providers/app_providers.dart';
import 'connectivity_service.dart';
import 'auth_service.dart';

part 'sync_service.g.dart';

/// 数据同步服务
/// 
/// 管理本地和远程数据的同步，处理冲突解决和实时更新
@riverpod
class SyncService extends _$SyncService with ErrorHandler {
  StreamSubscription? _realtimeSubscription;
  Timer? _syncTimer;
  
  @override
  SyncState build() {
    _initializeSync();
    return const SyncState();
  }
  
  /// 初始化同步服务
  void _initializeSync() {
    // 监听网络状态变化
    ref.listen(connectivityServiceProvider, (previous, next) {
      if (previous == NetworkStatus.offline && next != NetworkStatus.offline) {
        // 网络恢复时自动同步
        syncOnReconnect();
      }
    });
    
    // 监听认证状态变化
    ref.listen(authServiceProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          // 用户登录后自动同步
          syncAfterAuth();
        } else {
          // 用户登出后清理同步状态
          clearSyncState();
        }
      });
    });
    
    // 启动定期同步
    _startPeriodicSync();
  }
  
  /// 登录后执行同步
  Future<void> syncAfterAuth() async {
    final user = ref.read(authServiceProvider).value;
    if (user == null) return;
    
    state = state.startSync();
    
    try {
      // 1. 上传本地未同步数据
      await _uploadLocalData();
      
      // 2. 下载服务器数据
      await _downloadServerData();
      
      // 3. 解决冲突
      await _resolveConflicts();
      
      // 4. 启动实时监听
      await _setupRealtimeSubscription();
      
      state = state.completeSync();
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = state.failSync(error);
    }
  }
  
  /// 网络重连时同步
  Future<void> syncOnReconnect() async {
    final networkStatus = ref.read(connectivityServiceProvider);
    final user = ref.read(authServiceProvider).value;
    
    if (networkStatus == NetworkStatus.offline || user == null) return;
    
    await _performIncrementalSync();
  }
  
  /// 手动触发同步
  Future<void> manualSync() async {
    final networkStatus = ref.read(connectivityServiceProvider);
    final user = ref.read(authServiceProvider).value;
    
    if (networkStatus == NetworkStatus.offline) {
      state = state.failSync('网络连接不可用');
      return;
    }
    
    if (user == null) {
      state = state.failSync('用户未登录');
      return;
    }
    
    await _performFullSync();
  }
  
  /// 执行完整同步
  Future<void> _performFullSync() async {
    state = state.startSync();
    
    try {
      state = state.updateProgress(0.1, message: '检查待同步数据...');
      await _uploadLocalData();
      
      state = state.updateProgress(0.4, message: '下载服务器数据...');
      await _downloadServerData();
      
      state = state.updateProgress(0.7, message: '解决数据冲突...');
      await _resolveConflicts();
      
      state = state.updateProgress(0.9, message: '更新同步状态...');
      await _updateSyncStatistics();
      
      state = state.completeSync();
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = state.failSync(error);
    }
  }
  
  /// 执行增量同步
  Future<void> _performIncrementalSync() async {
    if (state.isLoading) return; // 避免重复同步
    
    state = state.startSync();
    
    try {
      final lastSyncTime = state.lastSyncTime ?? DateTime.now().subtract(const Duration(days: 7));
      
      // 只同步最近更新的数据
      await _uploadLocalDataSince(lastSyncTime);
      await _downloadServerDataSince(lastSyncTime);
      await _resolveConflicts();
      
      state = state.completeSync();
    } catch (e) {
      final error = getErrorMessage(e is Exception ? e : Exception(e.toString()));
      state = state.failSync(error);
    }
  }
  
  /// 上传本地数据
  Future<void> _uploadLocalData() async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    final remoteRepo = RemoteSubscriptionRepository();
    
    // 获取需要同步的订阅
    final allSubscriptions = await localRepo.getAllSubscriptions();
    final pendingSubscriptions = allSubscriptions.where((s) => s.needsSync).toList();
    
    state = state.updateCounts(pendingSyncCount: pendingSubscriptions.length);
    
    for (int i = 0; i < pendingSubscriptions.length; i++) {
      final subscription = pendingSubscriptions[i];
      
      try {
        if (subscription.serverId == null) {
          // 新建记录
          await remoteRepo.addSubscription(subscription);
          
          // 获取服务器生成的ID并更新本地记录
          final serverSubscription = await remoteRepo.getSubscriptionByLocalId(subscription.id);
          if (serverSubscription != null) {
            final updated = subscription.markAsSynced(serverId: serverSubscription.serverId);
            await localRepo.updateSubscription(updated);
          }
        } else {
          // 更新记录
          await remoteRepo.updateSubscription(subscription);
          final updated = subscription.markAsSynced();
          await localRepo.updateSubscription(updated);
        }
        
        final progress = (i + 1) / pendingSubscriptions.length * 0.3;
        state = state.updateProgress(progress, message: '上传订阅数据 ${i + 1}/${pendingSubscriptions.length}');
      } catch (e) {
        // 标记同步失败
        final updated = subscription.markSyncError();
        await localRepo.updateSubscription(updated);
        debugPrint('上传订阅失败: ${subscription.name}, 错误: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
      }
    }
  }
  
  /// 从指定时间后上传本地数据
  Future<void> _uploadLocalDataSince(DateTime since) async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    final remoteRepo = RemoteSubscriptionRepository();
    
    final allSubscriptions = await localRepo.getAllSubscriptions();
    final pendingSubscriptions = allSubscriptions.where((s) => 
      s.needsSync || (s.updatedAt?.isAfter(since) ?? false)
    ).toList();
    
    for (final subscription in pendingSubscriptions) {
      try {
        if (subscription.serverId == null) {
          await remoteRepo.addSubscription(subscription);
        } else {
          await remoteRepo.updateSubscription(subscription);
        }
        
        final updated = subscription.markAsSynced();
        await localRepo.updateSubscription(updated);
      } catch (e) {
        final updated = subscription.markSyncError();
        await localRepo.updateSubscription(updated);
      }
    }
  }
  
  /// 下载服务器数据
  Future<void> _downloadServerData() async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    final remoteRepo = RemoteSubscriptionRepository();
    
    try {
      final serverSubscriptions = await remoteRepo.getAllSubscriptions();
      
      for (int i = 0; i < serverSubscriptions.length; i++) {
        final serverSubscription = serverSubscriptions[i];
        
        // 检查本地是否存在对应记录
        final localSubscription = await _findLocalSubscription(serverSubscription);
        
        if (localSubscription == null) {
          // 新记录，直接保存到本地
          await localRepo.addSubscription(serverSubscription);
        } else {
          // 检查是否需要更新
          if (_shouldUpdateLocal(localSubscription, serverSubscription)) {
            final updated = serverSubscription.copyWith(
              id: localSubscription.id, // 保持本地ID
            );
            await localRepo.updateSubscription(updated);
          }
        }
        
        final progress = 0.3 + (i + 1) / serverSubscriptions.length * 0.3;
        state = state.updateProgress(progress, message: '下载订阅数据 ${i + 1}/${serverSubscriptions.length}');
      }
    } catch (e) {
      throw Exception('下载服务器数据失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 从指定时间后下载服务器数据
  Future<void> _downloadServerDataSince(DateTime since) async {
    final remoteRepo = RemoteSubscriptionRepository();
    final localRepo = ref.read(subscriptionRepositoryProvider);
    
    try {
      final serverSubscriptions = await remoteRepo.getSubscriptionsUpdatedAfter(since);
      
      for (final serverSubscription in serverSubscriptions) {
        final localSubscription = await _findLocalSubscription(serverSubscription);
        
        if (localSubscription == null) {
          await localRepo.addSubscription(serverSubscription);
        } else if (_shouldUpdateLocal(localSubscription, serverSubscription)) {
          final updated = serverSubscription.copyWith(id: localSubscription.id);
          await localRepo.updateSubscription(updated);
        }
      }
    } catch (e) {
      throw Exception('增量下载失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 解决冲突
  Future<void> _resolveConflicts() async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    
    // 查找冲突的订阅
    final allSubscriptions = await localRepo.getAllSubscriptions();
    final conflictSubscriptions = allSubscriptions.where((s) => 
      s.syncStatus == SyncStatus.conflict
    ).toList();
    
    state = state.updateCounts(conflictCount: conflictSubscriptions.length);
    
    for (final subscription in conflictSubscriptions) {
      try {
        // 这里简化处理，实际应该获取对应的远程数据进行比较
        final updated = subscription.copyWith(
          syncStatus: SyncStatus.synced,
          needsSync: false,
          lastSyncedAt: DateTime.now(),
        );
        await localRepo.updateSubscription(updated);
      } catch (e) {
        debugPrint('解决冲突失败: ${subscription.name}, 错误: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
      }
    }
  }
  
  /// 设置实时订阅
  Future<void> _setupRealtimeSubscription() async {
    final user = ref.read(authServiceProvider).value;
    if (user == null) return;
    
    try {
      // 取消现有订阅
      await _realtimeSubscription?.cancel();
      
      // 订阅订阅表的变化
      final channel = SupabaseConfig.client
          .channel('subscriptions_${user.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'subscriptions',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'user_id',
              value: user.id,
            ),
            callback: _handleRealtimeChange,
          );
      
      channel.subscribe();
    } catch (e) {
      debugPrint('设置实时订阅失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 处理实时变化
  void _handleRealtimeChange(PostgresChangePayload payload) async {
    try {
      switch (payload.eventType) {
        case PostgresChangeEvent.insert:
          await _handleRealtimeInsert(payload);
          break;
        case PostgresChangeEvent.update:
          await _handleRealtimeUpdate(payload);
          break;
        case PostgresChangeEvent.delete:
          await _handleRealtimeDelete(payload);
          break;
        case PostgresChangeEvent.all:
          // 不处理，应该不会到达这里
          break;
      }
    } catch (e) {
      debugPrint('处理实时变化失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 处理实时插入
  Future<void> _handleRealtimeInsert(PostgresChangePayload payload) async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    
    try {
      final newData = payload.newRecord;
      final subscription = Subscription.fromSupabaseJson(newData);
      
      // 检查本地是否已存在
      final existing = await _findLocalSubscription(subscription);
      if (existing == null) {
        await localRepo.addSubscription(subscription);
      }
    } catch (e) {
      debugPrint('处理实时插入失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 处理实时更新
  Future<void> _handleRealtimeUpdate(PostgresChangePayload payload) async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    
    try {
      final newData = payload.newRecord;
      final subscription = Subscription.fromSupabaseJson(newData);
      final existing = await _findLocalSubscription(subscription);
      
      if (existing != null) {
        final updated = subscription.copyWith(id: existing.id);
        await localRepo.updateSubscription(updated);
      }
    } catch (e) {
      debugPrint('处理实时更新失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 处理实时删除
  Future<void> _handleRealtimeDelete(PostgresChangePayload payload) async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    
    try {
      final oldData = payload.oldRecord;
      if (oldData['id'] != null) {
        final serverId = oldData['id'] as String;
        // 根据serverId查找本地记录并删除
        final allSubscriptions = await localRepo.getAllSubscriptions();
        final toDelete = allSubscriptions.where((s) => s.serverId == serverId).toList();
        
        for (final subscription in toDelete) {
          await localRepo.deleteSubscription(subscription.id);
        }
      }
    } catch (e) {
      debugPrint('处理实时删除失败: ${getErrorMessage(e is Exception ? e : Exception(e.toString()))}');
    }
  }
  
  /// 查找对应的本地订阅
  Future<Subscription?> _findLocalSubscription(Subscription serverSubscription) async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    final allSubscriptions = await localRepo.getAllSubscriptions();
    
    // 首先按serverId查找
    if (serverSubscription.serverId != null) {
      final found = allSubscriptions.where((s) => s.serverId == serverSubscription.serverId).firstOrNull;
      if (found != null) return found;
    }
    
    // 然后按localId查找
    final foundByLocalId = allSubscriptions.where((s) => s.id == serverSubscription.id).firstOrNull;
    if (foundByLocalId != null) return foundByLocalId;
    
    // 最后按名称和价格模糊匹配
    return allSubscriptions.where((s) => 
      s.name == serverSubscription.name && 
      s.price == serverSubscription.price
    ).firstOrNull;
  }
  
  /// 判断是否应该更新本地数据
  bool _shouldUpdateLocal(Subscription local, Subscription server) {
    final localTime = local.updatedAt ?? local.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final serverTime = server.updatedAt ?? server.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    
    return serverTime.isAfter(localTime);
  }
  
  /// 更新同步统计信息
  Future<void> _updateSyncStatistics() async {
    final localRepo = ref.read(subscriptionRepositoryProvider);
    final allSubscriptions = await localRepo.getAllSubscriptions();
    
    final pendingCount = allSubscriptions.where((s) => s.needsSync).length;
    final conflictCount = allSubscriptions.where((s) => s.syncStatus == SyncStatus.conflict).length;
    
    state = state.updateCounts(
      pendingSyncCount: pendingCount,
      conflictCount: conflictCount,
    );
  }
  
  /// 启动定期同步
  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(SyncConstants.syncInterval, (_) {
      final networkStatus = ref.read(connectivityServiceProvider);
      final user = ref.read(authServiceProvider).value;
      
      if (networkStatus != NetworkStatus.offline && user != null && !state.isLoading) {
        _performIncrementalSync();
      }
    });
  }
  
  /// 停止定期同步
  void _stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
  
  /// 清理同步状态
  void clearSyncState() {
    _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    _stopPeriodicSync();
    
    state = const SyncState();
  }
  
  /// 销毁服务
  void dispose() {
    clearSyncState();
  }
}

/// 扩展方法支持firstOrNull
extension IterableExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}