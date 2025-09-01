# 网络层技术栈集成指南

## 概述

本项目已成功集成了现代化的网络技术栈，包括：

- **Dio**: 强大的 HTTP 客户端，支持拦截器、重试机制
- **Retrofit**: 类型安全的 API 客户端生成器
- **GraphQL**: 精确数据查询，减少数据传输量

## 架构图

```
UI层 → Riverpod状态管理 → Enhanced Repository → [Dio + Retrofit + GraphQL] → 后端服务
                                                ↓
                                        [监控 + 错误处理 + 重试机制]
```

## 主要组件

### 1. Dio HTTP 客户端 (`lib/network/dio_client.dart`)

```dart
// 获取单例实例
final dio = DioClient.instance;

// 自动包含的功能：
// - 认证令牌自动添加
// - 网络错误自动重试
// - 请求/响应日志记录
// - 性能监控
// - 错误统一处理
```

### 2. Retrofit API 接口 (`lib/network/api/`)

```dart
// 类型安全的 API 调用
final api = SubscriptionApi(DioClient.instance);

// 获取订阅列表
final subscriptions = await api.getSubscriptions(
  '*',
  userId,
  'eq.true',
  'created_at.desc',
);

// 创建新订阅
await api.createSubscription(request, 'return=representation');
```

### 3. GraphQL 查询服务 (`lib/network/graphql/`)

```dart
// GraphQL 查询服务
final graphqlService = GraphQLSubscriptionService();

// 精确数据查询
final subscriptions = await graphqlService.getSubscriptions(
  userId: userId,
  isActive: true,
);

// 实时订阅
graphqlService.subscribeToSubscriptionUpdates(userId)
  .listen((subscriptions) {
    // 处理实时更新
  });
```

### 4. 增强的 Repository (`lib/network/repositories/`)

```dart
// 支持 GraphQL 和 REST API 切换
final repository = EnhancedRemoteSubscriptionRepository(
  useGraphQL: true, // 优先使用 GraphQL，失败时降级到 REST API
);

// 基础 CRUD 操作
await repository.getAllSubscriptions();
await repository.addSubscription(subscription);
await repository.updateSubscription(subscription);
await repository.deleteSubscription(id);

// 高级功能
await repository.searchSubscriptions(query: '搜索关键词');
await repository.getUpcomingSubscriptions(daysAhead: 7);
await repository.getSubscriptionStats();
```

## 网络监控和错误处理

### 网络状态监控

```dart
final monitor = NetworkMonitorService();
await monitor.initialize();

// 监听网络状态
monitor.statusStream.listen((status) {
  if (status.isConnected) {
    print('网络已连接');
  } else {
    print('网络已断开');
  }
});

// 获取网络统计
final stats = monitor.statistics;
print('成功率: ${stats.successRate}');
print('平均响应时间: ${stats.averageResponseTime}ms');
```

### 自动错误处理

网络层自动处理以下错误类型：
- 连接超时/发送超时/接收超时
- HTTP 4xx/5xx 状态码
- 网络连接问题
- GraphQL 查询错误

所有错误都会转换为用户友好的错误消息。

### 自动重试机制

支持智能重试：
- 连接超时：自动重试最多 3 次
- 服务器错误 (5xx)：指数退避重试
- 网络问题：等待网络恢复后重试

## 使用示例

### 1. 在 Repository 中使用

```dart
class MySubscriptionRepository extends EnhancedRemoteSubscriptionRepository {
  
  Future<void> syncSubscriptions() async {
    try {
      // 优先使用 GraphQL，失败时自动降级到 REST API
      final subscriptions = await getAllSubscriptions();
      
      // 搜索功能
      final searchResults = await searchSubscriptions(
        query: '搜索词',
        limit: 20,
      );
      
      // 获取统计数据
      final stats = await getSubscriptionStats();
      
    } catch (e) {
      // 错误已经被转换为用户友好的消息
      print('同步失败: $e');
    }
  }
}
```

### 2. 在 UI 中使用

```dart
class SubscriptionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Subscription>>(
      future: ref.read(enhancedRepositoryProvider).getAllSubscriptions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // 显示用户友好的错误消息
          return ErrorWidget(snapshot.error.toString());
        }
        
        if (snapshot.hasData) {
          return SubscriptionList(subscriptions: snapshot.data!);
        }
        
        return const CircularProgressIndicator();
      },
    );
  }
}
```

### 3. 网络监控集成

```dart
class NetworkAwareWidget extends StatefulWidget {
  @override
  _NetworkAwareWidgetState createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  final _monitor = NetworkMonitorService();
  
  @override
  void initState() {
    super.initState();
    _monitor.initialize();
    
    // 监听网络状态
    _monitor.statusStream.listen((status) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status.isConnected ? '网络已连接' : '网络已断开'),
            backgroundColor: status.isConnected ? Colors.green : Colors.red,
          ),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI 内容
    );
  }
}
```

## 配置和自定义

### 1. 自定义 Dio 配置

```dart
// 修改 lib/network/dio_client.dart 中的配置
static Dio _createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: SupabaseConfig.supabaseUrl,
    connectTimeout: const Duration(seconds: 30), // 调整超时时间
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ));
  
  // 添加自定义拦截器
  dio.interceptors.add(CustomInterceptor());
  
  return dio;
}
```

### 2. 自定义重试策略

```dart
// 修改 lib/network/interceptors/retry_interceptor.dart
RetryInterceptor({
  this.maxRetries = 5,        // 增加重试次数
  this.retryDelay = const Duration(seconds: 2), // 调整重试延迟
  this.retryStatusCodes = const [500, 502, 503, 504, 408], // 自定义重试状态码
});
```

### 3. 自定义 GraphQL 查询

在 `lib/network/graphql/subscription_queries.dart` 中添加新的查询：

```dart
const String customQuery = r'''
  query CustomSubscriptionQuery($userId: UUID!) {
    subscriptionsCollection(
      filter: { user_id: { eq: $userId } }
    ) {
      edges {
        node {
          id
          name
          # 添加需要的字段
        }
      }
    }
  }
''';
```

## 性能优化建议

1. **使用 GraphQL 优先**: GraphQL 查询更精确，减少数据传输量
2. **启用缓存**: GraphQL 客户端自动缓存查询结果
3. **监控网络性能**: 使用 NetworkMonitorService 监控和优化
4. **错误重试**: 自动重试机制提高成功率
5. **批量操作**: 使用批量 API 减少请求次数

## 故障排除

### 常见问题

1. **编译错误**: 运行 `flutter packages pub run build_runner build --delete-conflicting-outputs`
2. **依赖冲突**: 检查 pubspec.yaml 中的版本约束
3. **网络连接问题**: 检查网络权限和防火墙设置
4. **认证失败**: 确保 Supabase 配置正确

### 调试技巧

1. 启用日志拦截器查看请求详情
2. 使用网络监控查看性能统计
3. 检查错误处理链确保异常被正确捕获
4. 使用 GraphQL 开发工具调试查询

## 示例代码

完整的集成示例请参考：`lib/network/examples/network_integration_example.dart`

该示例展示了：
- 如何加载和搜索订阅
- 网络状态监控
- 错误处理
- 性能统计显示
- UI 交互

## 下一步

1. 根据实际需求调整配置参数
2. 添加更多自定义 GraphQL 查询
3. 集成更多监控和分析功能
4. 优化错误处理和用户体验
5. 添加离线支持和数据同步