/// 同步状态枚举
enum SyncStatus { 
  synced,     // 已同步
  pending,    // 待上传
  conflict,   // 有冲突
  error       // 同步失败
}

/// 冲突解决策略
enum ConflictStrategy {
  lastModified,  // 按最后修改时间
  serverWins,    // 服务器优先
  clientWins,    // 客户端优先
  userChoice,    // 用户选择
  merge          // 智能合并
}

/// 同步配置常量
class SyncConstants {
  static const Duration syncInterval = Duration(minutes: 5);
  static const Duration retryDelay = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const Duration networkTimeout = Duration(seconds: 30);
}

/// 网络状态枚举
enum NetworkStatus {
  online,
  offline,
  slow,
  unknown
}