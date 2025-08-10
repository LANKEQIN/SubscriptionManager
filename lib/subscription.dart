import 'package:uuid/uuid.dart';

class Subscription {
  final String id;
  final String name;
  final String? icon;
  final String type;
  final double price;
  final String currency; // 新增货币字段，默认为CNY
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
    this.currency = 'CNY', // 默认货币为人民币
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
    String? currency,
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
      currency: currency ?? this.currency,
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
      'currency': currency,
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
      currency: map['currency'] ?? 'CNY', // 为向后兼容设置默认值
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
    // 根据货币代码获取货币符号
    final currencySymbols = {
      'CNY': '¥',
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'KRW': '₩',
      'INR': '₹',
      'RUB': '₽',
      'AUD': 'A\$',
      'CAD': 'C\$',
      'HKD': 'HK\$',
      'TWD': 'NT\$',
      'SGD': 'S\$',
    };
    
    final symbol = currencySymbols[currency] ?? currency;
    
    switch (billingCycle) {
      case '每月':
        return '$symbol${price.toStringAsFixed(2)}/月';
      case '每年':
        return '$symbol${price.toStringAsFixed(2)}/年';
      default:
        return '$symbol${price.toStringAsFixed(2)}';
    }
  }

  /// 获取续费状态描述
  String get renewalStatus {
    if (daysUntilPayment < 0) {
      return '已过期';
    } else if (daysUntilPayment == 0) {
      return '今天到期';
    } else if (daysUntilPayment == 1) {
      return '明天到期';
    } else if (daysUntilPayment <= 7) {
      return '${daysUntilPayment}天后到期';
    } else {
      return '自动续费';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Subscription &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          icon == other.icon &&
          type == other.type &&
          price == other.price &&
          currency == other.currency &&
          billingCycle == other.billingCycle &&
          nextPaymentDate == other.nextPaymentDate &&
          autoRenewal == other.autoRenewal &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      icon.hashCode ^
      type.hashCode ^
      price.hashCode ^
      currency.hashCode ^
      billingCycle.hashCode ^
      nextPaymentDate.hashCode ^
      autoRenewal.hashCode ^
      notes.hashCode;
}