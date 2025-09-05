# Subscription Manager 订阅管理器
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

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/subscription-manager.git
   cd subscription-manager
   ```

2. **Copy environment file**
   ```bash
   cp .env.example .env
   ```

3. **Configure environment variables**
   Edit `.env` file with your Supabase credentials:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Run the application**
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

### Project Structure

```
lib/
├── main.dart                 # Application entry point
├── screens/                  # UI screens
│   ├── home_screen.dart      # Main dashboard
│   ├── statistics_screen.dart # Charts and analytics
│   ├── notifications_screen.dart # Renewal notifications
│   ├── profile_screen.dart   # User settings
│   └── auth_screen.dart      # Authentication
├── providers/                # Riverpod state management
│   ├── app_providers.dart    # Main providers
│   ├── app_providers.g.dart  # Generated providers
│   ├── subscription_notifier.dart # Subscription state
│   └── subscription_notifier.g.dart # Generated notifier
├── models/                   # Data models (Freezed)
│   ├── subscription.dart     # Subscription model
│   ├── subscription.freezed.dart # Generated subscription model
│   ├── user_profile.dart     # User profile
│   ├── user_profile.freezed.dart # Generated user profile
│   ├── sync_state.dart       # Sync status
│   ├── sync_state.freezed.dart # Generated sync state
│   ├── subscription_state.dart # Subscription state
│   ├── subscription_state.freezed.dart # Generated subscription state
│   ├── monthly_history.dart # Monthly history
│   ├── monthly_history.freezed.dart # Generated monthly history
│   └── sync_types.dart      # Sync types
├── services/                 # Business logic services
│   ├── sync_service.dart     # Cloud synchronization
│   ├── sync_service.g.dart   # Generated sync service
│   ├── auth_service.dart     # Authentication
│   ├── auth_service.g.dart   # Generated auth service
│   ├── connectivity_service.dart # Network monitoring
│   ├── connectivity_service.g.dart # Generated connectivity service
│   ├── migration_service.dart # Data migration
│   ├── migration_service.g.dart # Generated migration service
│   ├── conflict_resolver.dart # Conflict resolution
│   └── conflict_resolver.g.dart # Generated conflict resolver
├── repositories/             # Data access layer
│   ├── hybrid_subscription_repository.dart # Local + remote data
│   ├── hybrid_subscription_repository.g.dart # Generated hybrid repository
│   ├── repository_interfaces.dart # Abstract interfaces
│   ├── subscription_repository_impl.dart # Subscription repository implementation
│   ├── monthly_history_repository_impl.dart # Monthly history repository
│   ├── remote_subscription_repository.dart # Remote repository
│   ├── enhanced_remote_subscription_repository.dart # Enhanced remote repository
│   └── error_handler.dart   # Error handling
├── database/                 # Local database (Drift/SQLite)
│   ├── app_database.dart     # Database definition
│   ├── app_database.g.dart   # Generated database
│   └── tables.dart          # Table schemas
├── cache/                    # Caching layer (Hive)
│   ├── hive_service.dart     # Hive operations
│   ├── smart_cache_manager.dart # Cache strategy
│   ├── cached_data.dart     # Cached data model
│   └── cached_data.g.dart   # Generated cached data
├── network/                  # Network layer
│   ├── api/                  # API clients
│   │   ├── auth_api.dart     # Auth API
│   │   ├── auth_api.g.dart   # Generated auth API
│   │   ├── subscription_api.dart # Subscription API
│   │   └── subscription_api.g.dart # Generated subscription API
│   ├── dto/                  # Data transfer objects
│   │   ├── auth_responses.dart # Auth responses
│   │   ├── auth_responses.g.dart # Generated auth responses
│   │   ├── subscription_dto.dart # Subscription DTO
│   │   ├── subscription_dto.g.dart # Generated subscription DTO
│   │   ├── subscription_requests.dart # Subscription requests
│   │   ├── subscription_requests.g.dart # Generated subscription requests
│   │   ├── subscription_responses.dart # Subscription responses
│   │   └── subscription_responses.g.dart # Generated subscription responses
│   ├── graphql/              # GraphQL
│   │   ├── subscription_queries.dart # Subscription queries
│   │   └── subscription_service.dart # Subscription service
│   ├── interceptors/         # Request interceptors
│   │   ├── auth_interceptor.dart # Auth interceptor
│   │   ├── error_interceptor.dart # Error interceptor
│   │   ├── logging_interceptor.dart # Logging interceptor
│   │   ├── monitoring_interceptor.dart # Monitoring interceptor
│   │   └── retry_interceptor.dart # Retry interceptor
│   ├── monitoring/           # Network monitoring
│   │   └── network_monitor_service.dart # Network monitor service
│   ├── error/                # Error handling
│   │   ├── network_error_handler.dart # Network error handler
│   │   ├── network_exception.dart # Network exception
│   │   └── network_exception.freezed.dart # Generated network exception
│   ├── dio_client.dart       # HTTP client
│   ├── graphql_client.dart   # GraphQL client
│   └── examples/            # API examples
├── config/                   # Configuration
│   ├── supabase_config.dart  # Supabase setup
│   └── theme_builder.dart    # Theme configuration
├── dialogs/                  # Modal dialogs
│   ├── subscription_form.dart # Subscription forms
│   ├── base_subscription_dialog.dart # Base dialog
│   ├── add_subscription_dialog.dart # Add subscription dialog
│   └── edit_subscription_dialog.dart # Edit subscription dialog
├── utils/                    # Utilities
│   ├── currency_constants.dart # Currency support
│   ├── icon_picker.dart      # Icon selection
│   ├── icon_utils.dart       # Icon utilities
│   ├── app_logger.dart       # Logging
│   ├── subscription_constants.dart # Subscription constants
│   └── user_preferences.dart # User preferences
├── widgets/                  # Reusable components
│   ├── subscription_card.dart # Subscription item
│   ├── sync_indicator.dart   # Sync status indicator
│   ├── statistics_card.dart  # Stats cards
│   ├── subscription_list.dart # Subscription list
│   └── add_button.dart       # Add button
├── constants/                # Constants
│   └── theme_constants.dart  # Theme constants
├── core/                     # Core architecture
│   ├── data/                 # Data layer
│   │   ├── datasources/      # Data sources
│   │   ├── models/           # Data models
│   │   └── repositories/     # Data repositories
│   ├── domain/               # Domain layer
│   │   ├── entities/         # Domain entities
│   │   ├── repositories/     # Domain repositories
│   │   └── usecases/         # Use cases
│   └── presentation/         # Presentation layer
│       ├── blocs/            # BLoC pattern
│       ├── screens/          # Screens
│       └── widgets/          # Widgets
├── features/                 # Feature modules
│   ├── subscription_feature/ # Subscription feature
│   │   ├── data/             # Subscription data
│   │   ├── di/               # Dependency injection
│   │   ├── domain/           # Subscription domain
│   │   └── presentation/     # Subscription presentation
│   └── user_profile_feature/ # User profile feature
│       ├── data/             # User profile data
│       ├── domain/           # User profile domain
│       └── presentation/     # User profile presentation
└── fixed_exchange_rate_service.dart # Fixed exchange rate service
```

### Architecture Overview

This application follows a clean architecture pattern with clear separation of concerns and feature-first modularization:

1. **Presentation Layer**: UI screens, widgets, and dialogs using Riverpod for state management
   - Screens for main application views
   - Reusable widget components
   - Modal dialogs for user interactions
   - Riverpod providers for reactive state management

2. **Domain Layer**: Business logic, use cases, and domain models
   - Freezed immutable data models with pattern matching
   - Repository interfaces defining data contracts
   - Business logic services (sync, auth, migration, conflict resolution)
   - Use cases encapsulating business rules

3. **Data Layer**: Repositories implementing hybrid data sources
   - **Local Storage**: Drift ORM with SQLite for persistent data
   - **Local Cache**: Hive for fast in-memory caching with smart cache management
   - **Remote Data**: Supabase integration with REST API (Dio + Retrofit) and GraphQL
   - **Hybrid Repository**: Coordinating local and remote data sources with conflict resolution

4. **Infrastructure Layer**: Core infrastructure components
   - **Network Layer**: Dio HTTP client with interceptors (auth, logging, error, monitoring, retry)
   - **Database**: Drift database with code generation and migration support
   - **Caching**: Hive with smart cache policies and expiration strategies
   - **Configuration**: Environment variables and Supabase configuration
   - **Monitoring**: Network monitoring service with performance tracking

#### Feature-First Modular Architecture:

The application also implements a feature-first modular architecture:
- **Subscription Feature Module**: Complete subscription management functionality
- **User Profile Feature Module**: User authentication and profile management
- Each feature module contains its own data, domain, and presentation layers
- BLoC pattern used within feature modules for state management
- Dependency injection configured per feature module

#### Key Architectural Features:

- **Hybrid Data Strategy**: Local-first approach with automatic cloud synchronization
- **Smart Caching**: Multi-level caching with configurable expiration policies
- **Dependency Injection**: Riverpod providers for loose coupling and testability
- **Comprehensive Error Handling**: Unified error handling throughout all layers
- **Full Offline Support**: Complete functionality without internet connection
- **Automatic Conflict Resolution**: Intelligent data synchronization and conflict resolution
- **Data Migration**: Support for schema migrations and data transformation
- **Real-time Updates**: Supabase real-time subscriptions for live data updates
- **Performance Monitoring**: Network and performance monitoring with metrics collection
- **Modular Design**: Feature-based modular architecture for scalability

### Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

#### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Install dependencies and generate code:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

#### Code Generation

This project uses several code generation tools:
- `build_runner` for Freezed, JSON serialization, and Riverpod codegen
- `drift_dev` for database code generation
- `retrofit_generator` for API client generation

Always run code generation after modifying:
- Data models (`@freezed` classes)
- Database tables
- API clients
- Riverpod providers

---




