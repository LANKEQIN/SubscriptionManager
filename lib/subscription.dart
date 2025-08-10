import 'package:uuid/uuid.dart';

class Subscription {
  final String id;
  final String name;
  final String? icon;
  final String type;
  final double price;
  final String billingCycle; // 每月/每年/一次性
  final DateTime nextPaymentDate;
  final bool autoRenewal;
  final String? notes;

  Subscription({
    String? id,
    required this.name,
    this.icon,
    required this.type,
    required this.price,
    required this.billingCycle,
    required this.nextPaymentDate,
    required this.autoRenewal,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  /// 创建一个Subscription实例的副本，用于更新操作
  Subscription copyWith({
    String? id,
    String? name,
    String? icon,
    String? type,
    double? price,
    String? billingCycle,
    DateTime? nextPaymentDate,
    bool? autoRenewal,
    String? notes,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      autoRenewal: autoRenewal ?? this.autoRenewal,
      notes: notes ?? this.notes,
    );
  }

  /// 将Subscription对象转换为Map，便于存储
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
      'price': price,
      'billingCycle': billingCycle,
      'nextPaymentDate': nextPaymentDate.millisecondsSinceEpoch,
      'autoRenewal': autoRenewal,
      'notes': notes,
    };
  }

  /// 从Map创建Subscription对象
  factory Subscription.fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      type: map['type'],
      price: map['price'],
      billingCycle: map['billingCycle'],
      nextPaymentDate: DateTime.fromMillisecondsSinceEpoch(map['nextPaymentDate']),
      autoRenewal: map['autoRenewal'],
      notes: map['notes'],
    );
  }

  /// 计算下次付款前剩余天数
  int get daysUntilPayment {
    final now = DateTime.now();
    final difference = nextPaymentDate.difference(now);
    return difference.inDays;
  }

  /// 格式化价格显示
  String get formattedPrice {
    switch (billingCycle) {
      case '每月':
        return '¥${price.toStringAsFixed(2)}/月';
      case '每年':
        return '¥${price.toStringAsFixed(2)}/年';
      default:
        return '¥${price.toStringAsFixed(2)}';
    }
  }

  /// 获取续费状态描述
  String get renewalStatus {
    if (autoRenewal) {
      return '自动续费';
    } else {
      final days = daysUntilPayment;
      if (days < 0) {
        return '已过期';
      } else if (days == 0) {
        return '今天到期';
      } else if (days == 1) {
        return '明天到期';
      } else {
        return '$days天后到期';
      }
    }
  }
}