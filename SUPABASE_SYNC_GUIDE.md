# Supabase 账户和数据同步功能集成指南

## 概述

已成功为订阅管理器应用集成了完整的Supabase账户和数据同步功能。该实现提供了离线优先、冲突解决、实时同步的完整解决方案。

## 🏗️ 架构概览

### 核心组件
- **认证服务** (`AuthService`) - 用户注册、登录、登出
- **同步服务** (`SyncService`) - 数据同步、冲突解决、实时更新
- **连接监控** (`ConnectivityService`) - 网络状态监控和质量检测
- **混合Repository** (`HybridRepository`) - 本地+远程数据统一访问
- **数据迁移** (`MigrationService`) - 现有数据平滑迁移

### 技术栈
- **后端**: Supabase (PostgreSQL + 实时订阅)
- **状态管理**: Riverpod 3.0
- **本地存储**: Drift + Hive
- **网络监控**: connectivity_plus + internet_connection_checker

## 🚀 配置步骤

### 1. 创建Supabase项目
1. 访问 [Supabase Dashboard](https://supabase.com/dashboard)
2. 创建新项目
3. 在 Settings -> API 中获取：
   - Project URL
   - anon public key

### 2. 配置Supabase连接
编辑 `lib/config/supabase_config.dart`:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 3. 执行数据库Schema
在Supabase Dashboard的SQL编辑器中运行 `supabase_schema.sql`。

### 4. 安装依赖
```bash
flutter pub get
dart run build_runner build
```

## 📱 功能特性

### 用户认证
- ✅ 邮箱/密码注册登录
- ✅ 密码重置
- ✅ 用户状态管理
- ✅ 自动会话恢复

### 数据同步
- ✅ 离线优先策略
- ✅ 增量同步
- ✅ 实时数据更新
- ✅ 冲突自动解决
- ✅ 网络状态感知

### 用户界面
- ✅ 认证页面 (登录/注册)
- ✅ 同步状态指示器
- ✅ 用户资料页面
- ✅ 网络状态提示

## 🔧 使用方法

### 初始化应用
应用启动时会自动：
1. 初始化Supabase连接
2. 执行数据迁移
3. 恢复用户会话
4. 启动网络监控

### 用户操作
```dart
// 登录
final authService = ref.read(authServiceProvider.notifier);
await authService.signIn(email: email, password: password);

// 手动同步
final syncService = ref.read(syncServiceProvider.notifier);
await syncService.manualSync();

// 监听同步状态
ref.listen(syncServiceProvider, (previous, next) {
  // 处理同步状态变化
});
```

### UI集成
```dart
// 显示同步指示器
const SyncIndicator(),

// 迷你同步状态
const MiniSyncIndicator(),

// 认证页面
Navigator.push(context, MaterialPageRoute(
  builder: (context) => const AuthScreen(),
));
```

## 📊 数据流程

### 写入操作
1. 数据立即保存到本地
2. 标记为待同步状态
3. 网络可用时自动上传
4. 同步成功后更新状态

### 读取操作
1. 优先返回本地数据
2. 后台检查远程更新
3. 增量同步新数据
4. 实时接收远程变更

### 冲突处理
1. 自动检测数据冲突
2. 支持多种解决策略：
   - 时间戳优先
   - 服务器优先
   - 客户端优先
   - 智能合并
   - 用户选择

## 🔍 监控和调试

### 同步状态
- `syncState.isLoading` - 是否正在同步
- `syncState.hasError` - 是否有错误
- `syncState.hasConflicts` - 是否有冲突
- `syncState.pendingSyncCount` - 待同步项目数

### 网络状态
- `NetworkStatus.online` - 网络正常
- `NetworkStatus.offline` - 离线状态
- `NetworkStatus.slow` - 网络缓慢
- `NetworkStatus.unknown` - 状态未知

### 日志输出
应用会在控制台输出详细的同步日志，包括：
- 初始化状态
- 数据迁移进度
- 同步操作结果
- 错误信息

## 🛡️ 安全性

### 数据保护
- ✅ Row Level Security (RLS)
- ✅ 用户数据隔离
- ✅ 加密传输 (HTTPS)
- ✅ 客户端数据验证

### 权限控制
- 用户只能访问自己的数据
- 严格的数据库权限策略
- 客户端和服务端双重验证

## 🔄 数据迁移

### 自动迁移
应用启动时会自动：
1. 检查是否需要迁移
2. 将SharedPreferences数据迁移到Drift
3. 为数据添加同步支持字段
4. 标记迁移完成

### 手动操作
```dart
final migrationService = ref.read(migrationServiceProvider);

// 检查迁移状态
final needsMigration = await migrationService.shouldUploadExistingData();

// 强制迁移
await migrationService.checkAndMigrate();

// 重置迁移状态
await migrationService.resetUploadStatus();
```

## 📝 注意事项

### 首次使用
1. 配置Supabase连接信息
2. 执行数据库Schema
3. 测试网络连接
4. 验证数据迁移

### 生产部署
1. 使用生产环境Supabase配置
2. 禁用调试日志
3. 配置适当的同步间隔
4. 监控同步性能

### 故障排除
- 检查Supabase连接配置
- 验证数据库Schema是否正确
- 查看控制台错误日志
- 测试网络连接状态

## 🎯 后续优化

可以考虑的改进方向：
- 支持OAuth登录 (Google, Apple等)
- 批量数据操作优化
- 离线队列管理
- 数据压缩传输
- 更细粒度的冲突解决

---

该实现提供了完整的账户和数据同步功能，支持离线使用、自动同步、冲突解决等企业级特性。用户可以在多设备间无缝同步数据，享受现代化的云端服务体验。