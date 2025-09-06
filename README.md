# Subscription Manager 订阅管理器

A subscription management app to track and manage your subscriptions.

本README文件的中文版本可在 [README_CN.md](README_CN.md) 中查看。

<span id="english"></span>
## English

Subscription Manager is a cross-platform mobile application built with Flutter that helps users track and manage their subscriptions efficiently. The app allows users to add, edit, and monitor their various subscriptions in one place, with features like notifications, statistics, and a clean Material Design 3 interface.

### Features

#### Core Subscription Management
- **Subscription CRUD**: Create, read, update, and delete subscriptions with full validation
- **Multi-Currency Support**: Track subscriptions in different currencies with fixed exchange rate service
- **Subscription Statistics**: Comprehensive spending analytics with category breakdowns and trends
- **Search & Filter**: Advanced search and filtering capabilities by name, category, price, and status
- **Data Export**: Export subscription data to CSV format for external analysis

#### User Experience & Interface
- **Material Design 3**: Modern UI with dynamic theming and adaptive system colors
- **Dark/Light Theme**: Full support for both light and dark themes with automatic system detection
- **Responsive Design**: Optimized for various screen sizes and device orientations
- **HarmonyOS Sans Font**: Custom typography with improved readability
- **Accessibility**: WCAG 2.1 compliant accessibility features and screen reader support

#### Data Management & Synchronization
- **Offline-First**: Complete functionality without internet connection using local database
- **Cloud Synchronization**: Automatic bi-directional sync with Supabase cloud backend
- **Conflict Resolution**: Intelligent conflict detection and resolution during synchronization
- **Data Migration**: Support for schema migrations and data transformation from legacy formats
- **Real-time Updates**: Live data updates through Supabase real-time subscriptions
- **Smart Caching**: Multi-level caching strategy with configurable expiration policies

#### Authentication & Security
- **User Authentication**: Secure registration, login, and logout using Supabase Auth
- **Session Management**: Automatic session persistence and token refresh
- **Data Isolation**: User-specific data isolation and privacy protection
- **Secure Storage**: Encrypted local storage for sensitive information

#### Network & Performance
- **Hybrid Networking**: REST API (Dio + Retrofit) and GraphQL integration
- **Network Monitoring**: Comprehensive network status and performance monitoring
- **Request Interceptors**: Auth, logging, error handling, retry, and monitoring interceptors
- **Connection Management**: Automatic handling of network connectivity changes
- **Performance Optimization**: Optimized data loading and rendering performance

#### Advanced Features
- **Notification System**: Configurable reminders before subscription renewals
- **Budget Tracking**: Spending limits and budget monitoring capabilities
- **Category Management**: Custom subscription categories with color coding
- **Payment Tracking**: Payment history and upcoming payment scheduling
- **Receipt Management**: Support for attaching and storing subscription receipts
- **Subscription Analytics**: Advanced analytics with charts and visualizations
- **Backup & Restore**: Data backup and restore functionality
- **Multi-language Support**: Internationalization and localization infrastructure (planned)

#### Developer Experience
- **Code Generation**: Extensive use of code generation for boilerplate reduction
- **Type Safety**: Full type safety with Dart's strong typing system
- **Testing Infrastructure**: Comprehensive test suite with unit, widget, and integration tests
- **Debug Tools**: Enhanced debugging capabilities with logging and error reporting
- **Hot Reload**: Fast development cycle with Flutter's hot reload feature
- **Code Obfuscation**: Enhanced security through Dart code obfuscation for release builds

### Screenshots

| Home Screen | Statistics | Notifications | Add Subscription |
|-------------|------------|---------------|------------------|
| ![Home Screen](screenshots/home.jpg) | ![Statistics](screenshots/stats.jpg) | ![Notifications](screenshots/notifications.jpg) | ![Add Subscription](screenshots/add.jpg) |

### Tech Stack

- **Flutter SDK** with Dart 3.0+
- **Riverpod** for modern state management with code generation
- **Drift (SQLite)** for local database with ORM support and code generation
- **Hive** for fast local caching with code generation
- **Supabase** for cloud synchronization, authentication, and real-time updates
- **Dio + Retrofit** for REST API client with interceptors and code generation
- **GraphQL** for efficient data querying with GraphQL Flutter
- **Freezed** for immutable data classes, pattern matching, and JSON serialization
- **Dynamic Color** for Material Design 3 theming with dynamic system colors
- **Connectivity Plus** for network status monitoring with Internet Connection Checker
- **Pie Chart** for data visualization
- **Shared Preferences** for persistent local storage
- **UUID** for unique identifier generation
- **Flutter Dotenv** for environment variable management
- **Flutter Bloc** for state management in feature modules
- **Flutter Launcher Icons** for app icon generation

### Getting Started

#### Prerequisites

- Flutter SDK 3.0 or higher
- Dart 3.0 or higher
- Supabase account for cloud sync (optional)

#### Environment Setup

1.  **Clone the repository**
    ```bash
    git clone https://github.com/your-username/subscription-manager.git
    cd subscription-manager
    ```

2.  **Copy environment file**
    ```bash
    cp .env.example .env
    ```

3.  **Configure environment variables**
    Edit `.env` file with your Supabase credentials:
    ```
    SUPABASE_URL=your_supabase_url
    SUPABASE_ANON_KEY=your_supabase_anon_key
    ```

4.  **Install dependencies**
    ```bash
    flutter pub get
    ```

5.  **Generate code**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

6.  **Run the application**
    ```bash
    flutter run
    ```

#### Build for Production

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

#### Build with Code Obfuscation

To build the application with code obfuscation enabled for enhanced security:

```bash
# Android with obfuscation
flutter build apk --obfuscate --split-debug-info=./build/symbols
flutter build appbundle --obfuscate --split-debug-info=./build/symbols

# iOS with obfuscation
flutter build ios --obfuscate --split-debug-info=./build/symbols

# Other platforms with obfuscation
flutter build ipa --obfuscate --split-debug-info=./build/symbols
flutter build windows --obfuscate --split-debug-info=./build/symbols
```

For convenience, you can also use the provided build scripts:
- Windows: `scripts\build-obfuscated.bat`
- macOS/Linux: `scripts/build-obfuscated.sh`

Symbol files for debugging obfuscated builds are stored in the `./build/symbols` directory. Please backup these files for future debugging needs.

### Project Structure

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
    ├── subscription_list.dart
    └── sync_indicator.dart
```

### Architecture Overview

This application follows a clean architecture pattern with clear separation of concerns and feature-first modularization:

1.  **Presentation Layer**: UI screens, widgets, and dialogs using Riverpod for state management
    -   Screens for main application views
    -   Reusable widget components
    -   Modal dialogs for user interactions
    -   Riverpod providers for reactive state management

2.  **Domain Layer**: Business logic, use cases, and domain models
    -   Freezed immutable data models with pattern matching
    -   Repository interfaces defining data contracts
    -   Business logic services (sync, auth, migration, conflict resolution)
    -   Use cases encapsulating business rules

3.  **Data Layer**: Repositories implementing hybrid data sources
    -   **Local Storage**: Drift ORM with SQLite for persistent data
    -   **Local Cache**: Hive for fast in-memory caching with smart cache management
    -   **Remote Data**: Supabase integration with REST API (Dio + Retrofit) and GraphQL
    -   **Hybrid Repository**: Coordinating local and remote data sources with conflict resolution

4.  **Infrastructure Layer**: Core infrastructure components
    -   **Network Layer**: Dio HTTP client with interceptors (auth, logging, error, monitoring, retry)
    -   **Database**: Drift database with code generation and migration support
    -   **Caching**: Hive with smart cache policies and expiration strategies
    -   **Configuration**: Environment variables and Supabase configuration
    -   **Monitoring**: Network monitoring service with performance tracking

#### Feature-First Modular Architecture:

The application also implements a feature-first modular architecture:
-   **Subscription Feature Module**: Complete subscription management functionality
-   **User Profile Feature Module**: User authentication and profile management
-   Each feature module contains its own data, domain, and presentation layers
-   BLoC pattern used within feature modules for state management
-   Dependency injection configured per feature module

#### Key Architectural Features:

-   **Hybrid Data Strategy**: Local-first approach with automatic cloud synchronization
-   **Smart Caching**: Multi-level caching with configurable expiration policies
-   **Dependency Injection**: Riverpod providers for loose coupling and testability
-   **Comprehensive Error Handling**: Unified error handling throughout all layers
-   **Full Offline Support**: Complete functionality without internet connection
-   **Automatic Conflict Resolution**: Intelligent data synchronization and conflict resolution
-   **Data Migration**: Support for schema migrations and data transformation
-   **Real-time Updates**: Supabase real-time subscriptions for live data updates
-   **Performance Monitoring**: Network and performance monitoring with metrics collection
-   **Modular Design**: Feature-based modular architecture for scalability

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

#### Development Setup

1.  Fork the repository
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Install dependencies and generate code:
    ```bash
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5.  Push to the branch (`git push origin feature/AmazingFeature`)
6.  Open a Pull Request

#### Code Generation

This project uses several code generation tools:
-   `build_runner` for Freezed, JSON serialization, and Riverpod codegen
-   `drift_dev` for database code generation
-   `retrofit_generator` for API client generation

Always run code generation after modifying:
-   Data models (`@freezed` classes)
-   Database tables
-   API clients
-   Riverpod providers




