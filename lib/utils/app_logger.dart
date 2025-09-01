import 'package:logger/logger.dart';

/// 应用程序日志工具类
/// 统一管理整个应用的日志记录
class AppLogger {
  static final Logger _logger = Logger(
    filter: ProductionFilter(), // 生产环境过滤器
    printer: PrettyPrinter(
      methodCount: 2, // 堆栈跟踪方法数
      errorMethodCount: 8, // 错误堆栈跟踪方法数
      lineLength: 120, // 输出线长度
      colors: true, // 彩色输出
      printEmojis: true, // 打印表情符号
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart, // 使用新的时间格式
    ),
    output: ConsoleOutput(), // 控制台输出
  );

  /// Debug 级别日志
  static void d(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Info 级别日志
  static void i(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Warning 级别日志
  static void w(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Error 级别日志
  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Fatal 级别日志
  static void f(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// 网络请求日志
  static void network(String message, {String? method, String? url, int? statusCode}) {
    final String fullMessage = '[$method] $url ${statusCode != null ? '- $statusCode' : ''}\n$message';
    _logger.d(fullMessage);
  }

  /// 数据库操作日志
  static void database(String operation, String message) {
    _logger.d('[DB - $operation] $message');
  }

  /// 缓存操作日志
  static void cache(String operation, String message) {
    _logger.d('[Cache - $operation] $message');
  }

  /// 同步操作日志
  static void sync(String message) {
    _logger.i('[Sync] $message');
  }

  /// 认证相关日志
  static void auth(String message) {
    _logger.i('[Auth] $message');
  }
}