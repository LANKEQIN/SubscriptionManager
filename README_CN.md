# Subscription Manager 订阅管理器

A subscription management app to track and manage your subscriptions.

This README is also available in [English](README.md#english).

<span id="chinese"></span>
## 中文

Subscription Manager 是一款使用 Flutter 构建的跨平台移动应用，旨在帮助用户高效地跟踪和管理他们的订阅。该应用允许用户在一个地方添加、编辑和监控他们的各种订阅，并提供通知、统计和简洁的 Material Design 3 界面等功能。

### 功能特性

#### 核心订阅管理
- **订阅 CRUD**: 创建、读取、更新和删除订阅，并提供完整的验证功能
- **多币种支持**: 使用固定汇率服务跟踪不同币种的订阅
- **订阅统计**: 全面的支出分析，包括分类明细和趋势
- **搜索与筛选**: 按名称、类别、价格和状态进行高级搜索和筛选
- **数据导出**: 将订阅数据导出为 CSV 格式，以便进行外部部分析

#### 用户体验与界面
- **Material Design 3**: 现代化的用户界面，支持动态主题和自适应系统颜色
- **深色/浅色主题**: 完全支持浅色和深色主题，并可自动检测系统设置
- **响应式设计**: 针对各种屏幕尺寸和设备方向进行了优化
- **HarmonyOS Sans 字体**: 自定义字体，提高了可读性
- **无障碍性**: 符合 WCAG 2.1 标准的无障碍功能和屏幕阅读器支持

#### 数据管理与同步
- **离线优先**: 使用本地数据库，无需互联网连接即可实现全部功能
- **云同步**: 与 Supabase 云后端自动进行双向同步
- **冲突解决**: 同步过程中的智能冲突检测与解决
- **数据迁移**: 支持从旧格式进行模式迁移和数据转换
- **实时更新**: 通过 Supabase 实时订阅实现实时数据更新
- **智能缓存**: 具有可配置过期策略的多级缓存策略

#### 认证与安全
- **用户认证**: 使用 Supabase Auth 实现安全注册、登录和注销
- **会话管理**: 自动会话持久化和令牌刷新
- **数据隔离**: 用户特定数据的隔离和隐私保护
- **安全存储**: 对敏感信息进行加密本地存储

#### 网络与性能
- **混合网络**: REST API (Dio + Retrofit) 和 GraphQL 集成
- **网络监控**: 全面的网络状态和性能监控
- **请求拦截器**: 认证、日志、错误处理、重试和监控拦截器
- **连接管理**: 自动处理网络连接变化
- **性能优化**: 优化数据加载和渲染性能

#### 高级功能
- **通知系统**: 在订阅续订前提供可配置的提醒
- **预算跟踪**: 支出限制和预算监控功能
- **类别管理**: 带颜色编码的自定义订阅类别
- **支付跟踪**: 付款历史和即将到来的付款计划
- **收据管理**: 支持附加和存储订阅收据
- **订阅分析**: 带有图表和可视化的订阅高级分析
- **备份与恢复**: 数据备份和恢复功能
- **多语言支持**: 国际化和本地化基础设施（计划中）

#### 开发者体验
- **代码生成**: 广泛使用代码生成以减少样板代码
- **类型安全**: 使用 Dart 的强类型系统实现完全的类型安全
- **测试基础设施**: 包含单元、小部件和集成测试的全面测试套件
- **调试工具**: 通过日志和错误报告增强调试能力
- **热重载**: 通过 Flutter 的热重载功能实现快速开发周期
- **代码混淆**: 通过 Dart 代码混淆为发布版本增强安全性

### 应用截图

| 主屏幕 | 统计 | 通知 | 添加订阅 |
|-------------|------------|---------------|------------------|
| ![主屏幕](screenshots/home.jpg) | ![统计](screenshots/stats.jpg) | ![通知](screenshots/notifications.jpg) | ![添加订阅](screenshots/add.jpg) |

### 技术栈

- **Flutter SDK** 与 Dart 3.0+
- **Riverpod** 用于现代状态管理，支持代码生成
- **Drift (SQLite)** 用于本地数据库，支持 ORM 和代码生成
- **Hive** 用于快速本地缓存，支持代码生成
- **Supabase** 用于云同步、认证和实时更新
- **Dio + Retrofit** 用于 REST API 客户端，支持拦截器和代码生成
- **GraphQL** 用于通过 GraphQL Flutter 高效查询数据
- **Freezed** 用于不可变数据类、模式匹配和 JSON 序列化
- **Dynamic Color** 用于 Material Design 3 主题，支持动态系统颜色
- **Connectivity Plus** 用于通过 Internet Connection Checker 监控网络状态
- **Pie Chart** 用于数据可视化
- **Shared Preferences** 用于持久化本地存储
- **UUID** 用于生成唯一标识符
- **Flutter Dotenv** 用于环境变量管理
- **Flutter Bloc** 用于功能模块中的状态管理
- **Flutter Launcher Icons** 用于生成应用图标

### 快速开始

#### 环境要求

- Flutter SDK 3.0 或更高版本
- Dart 3.0 或更高版本
- Supabase 账户，用于云同步（可选）

#### 环境设置

1.  **克隆仓库**
    ```bash
    git clone https://github.com/your-username/subscription-manager.git
    cd subscription-manager
    ```

2.  **复制环境文件**
    ```bash
    cp .env.example .env
    ```

3.  **配置环境变量**
    编辑 `.env` 文件，填入您的 Supabase 凭据：
    ```
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```

4.  **安装依赖**
    ```bash
    flutter pub get
    ```

5.  **生成代码**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

6.  **运行应用**
    ```bash
    flutter run
    ```

#### 构建生产版本

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

#### 使用代码混淆进行构建

要构建启用了代码混淆的应用以增强安全性：

```bash
# Android (带混淆)
flutter build apk --obfuscate --split-debug-info=./build/symbols
flutter build appbundle --obfuscate --split-debug-info=./build/symbols

# iOS (带混淆)
flutter build ios --obfuscate --split-debug-info=./build/symbols

# 其他平台 (带混淆)
flutter build ipa --obfuscate --split-debug-info=./build/symbols
flutter build windows --obfuscate --split-debug-info=./build/symbols
```

为方便起见，您也可以使用提供的构建脚本：
- Windows: `scripts\build-obfuscated.bat`
- macOS/Linux: `scripts/build-obfuscated.sh`

用于调试混淆构建的符号文件存储在 `./build/symbols` 目录中。请备份这些文件以备将来调试之需。

### 项目结构

```
lib/
├── cache/
│   ├── cached_data.dart
│   ├── cached_data.g.dart
│   ├── hive_service.dart
│   └── smart_cache_manager.dart
├── config/
│   ├── supabase_config.dart
│   └── theme_builder.dart
├── constants/
│   └── theme_constants.dart
├── core/
│   ├── data/
│   │   ├── datasources/
│   │   ├── models/
│   │   └── repositories/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   └── presentation/
│       ├── blocs/
│       ├── screens/
│       └── widgets/
├── database/
│   ├── app_database.dart
│   ├── app_database.g.dart
│   └── tables.dart
├── dialogs/
│   ├── add_subscription_dialog.dart
│   ├── base_subscription_dialog.dart
│   ├── edit_subscription_dialog.dart
│   └── subscription_form.dart
├── examples/
├── features/
│   ├── subscription_feature/
│   │   ├── data/
│   │   ├── di/
│   │   ├── domain/
│   │   └── presentation/
│   └── user_profile_feature/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── fixed_exchange_rate_service.dart
├── main.dart
├── models/
│   ├── monthly_history.dart
│   ├── monthly_history.freezed.dart
│   ├── subscription.dart
│   ├── subscription.freezed.dart
│   ├── subscription_state.dart
│   ├── subscription_state.freezed.dart
│   ├── sync_state.dart
│   ├── sync_state.freezed.dart
│   ├── sync_types.dart
│   ├── user_profile.dart
│   └── user_profile.freezed.dart
├── network/
│   ├── api/
│   │   ├── auth_api.dart
│   │   ├── auth_api.g.dart
│   │   ├── subscription_api.dart
│   │   └── subscription_api.g.dart
│   ├── dio_client.dart
│   ├── dto/
│   │   ├── auth_responses.dart
│   │   ├── auth_responses.g.dart
│   │   ├── subscription_dto.dart
│   │   ├── subscription_dto.g.dart
│   │   ├── subscription_requests.dart
│   │   ├── subscription_requests.g.dart
│   │   ├── subscription_responses.dart
│   │   └── subscription_responses.g.dart
│   ├── error/
│   │   ├── network_error_handler.dart
│   │   ├── network_exception.dart
│   │   └── network_exception.freezed.dart
│   ├── examples/
│   ├── graphql/
│   │   ├── subscription_queries.dart
│   │   └── subscription_service.dart
│   ├── graphql_client.dart
│   ├── interceptors/
│   │   ├── auth_interceptor.dart
│   │   ├── error_interceptor.dart
│   │   ├── logging_interceptor.dart
│   │   ├── monitoring_interceptor.dart
│   │   └── retry_interceptor.dart
│   ├── monitoring/
│   │   └── network_monitor_service.dart
│   └── repositories/
│       └── enhanced_remote_subscription_repository.dart
├── providers/
│   ├── app_providers.dart
│   ├── app_providers.g.dart
│   ├── subscription_notifier.dart
│   └── subscription_notifier.g.dart
├── repositories/
│   ├── error_handler.dart
│   ├── hybrid_subscription_repository.dart
│   ├── hybrid_subscription_repository.g.dart
│   ├── monthly_history_repository_impl.dart
│   ├── remote_subscription_repository.dart
│   ├── repository_interfaces.dart
│   └── subscription_repository_impl.dart
├── screens/
│   ├── auth_screen.dart
│   ├── home_app_bar.dart
│   ├── home_screen.dart
│   ├── large_screen_home.dart
│   ├── large_screen_notifications.dart
│   ├── large_screen_profile.dart
│   ├── large_screen_statistics.dart
│   ├── monthly_history.dart
│   ├── notifications_screen.dart
│   ├── profile_screen.dart
│   └── statistics_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── auth_service.g.dart
│   ├── conflict_resolver.dart
│   ├── conflict_resolver.g.dart
│   ├── connectivity_service.dart
│   ├── connectivity_service.g.dart
│   ├── migration_service.dart
│   ├── migration_service.g.dart
│   ├── sync_service.dart
│   └── sync_service.g.dart
├── utils/
│   ├── app_logger.dart
│   ├── currency_constants.dart
│   ├── icon_picker.dart
│   ├── icon_utils.dart
│   ├── responsive_layout.dart
│   ├── subscription_constants.dart
│   └── user_preferences.dart
└── widgets/
    ├── add_button.dart
    ├── large_screen_layout.dart
    ├── large_screen_navigation.dart
    ├── statistics_card.dart
    ├── subscription_card.dart
    ├── subscription_.dart
    └── sync_indicator.dart
```

### 架构概述

本应用遵循清晰的关注点分离和功能优先的模块化原则，采用整洁架构模式：

1.  **表示层**: 使用 Riverpod 进行状态管理的 UI 屏幕、小部件和对话框
    -   主应用视图的屏幕
    -   可重用的小部件组件
    -   用于用户交互的模态对话框
    -   用于响应式状态管理的 Riverpod 提供者

2.  **领域层**: 业务逻辑、用例和领域模型
    -   具有模式匹配的 Freezed 不可变数据模型
    -   定义数据契约的存储库接口
    -   业务逻辑服务（同步、认证、迁移、冲突解决）
    -   封装业务规则的用例

3.  **数据层**: 实现混合数据源的存储库
    -   **本地存储**: 使用 Drift ORM 和 SQLite 进行持久化数据存储
    -   **本地缓存**: 使用 Hive 进行快速内存缓存和智能缓存管理
    -   **远程数据**: 与 Supabase 集成，支持 REST API (Dio + Retrofit) 和 GraphQL
    -   **混合存储库**: 协调本地和远程数据源，并解决冲突

4.  **基础设施层**: 核心基础设施组件
    -   **网络层**: Dio HTTP 客户端，带有拦截器（认证、日志、错误、监控、重试）
    -   **数据库**: 支持代码生成和迁移的 Drift 数据库
    -   **缓存**: 具有智能缓存策略和过期策略的 Hive
    -   **配置**: 环境变量和 Supabase 配置
    -   **监控**: 具有性能跟踪的网络监控服务

#### 功能优先的模块化架构：

该应用还实现了功能优先的模块化架构：
-   **订阅功能模块**: 完整的订阅管理功能
-   **用户资料功能模块**: 用户认证和资料管理
-   每个功能模块都包含自己的数据、领域和表示层
-   在功能模块中使用 BLoC 模式进行状态管理
-   每个功能模块都配置了依赖注入

#### 关键架构特性：

-   **混合数据策略**: 本地优先方法，支持自动云同步
-   **智能缓存**: 具有可配置过期策略的多级缓存
-   **依赖注入**: 使用 Riverpod 提供者实现松耦合和可测试性
-   **全面的错误处理**: 所有层统一的错误处理
-   **完全离线支持**: 无需互联网连接即可实现全部功能
-   **自动冲突解决**: 智能数据同步和冲突解决
-   **数据迁移**: 支持模式迁移和数据转换
-   **实时更新**: 通过 Supabase 实时订阅实现实时数据更新
-   **性能监控**: 通过指标收集进行网络和性能监控
-   **模块化设计**: 基于功能的可扩展模块化架构

### 贡献

欢迎贡献！请随时提交拉取请求。

#### 开发设置

1.  Fork 本仓库
2.  创建您的功能分支 (`git checkout -b feature/AmazingFeature`)
3.  安装依赖并生成代码：
    ```bash
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  提交您的更改 (`git commit -m 'Add some AmazingFeature'`)
5.  推送到分支 (`git push origin feature/AmazingFeature`)
6.  打开一个拉取请求

#### 代码生成

本项目使用了多种代码生成工具：
-   `build_runner` 用于 Freezed、JSON 序列化和 Riverpod 代码生成
-   `drift_dev` 用于数据库代码生成
-   `retrofit_generator` 用于 API 客户端生成

在修改以下内容后，请务必运行代码生成：
-   数据模型 (`@freezed` 类)
-   数据库表
-   API 客户端
-   Riverpod 提供者