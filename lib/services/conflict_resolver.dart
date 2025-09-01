import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/subscription.dart';
import '../models/monthly_history.dart';
import '../models/sync_types.dart';

part 'conflict_resolver.g.dart';

/// 数据冲突信息
class DataConflict<T> {
  final T localData;
  final T remoteData;
  final ConflictType type;
  final DateTime detectedAt;
  final String? description;
  
  DataConflict({
    required this.localData,
    required this.remoteData,
    required this.type,
    DateTime? detectedAt,
    this.description,
  }) : detectedAt = detectedAt ?? DateTime.now();
}

/// 冲突类型
enum ConflictType {
  timeStampConflict,    // 时间戳冲突
  fieldConflict,        // 字段级冲突
  deletionConflict,     // 删除冲突
  creationConflict,     // 创建冲突
}

/// 冲突解决结果
class ConflictResolution<T> {
  final T resolvedData;
  final ConflictStrategy usedStrategy;
  final String? reason;
  final bool requiresUserInput;
  
  ConflictResolution({
    required this.resolvedData,
    required this.usedStrategy,
    this.reason,
    this.requiresUserInput = false,
  });
}

/// 冲突解决服务
/// 
/// 处理本地和远程数据之间的冲突
@riverpod
class ConflictResolver extends _$ConflictResolver {
  @override
  ConflictStrategy build() {
    // 默认冲突解决策略
    return ConflictStrategy.lastModified;
  }
  
  /// 设置默认冲突解决策略
  void setDefaultStrategy(ConflictStrategy strategy) {
    state = strategy;
  }
  
  /// 解决订阅数据冲突
  Future<ConflictResolution<Subscription>> resolveSubscriptionConflict(
    DataConflict<Subscription> conflict, {
    ConflictStrategy? strategy,
  }) async {
    final resolveStrategy = strategy ?? state;
    
    switch (resolveStrategy) {
      case ConflictStrategy.lastModified:
        return _resolveByTimestamp(conflict);
      case ConflictStrategy.serverWins:
        return _resolveServerWins(conflict);
      case ConflictStrategy.clientWins:
        return _resolveClientWins(conflict);
      case ConflictStrategy.merge:
        return _mergeSubscriptions(conflict);
      case ConflictStrategy.userChoice:
        return _requireUserChoice(conflict);
    }
  }
  
  /// 解决月度历史数据冲突
  Future<ConflictResolution<MonthlyHistory>> resolveHistoryConflict(
    DataConflict<MonthlyHistory> conflict, {
    ConflictStrategy? strategy,
  }) async {
    final resolveStrategy = strategy ?? state;
    
    switch (resolveStrategy) {
      case ConflictStrategy.lastModified:
        return _resolveHistoryByTimestamp(conflict);
      case ConflictStrategy.serverWins:
        return _resolveHistoryServerWins(conflict);
      case ConflictStrategy.clientWins:
        return _resolveHistoryClientWins(conflict);
      case ConflictStrategy.merge:
        return _mergeHistories(conflict);
      case ConflictStrategy.userChoice:
        return _requireHistoryUserChoice(conflict);
    }
  }
  
  /// 检测订阅冲突
  DataConflict<Subscription>? detectSubscriptionConflict(
    Subscription local,
    Subscription remote,
  ) {
    // 检查时间戳冲突
    if (_hasTimestampConflict(
      local.updatedAt,
      remote.updatedAt,
      local.lastSyncedAt,
    )) {
      return DataConflict(
        localData: local,
        remoteData: remote,
        type: ConflictType.timeStampConflict,
        description: '本地和远程数据都在最后同步后被修改',
      );
    }
    
    // 检查字段级冲突
    final fieldConflicts = _detectSubscriptionFieldConflicts(local, remote);
    if (fieldConflicts.isNotEmpty) {
      return DataConflict(
        localData: local,
        remoteData: remote,
        type: ConflictType.fieldConflict,
        description: '字段冲突: ${fieldConflicts.join(', ')}',
      );
    }
    
    return null;
  }
  
  /// 检测月度历史冲突
  DataConflict<MonthlyHistory>? detectHistoryConflict(
    MonthlyHistory local,
    MonthlyHistory remote,
  ) {
    // 检查时间戳冲突
    if (_hasTimestampConflict(
      local.updatedAt,
      remote.updatedAt,
      local.lastSyncedAt,
    )) {
      return DataConflict(
        localData: local,
        remoteData: remote,
        type: ConflictType.timeStampConflict,
        description: '本地和远程历史记录都被修改',
      );
    }
    
    // 检查数据不一致
    if (local.totalAmount != remote.totalAmount ||
        local.subscriptionCount != remote.subscriptionCount) {
      return DataConflict(
        localData: local,
        remoteData: remote,
        type: ConflictType.fieldConflict,
        description: '金额或订阅数量不一致',
      );
    }
    
    return null;
  }
  
  /// 按时间戳解决订阅冲突
  ConflictResolution<Subscription> _resolveByTimestamp(
    DataConflict<Subscription> conflict,
  ) {
    final local = conflict.localData;
    final remote = conflict.remoteData;
    
    final localTime = local.updatedAt ?? local.createdAt ?? DateTime.now();
    final remoteTime = remote.updatedAt ?? remote.createdAt ?? DateTime.now();
    
    if (localTime.isAfter(remoteTime)) {
      return ConflictResolution(
        resolvedData: local,
        usedStrategy: ConflictStrategy.lastModified,
        reason: '本地数据更新时间较新',
      );
    } else {
      return ConflictResolution(
        resolvedData: remote,
        usedStrategy: ConflictStrategy.lastModified,
        reason: '远程数据更新时间较新',
      );
    }
  }
  
  /// 服务器优先解决订阅冲突
  ConflictResolution<Subscription> _resolveServerWins(
    DataConflict<Subscription> conflict,
  ) {
    return ConflictResolution(
      resolvedData: conflict.remoteData,
      usedStrategy: ConflictStrategy.serverWins,
      reason: '采用服务器数据',
    );
  }
  
  /// 客户端优先解决订阅冲突
  ConflictResolution<Subscription> _resolveClientWins(
    DataConflict<Subscription> conflict,
  ) {
    return ConflictResolution(
      resolvedData: conflict.localData,
      usedStrategy: ConflictStrategy.clientWins,
      reason: '保留本地数据',
    );
  }
  
  /// 智能合并订阅数据
  ConflictResolution<Subscription> _mergeSubscriptions(
    DataConflict<Subscription> conflict,
  ) {
    final local = conflict.localData;
    final remote = conflict.remoteData;
    
    // 智能合并逻辑
    final merged = local.copyWith(
      // 保留本地的用户偏好设置
      name: local.name.isNotEmpty ? local.name : remote.name,
      notes: local.notes?.isNotEmpty == true ? local.notes : remote.notes,
      
      // 保留最新的财务数据（通常远程数据更权威）
      price: remote.price,
      nextPaymentDate: remote.nextPaymentDate,
      currency: remote.currency,
      billingCycle: remote.billingCycle,
      
      // 更新时间戳
      updatedAt: DateTime.now(),
      syncStatus: SyncStatus.synced,
      needsSync: false,
    );
    
    return ConflictResolution(
      resolvedData: merged,
      usedStrategy: ConflictStrategy.merge,
      reason: '智能合并本地偏好和远程财务数据',
    );
  }
  
  /// 需要用户选择解决订阅冲突
  ConflictResolution<Subscription> _requireUserChoice(
    DataConflict<Subscription> conflict,
  ) {
    // 临时返回本地数据，标记需要用户输入
    return ConflictResolution(
      resolvedData: conflict.localData.copyWith(
        syncStatus: SyncStatus.conflict,
      ),
      usedStrategy: ConflictStrategy.userChoice,
      reason: '需要用户手动选择',
      requiresUserInput: true,
    );
  }
  
  /// 按时间戳解决历史记录冲突
  ConflictResolution<MonthlyHistory> _resolveHistoryByTimestamp(
    DataConflict<MonthlyHistory> conflict,
  ) {
    final local = conflict.localData;
    final remote = conflict.remoteData;
    
    final localTime = local.updatedAt ?? local.createdAt ?? DateTime.now();
    final remoteTime = remote.updatedAt ?? remote.createdAt ?? DateTime.now();
    
    if (localTime.isAfter(remoteTime)) {
      return ConflictResolution(
        resolvedData: local,
        usedStrategy: ConflictStrategy.lastModified,
        reason: '本地历史记录更新时间较新',
      );
    } else {
      return ConflictResolution(
        resolvedData: remote,
        usedStrategy: ConflictStrategy.lastModified,
        reason: '远程历史记录更新时间较新',
      );
    }
  }
  
  /// 服务器优先解决历史记录冲突
  ConflictResolution<MonthlyHistory> _resolveHistoryServerWins(
    DataConflict<MonthlyHistory> conflict,
  ) {
    return ConflictResolution(
      resolvedData: conflict.remoteData,
      usedStrategy: ConflictStrategy.serverWins,
      reason: '采用服务器历史记录',
    );
  }
  
  /// 客户端优先解决历史记录冲突
  ConflictResolution<MonthlyHistory> _resolveHistoryClientWins(
    DataConflict<MonthlyHistory> conflict,
  ) {
    return ConflictResolution(
      resolvedData: conflict.localData,
      usedStrategy: ConflictStrategy.clientWins,
      reason: '保留本地历史记录',
    );
  }
  
  /// 智能合并历史记录
  ConflictResolution<MonthlyHistory> _mergeHistories(
    DataConflict<MonthlyHistory> conflict,
  ) {
    final local = conflict.localData;
    final remote = conflict.remoteData;
    
    // 对于历史记录，通常取较大的值（更完整的数据）
    final merged = local.copyWith(
      totalAmount: local.totalAmount > remote.totalAmount 
          ? local.totalAmount 
          : remote.totalAmount,
      subscriptionCount: local.subscriptionCount > remote.subscriptionCount
          ? local.subscriptionCount
          : remote.subscriptionCount,
      updatedAt: DateTime.now(),
    );
    
    return ConflictResolution(
      resolvedData: merged,
      usedStrategy: ConflictStrategy.merge,
      reason: '合并历史记录，取较大值',
    );
  }
  
  /// 需要用户选择解决历史记录冲突
  ConflictResolution<MonthlyHistory> _requireHistoryUserChoice(
    DataConflict<MonthlyHistory> conflict,
  ) {
    return ConflictResolution(
      resolvedData: conflict.localData,
      usedStrategy: ConflictStrategy.userChoice,
      reason: '需要用户手动选择历史记录',
      requiresUserInput: true,
    );
  }
  
  /// 检查时间戳冲突
  bool _hasTimestampConflict(
    DateTime? localUpdated,
    DateTime? remoteUpdated,
    DateTime? lastSynced,
  ) {
    if (localUpdated == null || remoteUpdated == null || lastSynced == null) {
      return false;
    }
    
    // 如果本地和远程都在最后同步时间之后被修改，则存在冲突
    return localUpdated.isAfter(lastSynced) && 
           remoteUpdated.isAfter(lastSynced);
  }
  
  /// 检测订阅字段冲突
  List<String> _detectSubscriptionFieldConflicts(
    Subscription local,
    Subscription remote,
  ) {
    final conflicts = <String>[];
    
    if (local.name != remote.name) conflicts.add('name');
    if (local.price != remote.price) conflicts.add('price');
    if (local.currency != remote.currency) conflicts.add('currency');
    if (local.billingCycle != remote.billingCycle) conflicts.add('billingCycle');
    if (local.nextPaymentDate != remote.nextPaymentDate) conflicts.add('nextPaymentDate');
    if (local.autoRenewal != remote.autoRenewal) conflicts.add('autoRenewal');
    if (local.notes != remote.notes) conflicts.add('notes');
    
    return conflicts;
  }
  
  /// 批量解决冲突
  Future<List<ConflictResolution<Subscription>>> resolveBatchConflicts(
    List<DataConflict<Subscription>> conflicts, {
    ConflictStrategy? strategy,
  }) async {
    final results = <ConflictResolution<Subscription>>[];
    
    for (final conflict in conflicts) {
      final resolution = await resolveSubscriptionConflict(
        conflict,
        strategy: strategy,
      );
      results.add(resolution);
    }
    
    return results;
  }
  
  /// 获取冲突统计信息
  Map<ConflictType, int> getConflictStatistics(
    List<DataConflict> conflicts,
  ) {
    final stats = <ConflictType, int>{};
    
    for (final conflict in conflicts) {
      stats[conflict.type] = (stats[conflict.type] ?? 0) + 1;
    }
    
    return stats;
  }
}