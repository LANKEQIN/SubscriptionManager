import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

/// GraphQL 客户端管理器
/// 配置和管理 GraphQL 客户端实例
class GraphQLClientManager {
  static GraphQLClient? _instance;
  
  /// 获取 GraphQL 客户端单例实例
  static GraphQLClient get instance {
    _instance ??= _createClient();
    return _instance!;
  }
  
  /// 重置客户端实例
  static void reset() {
    _instance = null;
  }
  
  /// 创建和配置 GraphQL 客户端
  static GraphQLClient _createClient() {
    // HTTP 链接配置
    final httpLink = HttpLink(
      '${SupabaseConfig.supabaseUrl}/graphql/v1',
      defaultHeaders: {
        'apikey': SupabaseConfig.supabaseAnonKey,
        'Content-Type': 'application/json',
      },
    );
    
    // 认证链接配置
    final authLink = AuthLink(
      getToken: () async {
        final session = Supabase.instance.client.auth.currentSession;
        return session?.accessToken != null ? 'Bearer ${session!.accessToken}' : null;
      },
    );
    
    // WebSocket 链接配置（用于订阅）
    final wsLink = WebSocketLink(
      '${SupabaseConfig.supabaseUrl.replaceFirst('http', 'ws')}/graphql/v1',
      config: SocketClientConfig(
        autoReconnect: true,
        inactivityTimeout: const Duration(seconds: 30),
        initialPayload: {
          'apikey': SupabaseConfig.supabaseAnonKey,
        },
      ),
    );
    
    // 链接组合：认证 -> (HTTP 或 WebSocket)
    final link = Link.from([
      authLink,
      Link.split(
        (request) => request.isSubscription,
        wsLink,
        httpLink,
      ),
    ]);
    
    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
      defaultPolicies: DefaultPolicies(
        watchQuery: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
        ),
        query: Policies(
          fetch: FetchPolicy.cacheFirst,
        ),
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
        subscribe: Policies(
          fetch: FetchPolicy.noCache,
        ),
      ),
    );
  }
  
  /// 创建测试用的 GraphQL 客户端
  static GraphQLClient createTestClient({
    String? endpoint,
    Map<String, String>? headers,
  }) {
    final httpLink = HttpLink(
      endpoint ?? 'http://localhost:3000/graphql',
      defaultHeaders: headers ?? {'Content-Type': 'application/json'},
    );
    
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }
}