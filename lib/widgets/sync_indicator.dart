import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sync_state.dart';
import '../models/sync_types.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';

/// 同步状态指示器小部件
/// 
/// 在应用顶部显示当前的同步状态
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);
    final networkStatus = ref.watch(connectivityServiceProvider);
    
    // 如果没有需要显示的状态，返回空容器
    if (!_shouldShowIndicator(syncState, networkStatus)) {
      return const SizedBox.shrink();
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _getBackgroundColor(syncState, networkStatus),
        border: Border(
          bottom: BorderSide(
            color: _getBorderColor(syncState, networkStatus),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            _buildStatusIcon(syncState, networkStatus),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getStatusTitle(syncState, networkStatus),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(syncState, networkStatus),
                    ),
                  ),
                  if (_getStatusSubtitle(syncState, networkStatus) != null)
                    Text(
                      _getStatusSubtitle(syncState, networkStatus)!,
                      style: TextStyle(
                        fontSize: 12,
                        color: _getTextColor(syncState, networkStatus).withValues(alpha: 0.8),
                      ),
                    ),
                  if (syncState.isLoading && syncState.progress > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: LinearProgressIndicator(
                        value: syncState.progress,
                        minHeight: 2,
                        backgroundColor: _getTextColor(syncState, networkStatus).withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation(
                          _getTextColor(syncState, networkStatus),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_shouldShowAction(syncState, networkStatus))
              _buildActionButton(context, ref, syncState, networkStatus)
            else if (networkStatus == NetworkStatus.offline || networkStatus == NetworkStatus.slow)
              // 添加关闭按钮
              IconButton(
                icon: Icon(Icons.close, size: 20, color: _getTextColor(syncState, networkStatus)),
                onPressed: () {
                  // 对于离线或缓慢网络状态，允许用户手动关闭指示器
                  ref.read(connectivityServiceProvider.notifier).dismissIndicator();
                },
              ),
          ],
        ),
      ),
    );
  }
  
  /// 判断是否应该显示指示器
  bool _shouldShowIndicator(SyncState syncState, NetworkStatus networkStatus) {
    // 离线时显示
    if (networkStatus == NetworkStatus.offline) return true;
    
    // 同步中显示
    if (syncState.isLoading) return true;
    
    // 有错误时显示
    if (syncState.hasError) return true;
    
    // 有冲突时显示
    if (syncState.hasConflicts) return true;
    
    // 有待同步项目时显示
    if (syncState.hasPendingSync) return true;
    
    // 网络缓慢时显示
    if (networkStatus == NetworkStatus.slow) return true;
    
    return false;
  }
  
  /// 构建状态图标
  Widget _buildStatusIcon(SyncState syncState, NetworkStatus networkStatus) {
    final iconData = _getStatusIcon(syncState, networkStatus);
    final color = _getIconColor(syncState, networkStatus);
    
    if (syncState.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      );
    }
    
    return Icon(
      iconData,
      size: 20,
      color: color,
    );
  }
  
  /// 构建操作按钮
  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    SyncState syncState,
    NetworkStatus networkStatus,
  ) {
    if (syncState.hasError || syncState.hasConflicts) {
      return TextButton(
        onPressed: () => _handleRetryAction(ref),
        style: TextButton.styleFrom(
          foregroundColor: _getTextColor(syncState, networkStatus),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: const Text('重试'),
      );
    }
    
    if (networkStatus == NetworkStatus.offline) {
      return TextButton(
        onPressed: () => _handleRefreshConnection(ref),
        style: TextButton.styleFrom(
          foregroundColor: _getTextColor(syncState, networkStatus),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: const Text('刷新'),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  /// 处理重试操作
  void _handleRetryAction(WidgetRef ref) {
    final syncService = ref.read(syncServiceProvider.notifier);
    syncService.manualSync();
  }
  
  /// 处理刷新连接
  void _handleRefreshConnection(WidgetRef ref) {
    final connectivityService = ref.read(connectivityServiceProvider.notifier);
    connectivityService.refresh();
  }
  
  /// 判断是否应该显示操作按钮
  bool _shouldShowAction(SyncState syncState, NetworkStatus networkStatus) {
    return syncState.hasError || 
           syncState.hasConflicts || 
           (networkStatus == NetworkStatus.offline && !syncState.hasError && !syncState.hasConflicts);
  }
  
  /// 获取状态图标
  IconData _getStatusIcon(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return Icons.cloud_off;
    if (syncState.hasError) return Icons.error_outline;
    if (syncState.hasConflicts) return Icons.warning_outlined;
    if (syncState.isLoading) return Icons.sync;
    if (syncState.hasPendingSync) return Icons.schedule;
    if (networkStatus == NetworkStatus.slow) return Icons.signal_wifi_bad;
    return Icons.cloud_done;
  }
  
  /// 获取背景颜色
  Color _getBackgroundColor(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return Colors.orange.shade50;
    if (syncState.hasError) return Colors.red.shade50;
    if (syncState.hasConflicts) return Colors.amber.shade50;
    if (syncState.isLoading) return Colors.blue.shade50;
    if (syncState.hasPendingSync) return Colors.indigo.shade50;
    if (networkStatus == NetworkStatus.slow) return Colors.yellow.shade50;
    return Colors.green.shade50;
  }
  
  /// 获取边框颜色
  Color _getBorderColor(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return Colors.orange.shade200;
    if (syncState.hasError) return Colors.red.shade200;
    if (syncState.hasConflicts) return Colors.amber.shade200;
    if (syncState.isLoading) return Colors.blue.shade200;
    if (syncState.hasPendingSync) return Colors.indigo.shade200;
    if (networkStatus == NetworkStatus.slow) return Colors.yellow.shade200;
    return Colors.green.shade200;
  }
  
  /// 获取图标颜色
  Color _getIconColor(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return Colors.orange.shade700;
    if (syncState.hasError) return Colors.red.shade700;
    if (syncState.hasConflicts) return Colors.amber.shade700;
    if (syncState.isLoading) return Colors.blue.shade700;
    if (syncState.hasPendingSync) return Colors.indigo.shade700;
    if (networkStatus == NetworkStatus.slow) return Colors.yellow.shade700;
    return Colors.green.shade700;
  }
  
  /// 获取文字颜色
  Color _getTextColor(SyncState syncState, NetworkStatus networkStatus) {
    return _getIconColor(syncState, networkStatus);
  }
  
  /// 获取状态标题
  String _getStatusTitle(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return '离线模式';
    if (syncState.hasError) return '同步失败';
    if (syncState.hasConflicts) return '数据冲突';
    if (syncState.isLoading) return '正在同步';
    if (syncState.hasPendingSync) return '待同步';
    if (networkStatus == NetworkStatus.slow) return '网络缓慢';
    return '已同步';
  }
  
  /// 获取状态副标题
  String? _getStatusSubtitle(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) {
      return '无网络连接，数据仅保存在本地';
    }
    
    if (syncState.hasError) {
      return syncState.error ?? '同步时发生错误';
    }
    
    if (syncState.hasConflicts) {
      return '有 ${syncState.conflictCount} 个冲突需要处理';
    }
    
    if (syncState.isLoading) {
      return syncState.statusMessage ?? '正在同步数据...';
    }
    
    if (syncState.hasPendingSync) {
      return '有 ${syncState.pendingSyncCount} 个项目等待同步';
    }
    
    if (networkStatus == NetworkStatus.slow) {
      return '网络连接缓慢，同步可能延迟';
    }
    
    return null;
  }
}

/// 迷你同步状态指示器
/// 
/// 用于在其他页面显示简化的同步状态
class MiniSyncIndicator extends ConsumerWidget {
  const MiniSyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncServiceProvider);
    final networkStatus = ref.watch(connectivityServiceProvider);
    
    if (!_shouldShow(syncState, networkStatus)) {
      return const SizedBox.shrink();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor(syncState, networkStatus).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getColor(syncState, networkStatus).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (syncState.isLoading)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                valueColor: AlwaysStoppedAnimation(_getColor(syncState, networkStatus)),
              ),
            )
          else
            Icon(
              _getMiniIcon(syncState, networkStatus),
              size: 12,
              color: _getColor(syncState, networkStatus),
            ),
          const SizedBox(width: 4),
          Text(
            _getMiniText(syncState, networkStatus),
            style: TextStyle(
              fontSize: 10,
              color: _getColor(syncState, networkStatus),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  bool _shouldShow(SyncState syncState, NetworkStatus networkStatus) {
    return networkStatus == NetworkStatus.offline ||
           syncState.isLoading ||
           syncState.hasError ||
           syncState.hasConflicts ||
           syncState.hasPendingSync;
  }
  
  Color _getColor(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return Colors.orange;
    if (syncState.hasError) return Colors.red;
    if (syncState.hasConflicts) return Colors.amber;
    if (syncState.isLoading) return Colors.blue;
    if (syncState.hasPendingSync) return Colors.indigo;
    return Colors.green;
  }
  
  IconData _getMiniIcon(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return Icons.cloud_off;
    if (syncState.hasError) return Icons.error;
    if (syncState.hasConflicts) return Icons.warning;
    if (syncState.hasPendingSync) return Icons.schedule;
    return Icons.sync;
  }
  
  String _getMiniText(SyncState syncState, NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.offline) return '离线';
    if (syncState.hasError) return '错误';
    if (syncState.hasConflicts) return '冲突';
    if (syncState.isLoading) return '同步中';
    if (syncState.hasPendingSync) return '待同步';
    return '已同步';
  }
}

// 在ConnectivityService中添加dismissIndicator方法的扩展
extension ConnectivityServiceExtension on ConnectivityService {
  void dismissIndicator() {
    // 此方法将在connectivity_service.dart中实现
  }
}
