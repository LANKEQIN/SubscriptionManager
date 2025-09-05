import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/sync_types.dart';

part 'connectivity_service.g.dart';

/// 网络连接服务
/// 
/// 监控网络连接状态并提供连接状态信息
@riverpod
class ConnectivityService extends _$ConnectivityService {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Timer? _networkCheckTimer;
  final Set<NetworkStatus> _dismissedStatus = <NetworkStatus>{};
  
  @override
  NetworkStatus build() {
    _startConnectivityMonitoring();
    return NetworkStatus.unknown;
  }
  
  /// 开始监控网络连接状态
  void _startConnectivityMonitoring() {
    // 监听连接状态变化
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (results) {
        final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
        _handleConnectivityChange(result);
      },
      onError: (error) {
        debugPrint('连接监控错误: $error');
        state = NetworkStatus.unknown;
      },
    );
    
    // 初始检查网络状态
    _checkInitialConnectivity();
    
    // 定期检查网络质量
    _startNetworkQualityCheck();
  }
  
  /// 检查初始网络连接状态
  Future<void> _checkInitialConnectivity() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      final result = connectivityResults.isNotEmpty ? connectivityResults.first : ConnectivityResult.none;
      await _handleConnectivityChange(result);
    } catch (e) {
      debugPrint('初始连接检查错误: $e');
      state = NetworkStatus.unknown;
    }
  }
  
  /// 处理连接状态变化
  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.none:
        // 检查是否已关闭离线状态的显示
        if (!_dismissedStatus.contains(NetworkStatus.offline)) {
          state = NetworkStatus.offline;
        } else {
          state = NetworkStatus.unknown; // 保持隐藏状态
        }
        _stopNetworkQualityCheck();
        break;
      case ConnectivityResult.mobile:
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
        // 有连接，但需要验证实际网络可达性
        final hasInternet = await _verifyInternetConnection();
        if (hasInternet) {
          // 检查网络质量
          final quality = await _checkNetworkQuality();
          // 检查是否已关闭该状态的显示
          if (!_dismissedStatus.contains(quality)) {
            state = quality;
          } else {
            state = NetworkStatus.unknown; // 保持隐藏状态
          }
          _startNetworkQualityCheck();
        } else {
          // 检查是否已关闭离线状态的显示
          if (!_dismissedStatus.contains(NetworkStatus.offline)) {
            state = NetworkStatus.offline;
          } else {
            state = NetworkStatus.unknown; // 保持隐藏状态
          }
          _stopNetworkQualityCheck();
        }
        break;
      default:
        state = NetworkStatus.unknown;
        break;
    }
  }
  
  /// 验证实际的网络连接
  Future<bool> _verifyInternetConnection() async {
    try {
      final checker = InternetConnectionChecker.createInstance();
      return await checker.hasConnection;
    } catch (e) {
      debugPrint('网络验证错误: \$e');
      return false;
    }
  }
  
  /// 检查网络质量
  Future<NetworkStatus> _checkNetworkQuality() async {
    try {
      final stopwatch = Stopwatch()..start();
      
      // 简单的ping测试
      final checker = InternetConnectionChecker.createInstance();
      final hasConnection = await checker.hasConnection;
      
      stopwatch.stop();
      
      if (!hasConnection) {
        // 检查是否已关闭离线状态的显示
        if (!_dismissedStatus.contains(NetworkStatus.offline)) {
          return NetworkStatus.offline;
        }
        return NetworkStatus.unknown; // 保持隐藏状态
      }
      
      // 根据响应时间判断网络质量
      final responseTime = stopwatch.elapsedMilliseconds;
      
      if (responseTime > 3000) {
        return NetworkStatus.slow;
      } else {
        return NetworkStatus.online;
      }
    } catch (e) {
      debugPrint('网络质量检查错误: \$e');
      return NetworkStatus.unknown;
    }
  }
  
  /// 开始定期网络质量检查
  void _startNetworkQualityCheck() {
    _stopNetworkQualityCheck(); // 确保没有重复的定时器
    
    _networkCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) async {
        if (state != NetworkStatus.offline) {
          final quality = await _checkNetworkQuality();
          // 检查是否已关闭该状态的显示
          if (!_dismissedStatus.contains(quality) && quality != state) {
            state = quality;
          }
        }
      },
    );
  }
  
  /// 停止网络质量检查
  void _stopNetworkQualityCheck() {
    _networkCheckTimer?.cancel();
    _networkCheckTimer = null;
  }
  
  /// 手动刷新网络状态
  Future<void> refresh() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final result = connectivityResults.isNotEmpty ? connectivityResults.first : ConnectivityResult.none;
    await _handleConnectivityChange(result);
  }
  
  /// 关闭当前状态指示器显示
  void dismissIndicator() {
    _dismissedStatus.add(state);
    state = NetworkStatus.unknown; // 设置为unknown以隐藏指示器
  }
  
  /// 检查是否在线
  bool get isOnline => state == NetworkStatus.online;
  
  /// 检查是否离线
  bool get isOffline => state == NetworkStatus.offline;
  
  /// 检查网络是否缓慢
  bool get isSlow => state == NetworkStatus.slow;
  
  /// 检查网络是否可用（在线或缓慢）
  bool get isConnected => isOnline || isSlow;
  
  /// 获取网络状态描述
  String get statusDescription {
    switch (state) {
      case NetworkStatus.online:
        return '网络连接正常';
      case NetworkStatus.offline:
        return '网络连接断开';
      case NetworkStatus.slow:
        return '网络连接缓慢';
      case NetworkStatus.unknown:
        return '网络状态未知';
    }
  }
  
  /// 获取网络状态图标
  String get statusIcon {
    switch (state) {
      case NetworkStatus.online:
        return '🟢';
      case NetworkStatus.offline:
        return '🔴';
      case NetworkStatus.slow:
        return '🟡';
      case NetworkStatus.unknown:
        return '⚪';
    }
  }
  
  /// 销毁服务
  void dispose() {
    _connectivitySubscription.cancel();
    _stopNetworkQualityCheck();
  }
}

/// 网络连接事件类型
enum NetworkEvent {
  connected,
  disconnected,
  qualityChanged,
}

/// 网络连接事件
class NetworkConnectivityEvent {
  final NetworkEvent type;
  final NetworkStatus status;
  final DateTime timestamp;
  
  NetworkConnectivityEvent({
    required this.type,
    required this.status,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  @override
  String toString() {
    return 'NetworkEvent(type: $type, status: $status, time: $timestamp)';
  }
}

/// 网络连接监听器 Provider
@riverpod
Stream<NetworkConnectivityEvent> networkEvents(Ref ref) async* {
  NetworkStatus? previousStatus;
  
  // 监听网络状态变化
  await for (final status in Stream.periodic(const Duration(seconds: 1), (_) => ref.read(connectivityServiceProvider))) {
    if (previousStatus != status) {
      NetworkEvent eventType;
      
      if (previousStatus == null) {
        eventType = NetworkEvent.qualityChanged;
      } else if (previousStatus == NetworkStatus.offline && status != NetworkStatus.offline) {
        eventType = NetworkEvent.connected;
      } else if (previousStatus != NetworkStatus.offline && status == NetworkStatus.offline) {
        eventType = NetworkEvent.disconnected;
      } else {
        eventType = NetworkEvent.qualityChanged;
      }
      
      yield NetworkConnectivityEvent(
        type: eventType,
        status: status,
      );
      
      previousStatus = status;
    }
  }
}