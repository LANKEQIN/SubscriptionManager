import 'package:hive/hive.dart';

part 'cached_data.g.dart';

/// Hive缓存数据模型
/// 用于存储带有过期时间的缓存数据
@HiveType(typeId: 0)
class CachedData extends HiveObject {
  /// 缓存键
  @HiveField(0)
  @override
  String key;

  /// 缓存值（JSON字符串）
  @HiveField(1)
  String value;

  /// 创建时间
  @HiveField(2)
  DateTime createdAt;

  /// 过期时长（可选）
  @HiveField(3)
  Duration? expiryDuration;

  CachedData({
    required this.key,
    required this.value,
    required this.createdAt,
    this.expiryDuration,
  });

  /// 检查缓存是否已过期
  bool get isExpired {
    if (expiryDuration == null) return false;
    return DateTime.now().isAfter(createdAt.add(expiryDuration!));
  }

  /// 获取剩余有效时间
  Duration? get remainingTime {
    if (expiryDuration == null || isExpired) return null;
    final expiredAt = createdAt.add(expiryDuration!);
    return expiredAt.difference(DateTime.now());
  }

  /// 获取缓存年龄
  Duration get age {
    return DateTime.now().difference(createdAt);
  }

  @override
  String toString() {
    return 'CachedData(key: $key, age: ${age.inMinutes}min, expired: $isExpired)';
  }
}