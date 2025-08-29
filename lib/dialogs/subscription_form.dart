import 'package:flutter/material.dart';
import '../utils/icon_picker.dart';
import '../utils/subscription_constants.dart';

class SubscriptionForm extends StatefulWidget {
  final SubscriptionFormData? initialData;
  final GlobalKey<FormState> formKey;
  final Function(SubscriptionFormState)? onStateCreated;

  const SubscriptionForm({
    super.key,
    this.initialData,
    required this.formKey,
    this.onStateCreated,
  });

  @override
  State<SubscriptionForm> createState() => SubscriptionFormState();

  static SubscriptionFormState? of(BuildContext context) {
    return context.findAncestorStateOfType<SubscriptionFormState>();
  }
}

class SubscriptionFormState extends State<SubscriptionForm> {
  late final TextEditingController _serviceNameController;
  late final TextEditingController _priceController;
  late final TextEditingController _nextPaymentDateController;
  late final TextEditingController _notesController;

  // 下拉选项值
  String? _selectedSubscriptionType;
  String? _selectedBillingCycle;
  String? _selectedCurrency;
  IconData? _selectedIcon;

  // 自动续费开关值
  late bool _autoRenewal;

  // 订阅类型选项
  static const List<String> _subscriptionTypes = SubscriptionConstants.subscriptionTypes;

  // 计费周期选项
  static const List<String> _billingCycles = SubscriptionConstants.billingCycles;

  // 表单校验工具方法
  String? _validateServiceName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入服务名称';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入价格';
    }
    if (double.tryParse(value) == null) {
      return '请输入有效数字';
    }
    return null;
  }

  String? _validateSubscriptionType(String? value) {
    if (value == null || value.isEmpty) {
      return '请选择订阅类型';
    }
    return null;
  }

  String? _validateCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return '请选择货币';
    }
    return null;
  }

  String? _validateBillingCycle(String? value) {
    if (value == null || value.isEmpty) {
      return '请选择计费周期';
    }
    return null;
  }

  String? _validateNextPaymentDate(String? value) {
    if (value == null || value.isEmpty) {
      return '请选择下次付费日期';
    }
    return null;
  }

  // 货币选项
  static final Map<String, String> _currencies = {
    'CNY': '人民币 (CN¥)',
    'USD': '美元 (US\$)',
    'EUR': '欧元 (€)',
    'GBP': '英镑 (£)',
    'JPY': '日元 (JP¥)',
    'KRW': '韩元 (₩)',
    'INR': '印度卢比 (₹)',
    'RUB': '卢布 (₽)',
    'AUD': '澳元 (A\$)',
    'CAD': '加元 (C\$)',
    'HKD': '港币 (HK\$)',
    'TWD': '新台币 (NT\$)',
    'SGD': '新加坡元 (S\$)',
  };

  @override
  void initState() {
    super.initState();

    final initialData = widget.initialData;
    if (initialData != null) {
      _serviceNameController = TextEditingController(text: initialData.serviceName);
      _priceController = TextEditingController(text: initialData.price.toString());
      _nextPaymentDateController = TextEditingController(text: initialData.nextPaymentDate);
      _notesController = TextEditingController(text: initialData.notes ?? '');

      _selectedSubscriptionType = initialData.subscriptionType;
      _selectedBillingCycle = initialData.billingCycle;
      _selectedCurrency = initialData.currency;
      _selectedIcon = initialData.icon;
      _autoRenewal = initialData.autoRenewal;
    } else {
      _serviceNameController = TextEditingController();
      _priceController = TextEditingController();
      _nextPaymentDateController = TextEditingController();
      _notesController = TextEditingController();

      _selectedCurrency = 'CNY';
      _autoRenewal = true;
    }
    
    // 通知父组件表单状态已创建
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onStateCreated?.call(this);
    });
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _priceController.dispose();
    _nextPaymentDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 服务名称
            TextFormField(
              controller: _serviceNameController,
              decoration: const InputDecoration(
                labelText: '服务名称',
                hintText: '请输入订阅服务名称',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: _validateServiceName,
            ),

            const SizedBox(height: 16),

            // 图标选择
            IconPicker(
              selectedIcon: _selectedIcon,
              onIconSelected: (icon) {
                setState(() {
                  _selectedIcon = icon;
                });
              },
            ),

            const SizedBox(height: 16),

            // 订阅类型
            DropdownButtonFormField<String>(
              value: _selectedSubscriptionType,
              decoration: const InputDecoration(
                labelText: '订阅类型',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _subscriptionTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubscriptionType = value;
                });
              },
              validator: _validateSubscriptionType,
            ),

            const SizedBox(height: 16),

            // 价格
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: '价格',
                hintText: '请输入价格',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
              validator: _validatePrice,
            ),

            const SizedBox(height: 16),

            // 货币选择
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(
                labelText: '货币',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_yen),
              ),
              items: _currencies.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value), // 显示货币全称和符号
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value;
                });
              },
              validator: _validateCurrency,
            ),

            const SizedBox(height: 16),

            // 计费周期
            DropdownButtonFormField<String>(
              value: _selectedBillingCycle,
              decoration: const InputDecoration(
                labelText: '计费周期',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.repeat_outlined),
              ),
              items: _billingCycles.map((String cycle) {
                return DropdownMenuItem<String>(
                  value: cycle,
                  child: Text(cycle),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBillingCycle = value;
                });
              },
              validator: _validateBillingCycle,
            ),

            const SizedBox(height: 16),

            // 下次付费日期
            TextFormField(
              controller: _nextPaymentDateController,
              decoration: const InputDecoration(
                labelText: '下次付费日期',
                hintText: '请选择日期',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2050),
                );

                if (pickedDate != null) {
                  setState(() {
                    _nextPaymentDateController.text =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                  });
                }
              },
              validator: _validateNextPaymentDate,
            ),

            const SizedBox(height: 16),

            // 自动续费选项
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        '是否开启自动续费',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Switch(
                      value: _autoRenewal,
                      onChanged: (value) {
                        setState(() {
                          _autoRenewal = value;
                        });
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 备注
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: '备注 (可选)',
                hintText: '请输入备注信息',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note_outlined),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SubscriptionFormData get formData => SubscriptionFormData(
        serviceName: _serviceNameController.text,
        icon: _selectedIcon,
        subscriptionType: _selectedSubscriptionType!,
        price: double.parse(_priceController.text),
        currency: _selectedCurrency ?? 'CNY',
        billingCycle: _selectedBillingCycle!,
        nextPaymentDate: _nextPaymentDateController.text,
        autoRenewal: _autoRenewal,
        notes: _notesController.text,
      );
}

class SubscriptionFormData {
  final String serviceName;
  final IconData? icon;
  final String subscriptionType;
  final double price;
  final String currency;
  final String billingCycle;
  final String nextPaymentDate;
  final bool autoRenewal;
  final String? notes;

  SubscriptionFormData({
    required this.serviceName,
    this.icon,
    required this.subscriptionType,
    required this.price,
    required this.currency,
    required this.billingCycle,
    required this.nextPaymentDate,
    required this.autoRenewal,
    this.notes,
  });

  factory SubscriptionFormData.fromSubscription(dynamic subscription) {
    return SubscriptionFormData(
      serviceName: subscription.name,
      icon: subscription.icon != null
          ? IconData(int.parse(subscription.icon), fontFamily: 'MaterialIcons')
          : null,
      subscriptionType: subscription.type,
      price: subscription.price,
      currency: subscription.currency ?? 'CNY',
      billingCycle: subscription.billingCycle,
      nextPaymentDate:
          "${subscription.nextPaymentDate.year}-${subscription.nextPaymentDate.month.toString().padLeft(2, '0')}-${subscription.nextPaymentDate.day.toString().padLeft(2, '0')}",
      autoRenewal: subscription.autoRenewal,
      notes: subscription.notes,
    );
  }
}