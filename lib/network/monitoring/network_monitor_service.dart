import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../utils/app_logger.dart';

/// 网络监控服务
/// 监控网络状态、请求性能和错误统计
class NetworkMonitorService {
  static final NetworkMonitorService _instance = NetworkMonitorService._internal();
  factory NetworkMonitorService() => _instance;
  NetworkMonitorService._internal();
  
  final Connectivity _connectivity = Connectivity();
  final StreamController<NetworkStatus> _statusController = 
      StreamController<NetworkStatus>.broadcast();
  
  ConnectivityResult _currentConnectivity = ConnectivityResult.none;
  bool _isConnected = false;
  
  // 性能监控
  int _totalRequests = 0;
  int _successfulRequests = 0;
  int _failedRequests = 0;
  final List<RequestMetrics> _recentRequests = [];
  final int _maxRecentRequests = 100;
  
  // 错误统计
  final Map<String, int> _errorCounts = {};
  final List<NetworkError> _recentErrors = [];
  final int _maxRecentErrors = 50;
  
  /// 网络状态流
  Stream<NetworkStatus> get statusStream => _statusController.stream;
  
  /// 当前网络连接状态
  bool get isConnected => _isConnected;
  
  /// 当前连接类型
  ConnectivityResult get currentConnectivity => _currentConnectivity;
  
  /// 请求统计
  NetworkStatistics get statistics => NetworkStatistics(
    totalRequests: _totalRequests,
    successfulRequests: _successfulRequests,
    failedRequests: _failedRequests,
    successRate: _totalRequests > 0 ? _successfulRequests / _totalRequests : 0.0,
    averageResponseTime: _calculateAverageResponseTime(),
    errorCounts: Map.from(_errorCounts),
  );
  
  /// 初始化监控服务
  Future<void> initialize() async {
    // 监听连接状态变化
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
    
    // 检查初始连接状态
    final result = await _connectivity.checkConnectivity();
    await _onConnectivityChanged(result);
  }
  
  /// 销毁监控服务
  void dispose() {
    _statusController.close();
  }
  
  /// 记录请求开始
  String startRequest(String url, String method) {
    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    _totalRequests++;
    
    final metrics = RequestMetrics(
      id: requestId,
      url: url,
      method: method,
      startTime: DateTime.now(),
    );
    
    _recentRequests.add(metrics);
    if (_recentRequests.length > _maxRecentRequests) {
      _recentRequests.removeAt(0);
    }
    
    return requestId;
  }
  
  /// 记录请求成功
  void recordRequestSuccess(String requestId, int statusCode, int responseSize) {
    _successfulRequests++;
    
    final metrics = _findRequestMetrics(requestId);
    if (metrics != null) {
      metrics.endTime = DateTime.now();
      metrics.statusCode = statusCode;
      metrics.responseSize = responseSize;
      metrics.success = true;
    }
  }
  
  /// 记录请求失败
  void recordRequestFailure(
    String requestId, 
    String errorType, 
    String errorMessage,
    int? statusCode,
  ) {
    _failedRequests++;
    
    final metrics = _findRequestMetrics(requestId);
    if (metrics != null) {
      metrics.endTime = DateTime.now();
      metrics.statusCode = statusCode;
      metrics.success = false;
      metrics.errorType = errorType;
      metrics.errorMessage = errorMessage;
    }
    
    // 记录错误统计
    _errorCounts[errorType] = (_errorCounts[errorType] ?? 0) + 1;
    
    // 记录详细错误
    final error = NetworkError(
      timestamp: DateTime.now(),
      url: metrics?.url ?? 'unknown',
      method: metrics?.method ?? 'unknown',
      errorType: errorType,
      errorMessage: errorMessage,
      statusCode: statusCode,
    );
    
    _recentErrors.add(error);
    if (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeAt(0);
    }
  }
  
  /// 检查网络连接
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  /// 获取最近的错误
  List<NetworkError> getRecentErrors({int? limit}) {
    final errors = List<NetworkError>.from(_recentErrors.reversed);
    if (limit != null && limit < errors.length) {
      return errors.take(limit).toList();
    }
    return errors;
  }
  
  /// 获取最近的请求指标
  List<RequestMetrics> getRecentRequests({int? limit}) {
    final requests = List<RequestMetrics>.from(_recentRequests.reversed);
    if (limit != null && limit < requests.length) {
      return requests.take(limit).toList();
    }
    return requests;
  }
  
  /// 清除统计数据
  void clearStatistics() {
    _totalRequests = 0;
    _successfulRequests = 0;
    _failedRequests = 0;
    _recentRequests.clear();
    _errorCounts.clear();
    _recentErrors.clear();
  }
  
  /// 处理连接状态变化
  Future<void> _onConnectivityChanged(ConnectivityResult result) async {
    _currentConnectivity = result;
    
    final wasConnected = _isConnected;
    _isConnected = result != ConnectivityResult.none;
    
    // 如果连接状态发生变化，进行实际网络检查
    if (_isConnected) {
      _isConnected = await checkInternetConnection();
    }
    
    final status = NetworkStatus(
      isConnected: _isConnected,
      connectivityResult: result,
      timestamp: DateTime.now(),
    );
    
    _statusController.add(status);
    
    // 记录连接状态变化
    if (wasConnected != _isConnected) {
      AppLogger.i('网络状态变化: ${_isConnected ? "已连接" : "已断开"} ($result)');
    }
  }
  
  /// 查找请求指标
  RequestMetrics? _findRequestMetrics(String requestId) {
    try {
      return _recentRequests.firstWhere((metrics) => metrics.id == requestId);
    } catch (e) {
      return null;
    }
  }
  
  /// 计算平均响应时间
  double _calculateAverageResponseTime() {
    final completedRequests = _recentRequests
        .where((metrics) => metrics.endTime != null)
        .toList();
    
    if (completedRequests.isEmpty) return 0.0;
    
    final totalTime = completedRequests
        .map((metrics) => metrics.responseTime)
        .reduce((a, b) => a + b);
    
    return totalTime / completedRequests.length;
  }
}

/// 网络状态信息
class NetworkStatus {
  final bool isConnected;
  final ConnectivityResult connectivityResult;
  final DateTime timestamp;
  
  NetworkStatus({
    required this.isConnected,
    required this.connectivityResult,
    required this.timestamp,
  });
}

/// 网络统计信息
class NetworkStatistics {
  final int totalRequests;
  final int successfulRequests;
  final int failedRequests;
  final double successRate;
  final double averageResponseTime;
  final Map<String, int> errorCounts;
  
  NetworkStatistics({
    required this.totalRequests,
    required this.successfulRequests,
    required this.failedRequests,
    required this.successRate,
    required this.averageResponseTime,
    required this.errorCounts,
  });
}

/// 请求指标
class RequestMetrics {
  final String id;
  final String url;
  final String method;
  final DateTime startTime;
  
  DateTime? endTime;
  int? statusCode;
  int? responseSize;
  bool success = false;
  String? errorType;
  String? errorMessage;
  
  RequestMetrics({
    required this.id,
    required this.url,
    required this.method,
    required this.startTime,
  });
  
  /// 响应时间（毫秒）
  double get responseTime {
    if (endTime == null) return 0.0;
    return endTime!.difference(startTime).inMilliseconds.toDouble();
  }
}

/// 网络错误记录
class NetworkError {
  final DateTime timestamp;
  final String url;
  final String method;
  final String errorType;
  final String errorMessage;
  final int? statusCode;
  
  NetworkError({
    required this.timestamp,
    required this.url,
    required this.method,
    required this.errorType,
    required this.errorMessage,
    this.statusCode,
  });
}