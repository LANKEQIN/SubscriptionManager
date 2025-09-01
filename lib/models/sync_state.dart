import 'package:freezed_annotation/freezed_annotation.dart';
import 'sync_types.dart';

part 'sync_state.freezed.dart';

/// 同步状态模型
/// 
/// 管理应用的数据同步状态
@freezed
class SyncState with _$SyncState {
  const factory SyncState({
    /// 是否正在同步
    @Default(false) bool isLoading,
    
    /// 同步错误信息
    String? error,
    
    /// 最后同步时间
    DateTime? lastSyncTime,
    
    /// 网络状态
    @Default(NetworkStatus.unknown) NetworkStatus networkStatus,
    
    /// 待同步的项目数量
    @Default(0) int pendingSyncCount,
    
    /// 冲突的项目数量
    @Default(0) int conflictCount,
    
    /// 同步进度 (0.0 - 1.0)
    @Default(0.0) double progress,
    
    /// 同步状态描述
    String? statusMessage,
  }) = _SyncState;
  
  const SyncState._();
  
  /// 获取网络状态描述
  String get networkStatusText {
    switch (networkStatus) {
      case NetworkStatus.online:
        return '在线';
      case NetworkStatus.offline:
        return '离线';
      case NetworkStatus.slow:
        return '网络缓慢';
      case NetworkStatus.unknown:
        return '未知';
    }
  }
  
  /// 检查是否在线
  bool get isOnline => networkStatus == NetworkStatus.online;
  
  /// 检查是否有错误
  bool get hasError => error != null;
  
  /// 检查是否有冲突
  bool get hasConflicts => conflictCount > 0;
  
  /// 检查是否有待同步项目
  bool get hasPendingSync => pendingSyncCount > 0;
  
  /// 获取状态图标
  String get statusIcon {
    if (hasError) return '❌';
    if (hasConflicts) return '⚠️';
    if (isLoading) return '🔄';
    if (!isOnline) return '📶';
    if (hasPendingSync) return '⏳';
    return '✅';
  }
  
  /// 更新同步进度
  SyncState updateProgress(double progress, {String? message}) {
    return copyWith(
      progress: progress.clamp(0.0, 1.0),
      statusMessage: message,
    );
  }
  
  /// 开始同步
  SyncState startSync() {
    return copyWith(
      isLoading: true,
      error: null,
      progress: 0.0,
      statusMessage: '开始同步...',
    );
  }
  
  /// 同步完成
  SyncState completeSync() {
    return copyWith(
      isLoading: false,
      error: null,
      lastSyncTime: DateTime.now(),
      progress: 1.0,
      statusMessage: '同步完成',
      pendingSyncCount: 0,
    );
  }
  
  /// 同步失败
  SyncState failSync(String errorMessage) {
    return copyWith(
      isLoading: false,
      error: errorMessage,
      progress: 0.0,
      statusMessage: '同步失败: $errorMessage',
    );
  }
  
  /// 更新网络状态
  SyncState updateNetworkStatus(NetworkStatus status) {
    return copyWith(
      networkStatus: status,
    );
  }
  
  /// 更新计数
  SyncState updateCounts({
    int? pendingSyncCount,
    int? conflictCount,
  }) {
    return copyWith(
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      conflictCount: conflictCount ?? this.conflictCount,
    );
  }
}