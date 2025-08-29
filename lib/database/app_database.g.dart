// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubscriptionsTable extends Subscriptions
    with TableInfo<$SubscriptionsTable, SubscriptionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CNY'));
  static const VerificationMeta _billingCycleMeta =
      const VerificationMeta('billingCycle');
  @override
  late final GeneratedColumn<String> billingCycle = GeneratedColumn<String>(
      'billing_cycle', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nextPaymentDateMeta =
      const VerificationMeta('nextPaymentDate');
  @override
  late final GeneratedColumn<DateTime> nextPaymentDate =
      GeneratedColumn<DateTime>('next_payment_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _autoRenewalMeta =
      const VerificationMeta('autoRenewal');
  @override
  late final GeneratedColumn<bool> autoRenewal = GeneratedColumn<bool>(
      'auto_renewal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_renewal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        icon,
        type,
        price,
        currency,
        billingCycle,
        nextPaymentDate,
        autoRenewal,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subscriptions';
  @override
  VerificationContext validateIntegrity(Insertable<SubscriptionEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('billing_cycle')) {
      context.handle(
          _billingCycleMeta,
          billingCycle.isAcceptableOrUnknown(
              data['billing_cycle']!, _billingCycleMeta));
    } else if (isInserting) {
      context.missing(_billingCycleMeta);
    }
    if (data.containsKey('next_payment_date')) {
      context.handle(
          _nextPaymentDateMeta,
          nextPaymentDate.isAcceptableOrUnknown(
              data['next_payment_date']!, _nextPaymentDateMeta));
    } else if (isInserting) {
      context.missing(_nextPaymentDateMeta);
    }
    if (data.containsKey('auto_renewal')) {
      context.handle(
          _autoRenewalMeta,
          autoRenewal.isAcceptableOrUnknown(
              data['auto_renewal']!, _autoRenewalMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubscriptionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubscriptionEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      billingCycle: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}billing_cycle'])!,
      nextPaymentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}next_payment_date'])!,
      autoRenewal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}auto_renewal'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SubscriptionsTable createAlias(String alias) {
    return $SubscriptionsTable(attachedDatabase, alias);
  }
}

class SubscriptionEntity extends DataClass
    implements Insertable<SubscriptionEntity> {
  /// 订阅唯一标识符
  final String id;

  /// 订阅服务名称
  final String name;

  /// 订阅图标（可选）
  final String? icon;

  /// 订阅类型/分类
  final String type;

  /// 订阅价格
  final double price;

  /// 货币类型，默认为CNY
  final String currency;

  /// 计费周期：monthly, yearly, one-time
  final String billingCycle;

  /// 下次付款日期
  final DateTime nextPaymentDate;

  /// 是否自动续费
  final bool autoRenewal;

  /// 备注信息（可选）
  final String? notes;

  /// 创建时间
  final DateTime createdAt;

  /// 更新时间
  final DateTime updatedAt;
  const SubscriptionEntity(
      {required this.id,
      required this.name,
      this.icon,
      required this.type,
      required this.price,
      required this.currency,
      required this.billingCycle,
      required this.nextPaymentDate,
      required this.autoRenewal,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['type'] = Variable<String>(type);
    map['price'] = Variable<double>(price);
    map['currency'] = Variable<String>(currency);
    map['billing_cycle'] = Variable<String>(billingCycle);
    map['next_payment_date'] = Variable<DateTime>(nextPaymentDate);
    map['auto_renewal'] = Variable<bool>(autoRenewal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return SubscriptionsCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      type: Value(type),
      price: Value(price),
      currency: Value(currency),
      billingCycle: Value(billingCycle),
      nextPaymentDate: Value(nextPaymentDate),
      autoRenewal: Value(autoRenewal),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SubscriptionEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubscriptionEntity(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      type: serializer.fromJson<String>(json['type']),
      price: serializer.fromJson<double>(json['price']),
      currency: serializer.fromJson<String>(json['currency']),
      billingCycle: serializer.fromJson<String>(json['billingCycle']),
      nextPaymentDate: serializer.fromJson<DateTime>(json['nextPaymentDate']),
      autoRenewal: serializer.fromJson<bool>(json['autoRenewal']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'type': serializer.toJson<String>(type),
      'price': serializer.toJson<double>(price),
      'currency': serializer.toJson<String>(currency),
      'billingCycle': serializer.toJson<String>(billingCycle),
      'nextPaymentDate': serializer.toJson<DateTime>(nextPaymentDate),
      'autoRenewal': serializer.toJson<bool>(autoRenewal),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SubscriptionEntity copyWith(
          {String? id,
          String? name,
          Value<String?> icon = const Value.absent(),
          String? type,
          double? price,
          String? currency,
          String? billingCycle,
          DateTime? nextPaymentDate,
          bool? autoRenewal,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SubscriptionEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        type: type ?? this.type,
        price: price ?? this.price,
        currency: currency ?? this.currency,
        billingCycle: billingCycle ?? this.billingCycle,
        nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
        autoRenewal: autoRenewal ?? this.autoRenewal,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SubscriptionEntity copyWithCompanion(SubscriptionsCompanion data) {
    return SubscriptionEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      type: data.type.present ? data.type.value : this.type,
      price: data.price.present ? data.price.value : this.price,
      currency: data.currency.present ? data.currency.value : this.currency,
      billingCycle: data.billingCycle.present
          ? data.billingCycle.value
          : this.billingCycle,
      nextPaymentDate: data.nextPaymentDate.present
          ? data.nextPaymentDate.value
          : this.nextPaymentDate,
      autoRenewal:
          data.autoRenewal.present ? data.autoRenewal.value : this.autoRenewal,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('autoRenewal: $autoRenewal, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, type, price, currency,
      billingCycle, nextPaymentDate, autoRenewal, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.type == this.type &&
          other.price == this.price &&
          other.currency == this.currency &&
          other.billingCycle == this.billingCycle &&
          other.nextPaymentDate == this.nextPaymentDate &&
          other.autoRenewal == this.autoRenewal &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SubscriptionsCompanion extends UpdateCompanion<SubscriptionEntity> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String> type;
  final Value<double> price;
  final Value<String> currency;
  final Value<String> billingCycle;
  final Value<DateTime> nextPaymentDate;
  final Value<bool> autoRenewal;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SubscriptionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.type = const Value.absent(),
    this.price = const Value.absent(),
    this.currency = const Value.absent(),
    this.billingCycle = const Value.absent(),
    this.nextPaymentDate = const Value.absent(),
    this.autoRenewal = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubscriptionsCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    required String type,
    required double price,
    this.currency = const Value.absent(),
    required String billingCycle,
    required DateTime nextPaymentDate,
    this.autoRenewal = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        price = Value(price),
        billingCycle = Value(billingCycle),
        nextPaymentDate = Value(nextPaymentDate);
  static Insertable<SubscriptionEntity> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? type,
    Expression<double>? price,
    Expression<String>? currency,
    Expression<String>? billingCycle,
    Expression<DateTime>? nextPaymentDate,
    Expression<bool>? autoRenewal,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (type != null) 'type': type,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
      if (billingCycle != null) 'billing_cycle': billingCycle,
      if (nextPaymentDate != null) 'next_payment_date': nextPaymentDate,
      if (autoRenewal != null) 'auto_renewal': autoRenewal,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubscriptionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? icon,
      Value<String>? type,
      Value<double>? price,
      Value<String>? currency,
      Value<String>? billingCycle,
      Value<DateTime>? nextPaymentDate,
      Value<bool>? autoRenewal,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SubscriptionsCompanion(
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (billingCycle.present) {
      map['billing_cycle'] = Variable<String>(billingCycle.value);
    }
    if (nextPaymentDate.present) {
      map['next_payment_date'] = Variable<DateTime>(nextPaymentDate.value);
    }
    if (autoRenewal.present) {
      map['auto_renewal'] = Variable<bool>(autoRenewal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('price: $price, ')
          ..write('currency: $currency, ')
          ..write('billingCycle: $billingCycle, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('autoRenewal: $autoRenewal, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MonthlyHistoriesTable extends MonthlyHistories
    with TableInfo<$MonthlyHistoriesTable, MonthlyHistoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subscriptionCountMeta =
      const VerificationMeta('subscriptionCount');
  @override
  late final GeneratedColumn<int> subscriptionCount = GeneratedColumn<int>(
      'subscription_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, year, month, totalAmount, currency, subscriptionCount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_histories';
  @override
  VerificationContext validateIntegrity(
      Insertable<MonthlyHistoryEntity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('subscription_count')) {
      context.handle(
          _subscriptionCountMeta,
          subscriptionCount.isAcceptableOrUnknown(
              data['subscription_count']!, _subscriptionCountMeta));
    } else if (isInserting) {
      context.missing(_subscriptionCountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {year, month},
      ];
  @override
  MonthlyHistoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyHistoryEntity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      subscriptionCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}subscription_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MonthlyHistoriesTable createAlias(String alias) {
    return $MonthlyHistoriesTable(attachedDatabase, alias);
  }
}

class MonthlyHistoryEntity extends DataClass
    implements Insertable<MonthlyHistoryEntity> {
  /// 历史记录唯一标识符
  final String id;

  /// 年份
  final int year;

  /// 月份 (1-12)
  final int month;

  /// 当月总金额
  final double totalAmount;

  /// 货币类型
  final String currency;

  /// 当月订阅数量
  final int subscriptionCount;

  /// 创建时间
  final DateTime createdAt;
  const MonthlyHistoryEntity(
      {required this.id,
      required this.year,
      required this.month,
      required this.totalAmount,
      required this.currency,
      required this.subscriptionCount,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['total_amount'] = Variable<double>(totalAmount);
    map['currency'] = Variable<String>(currency);
    map['subscription_count'] = Variable<int>(subscriptionCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MonthlyHistoriesCompanion toCompanion(bool nullToAbsent) {
    return MonthlyHistoriesCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      totalAmount: Value(totalAmount),
      currency: Value(currency),
      subscriptionCount: Value(subscriptionCount),
      createdAt: Value(createdAt),
    );
  }

  factory MonthlyHistoryEntity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyHistoryEntity(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      currency: serializer.fromJson<String>(json['currency']),
      subscriptionCount: serializer.fromJson<int>(json['subscriptionCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'currency': serializer.toJson<String>(currency),
      'subscriptionCount': serializer.toJson<int>(subscriptionCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MonthlyHistoryEntity copyWith(
          {String? id,
          int? year,
          int? month,
          double? totalAmount,
          String? currency,
          int? subscriptionCount,
          DateTime? createdAt}) =>
      MonthlyHistoryEntity(
        id: id ?? this.id,
        year: year ?? this.year,
        month: month ?? this.month,
        totalAmount: totalAmount ?? this.totalAmount,
        currency: currency ?? this.currency,
        subscriptionCount: subscriptionCount ?? this.subscriptionCount,
        createdAt: createdAt ?? this.createdAt,
      );
  MonthlyHistoryEntity copyWithCompanion(MonthlyHistoriesCompanion data) {
    return MonthlyHistoryEntity(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      currency: data.currency.present ? data.currency.value : this.currency,
      subscriptionCount: data.subscriptionCount.present
          ? data.subscriptionCount.value
          : this.subscriptionCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyHistoryEntity(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('currency: $currency, ')
          ..write('subscriptionCount: $subscriptionCount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, year, month, totalAmount, currency, subscriptionCount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyHistoryEntity &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.totalAmount == this.totalAmount &&
          other.currency == this.currency &&
          other.subscriptionCount == this.subscriptionCount &&
          other.createdAt == this.createdAt);
}

class MonthlyHistoriesCompanion extends UpdateCompanion<MonthlyHistoryEntity> {
  final Value<String> id;
  final Value<int> year;
  final Value<int> month;
  final Value<double> totalAmount;
  final Value<String> currency;
  final Value<int> subscriptionCount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MonthlyHistoriesCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.currency = const Value.absent(),
    this.subscriptionCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MonthlyHistoriesCompanion.insert({
    required String id,
    required int year,
    required int month,
    required double totalAmount,
    required String currency,
    required int subscriptionCount,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        year = Value(year),
        month = Value(month),
        totalAmount = Value(totalAmount),
        currency = Value(currency),
        subscriptionCount = Value(subscriptionCount);
  static Insertable<MonthlyHistoryEntity> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<double>? totalAmount,
    Expression<String>? currency,
    Expression<int>? subscriptionCount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (currency != null) 'currency': currency,
      if (subscriptionCount != null) 'subscription_count': subscriptionCount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MonthlyHistoriesCompanion copyWith(
      {Value<String>? id,
      Value<int>? year,
      Value<int>? month,
      Value<double>? totalAmount,
      Value<String>? currency,
      Value<int>? subscriptionCount,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return MonthlyHistoriesCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      subscriptionCount: subscriptionCount ?? this.subscriptionCount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (subscriptionCount.present) {
      map['subscription_count'] = Variable<int>(subscriptionCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('currency: $currency, ')
          ..write('subscriptionCount: $subscriptionCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubscriptionsTable subscriptions = $SubscriptionsTable(this);
  late final $MonthlyHistoriesTable monthlyHistories =
      $MonthlyHistoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [subscriptions, monthlyHistories];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$SubscriptionsTableCreateCompanionBuilder = SubscriptionsCompanion
    Function({
  required String id,
  required String name,
  Value<String?> icon,
  required String type,
  required double price,
  Value<String> currency,
  required String billingCycle,
  required DateTime nextPaymentDate,
  Value<bool> autoRenewal,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$SubscriptionsTableUpdateCompanionBuilder = SubscriptionsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> icon,
  Value<String> type,
  Value<double> price,
  Value<String> currency,
  Value<String> billingCycle,
  Value<DateTime> nextPaymentDate,
  Value<bool> autoRenewal,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SubscriptionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextPaymentDate => $composableBuilder(
      column: $table.nextPaymentDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get autoRenewal => $composableBuilder(
      column: $table.autoRenewal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SubscriptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextPaymentDate => $composableBuilder(
      column: $table.nextPaymentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get autoRenewal => $composableBuilder(
      column: $table.autoRenewal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SubscriptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubscriptionsTable> {
  $$SubscriptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get billingCycle => $composableBuilder(
      column: $table.billingCycle, builder: (column) => column);

  GeneratedColumn<DateTime> get nextPaymentDate => $composableBuilder(
      column: $table.nextPaymentDate, builder: (column) => column);

  GeneratedColumn<bool> get autoRenewal => $composableBuilder(
      column: $table.autoRenewal, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SubscriptionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    SubscriptionEntity,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      SubscriptionEntity,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, SubscriptionEntity>
    ),
    SubscriptionEntity,
    PrefetchHooks Function()> {
  $$SubscriptionsTableTableManager(_$AppDatabase db, $SubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubscriptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubscriptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String> billingCycle = const Value.absent(),
            Value<DateTime> nextPaymentDate = const Value.absent(),
            Value<bool> autoRenewal = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionsCompanion(
            id: id,
            name: name,
            icon: icon,
            type: type,
            price: price,
            currency: currency,
            billingCycle: billingCycle,
            nextPaymentDate: nextPaymentDate,
            autoRenewal: autoRenewal,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> icon = const Value.absent(),
            required String type,
            required double price,
            Value<String> currency = const Value.absent(),
            required String billingCycle,
            required DateTime nextPaymentDate,
            Value<bool> autoRenewal = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubscriptionsCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            type: type,
            price: price,
            currency: currency,
            billingCycle: billingCycle,
            nextPaymentDate: nextPaymentDate,
            autoRenewal: autoRenewal,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SubscriptionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SubscriptionsTable,
    SubscriptionEntity,
    $$SubscriptionsTableFilterComposer,
    $$SubscriptionsTableOrderingComposer,
    $$SubscriptionsTableAnnotationComposer,
    $$SubscriptionsTableCreateCompanionBuilder,
    $$SubscriptionsTableUpdateCompanionBuilder,
    (
      SubscriptionEntity,
      BaseReferences<_$AppDatabase, $SubscriptionsTable, SubscriptionEntity>
    ),
    SubscriptionEntity,
    PrefetchHooks Function()>;
typedef $$MonthlyHistoriesTableCreateCompanionBuilder
    = MonthlyHistoriesCompanion Function({
  required String id,
  required int year,
  required int month,
  required double totalAmount,
  required String currency,
  required int subscriptionCount,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$MonthlyHistoriesTableUpdateCompanionBuilder
    = MonthlyHistoriesCompanion Function({
  Value<String> id,
  Value<int> year,
  Value<int> month,
  Value<double> totalAmount,
  Value<String> currency,
  Value<int> subscriptionCount,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$MonthlyHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyHistoriesTable> {
  $$MonthlyHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subscriptionCount => $composableBuilder(
      column: $table.subscriptionCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$MonthlyHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyHistoriesTable> {
  $$MonthlyHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subscriptionCount => $composableBuilder(
      column: $table.subscriptionCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$MonthlyHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyHistoriesTable> {
  $$MonthlyHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<int> get subscriptionCount => $composableBuilder(
      column: $table.subscriptionCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MonthlyHistoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonthlyHistoriesTable,
    MonthlyHistoryEntity,
    $$MonthlyHistoriesTableFilterComposer,
    $$MonthlyHistoriesTableOrderingComposer,
    $$MonthlyHistoriesTableAnnotationComposer,
    $$MonthlyHistoriesTableCreateCompanionBuilder,
    $$MonthlyHistoriesTableUpdateCompanionBuilder,
    (
      MonthlyHistoryEntity,
      BaseReferences<_$AppDatabase, $MonthlyHistoriesTable,
          MonthlyHistoryEntity>
    ),
    MonthlyHistoryEntity,
    PrefetchHooks Function()> {
  $$MonthlyHistoriesTableTableManager(
      _$AppDatabase db, $MonthlyHistoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<int> subscriptionCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonthlyHistoriesCompanion(
            id: id,
            year: year,
            month: month,
            totalAmount: totalAmount,
            currency: currency,
            subscriptionCount: subscriptionCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required int year,
            required int month,
            required double totalAmount,
            required String currency,
            required int subscriptionCount,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MonthlyHistoriesCompanion.insert(
            id: id,
            year: year,
            month: month,
            totalAmount: totalAmount,
            currency: currency,
            subscriptionCount: subscriptionCount,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MonthlyHistoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonthlyHistoriesTable,
    MonthlyHistoryEntity,
    $$MonthlyHistoriesTableFilterComposer,
    $$MonthlyHistoriesTableOrderingComposer,
    $$MonthlyHistoriesTableAnnotationComposer,
    $$MonthlyHistoriesTableCreateCompanionBuilder,
    $$MonthlyHistoriesTableUpdateCompanionBuilder,
    (
      MonthlyHistoryEntity,
      BaseReferences<_$AppDatabase, $MonthlyHistoriesTable,
          MonthlyHistoryEntity>
    ),
    MonthlyHistoryEntity,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubscriptionsTableTableManager get subscriptions =>
      $$SubscriptionsTableTableManager(_db, _db.subscriptions);
  $$MonthlyHistoriesTableTableManager get monthlyHistories =>
      $$MonthlyHistoriesTableTableManager(_db, _db.monthlyHistories);
}
