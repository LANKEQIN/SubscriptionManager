import 'package:flutter/material.dart';
import 'subscription.dart';
import 'icon_picker.dart';

class AddSubscriptionDialog extends StatefulWidget {
  final Function(Subscription)? onSubscriptionAdded;

  const AddSubscriptionDialog({super.key, this.onSubscriptionAdded});

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // 表单字段控制器
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nextPaymentDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  // 下拉选项值
  String? _selectedSubscriptionType;
  String? _selectedBillingCycle;
  String? _selectedCurrency = 'CNY'; // 新增货币选择，默认为人民币
  IconData? _selectedIcon;
  
  // 自动续费开关值
  bool _autoRenewal = true;
  
  // 订阅类型选项
  final List<String> _subscriptionTypes = [
    '娱乐',
    '工作',
    '生活',
    '学习',
    '其他'
  ];
  
  // 计费周期选项
  final List<String> _billingCycles = [
    '每月',
    '每年',
    '一次性'
  ];
  
  // 货币选项
  final Map<String, String> _currencies = {
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
  void dispose() {
    // 释放控制器资源
    _serviceNameController.dispose();
    _priceController.dispose();
    _nextPaymentDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加新订阅'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入服务名称';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择订阅类型';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 价格
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: '价格',
                    hintText: '请输入价格',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入价格';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效数字';
                    }
                    return null;
                  },
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
                      child: Text('${entry.value}'), // 显示货币全称和符号
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择货币';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择计费周期';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择下次付费日期';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 自动续费选项
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // 表单验证通过，创建订阅对象
              final subscription = Subscription(
                name: _serviceNameController.text,
                icon: _selectedIcon?.codePoint.toString(),
                type: _selectedSubscriptionType!,
                price: double.parse(_priceController.text),
                currency: _selectedCurrency ?? 'CNY', // 添加货币信息
                billingCycle: _selectedBillingCycle!,
                nextPaymentDate: DateTime.parse(_nextPaymentDateController.text),
                autoRenewal: _autoRenewal,
                notes: _notesController.text.isNotEmpty ? _notesController.text : null,
              );
              
              // 调用回调函数传递新订阅，包含图标信息
              widget.onSubscriptionAdded?.call(subscription.copyWith(icon: _selectedIcon?.codePoint.toString()));
              
              // 关闭对话框
              Navigator.of(context).pop();
              
              // 显示成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订阅添加成功')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('保存'),
        ),
      ],
    );
  }
}

class EditSubscriptionDialog extends StatefulWidget {
  final Subscription subscription;
  final Function(Subscription) onSubscriptionUpdated;
  final Function(String) onSubscriptionDeleted;

  const EditSubscriptionDialog({
    super.key,
    required this.subscription,
    required this.onSubscriptionUpdated,
    required this.onSubscriptionDeleted,
  });

  @override
  State<EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // 表单字段控制器
  late final TextEditingController _serviceNameController = TextEditingController(text: widget.subscription.name);
  late final TextEditingController _priceController = TextEditingController(text: widget.subscription.price.toString());
  late final TextEditingController _nextPaymentDateController = TextEditingController(
      text: "${widget.subscription.nextPaymentDate.year}-${widget.subscription.nextPaymentDate.month.toString().padLeft(2, '0')}-${widget.subscription.nextPaymentDate.day.toString().padLeft(2, '0')}");
  late final TextEditingController _notesController = TextEditingController(text: widget.subscription.notes ?? '');
  
  // 下拉选项值
  String? _selectedSubscriptionType;
  String? _selectedBillingCycle;
  String? _selectedCurrency = 'CNY'; // 新增货币选择，默认为人民币
  IconData? _selectedIcon;
  
  // 自动续费开关值
  late bool _autoRenewal = widget.subscription.autoRenewal;
  
  // 订阅类型选项
  final List<String> _subscriptionTypes = [
    '娱乐',
    '工作',
    '生活',
    '学习',
    '其他'
  ];
  
  // 计费周期选项
  final List<String> _billingCycles = [
    '每月',
    '每年',
    '一次性'
  ];
  
  // 货币选项
  final Map<String, String> _currencies = {
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
  
  // 图标选项
  final List<IconData> _iconOptions = [
    Icons.music_note,
    Icons.movie,
    Icons.games,
    Icons.phone_iphone,
    Icons.computer,
    Icons.tv,
    Icons.book,
    Icons.fitness_center,
    Icons.fastfood,
    Icons.local_shipping,
    Icons.home,
    Icons.account_balance,
  ];

  @override
  void initState() {
    super.initState();
    _selectedSubscriptionType = widget.subscription.type;
    _selectedBillingCycle = widget.subscription.billingCycle;
    
    // 初始化货币选择
    _selectedCurrency = widget.subscription.currency ?? 'CNY';
    
    // 解析图标
    if (widget.subscription.icon != null) {
      try {
        _selectedIcon = IconData(int.parse(widget.subscription.icon!), fontFamily: 'MaterialIcons');
      } catch (e) {
        // 如果解析失败，使用默认图标
        _selectedIcon = null;
      }
    }
  }

  @override
  void dispose() {
    // 释放控制器资源
    _serviceNameController.dispose();
    _priceController.dispose();
    _nextPaymentDateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _deleteSubscription() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认删除'),
          content: Text('确定要删除"${widget.subscription.name}"这个订阅吗？此操作无法撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 关闭编辑对话框
                widget.onSubscriptionDeleted(widget.subscription.id);
              },
              child: const Text('删除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  void _showIconPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '选择图标',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 64,
                        childAspectRatio: 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _iconOptions.length,
                      itemBuilder: (context, index) {
                        final icon = _iconOptions[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIcon = icon;
                            });
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: icon == _selectedIcon
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.surface,
                            ),
                            child: Icon(
                              icon,
                              size: 32,
                              color: icon == _selectedIcon
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).iconTheme.color,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑订阅'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Form(
          key: _formKey,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入服务名称';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择订阅类型';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 价格
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: '价格',
                    hintText: '请输入价格',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入价格';
                    }
                    if (double.tryParse(value) == null) {
                      return '请输入有效数字';
                    }
                    return null;
                  },
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
                      child: Text('${entry.value}'), // 显示货币全称和符号
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择货币';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择计费周期';
                    }
                    return null;
                  },
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请选择下次付费日期';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 自动续费选项
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.5),
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: _deleteSubscription,
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('删除'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // 表单验证通过，创建订阅对象
              final updatedSubscription = widget.subscription.copyWith(
                name: _serviceNameController.text,
                icon: _selectedIcon?.codePoint.toString(),
                type: _selectedSubscriptionType!,
                price: double.parse(_priceController.text),
                billingCycle: _selectedBillingCycle!,
                nextPaymentDate: DateTime.parse(_nextPaymentDateController.text),
                autoRenewal: _autoRenewal,
                notes: _notesController.text.isNotEmpty ? _notesController.text : null,
              );
              
              // 调用回调函数传递更新后的订阅
              widget.onSubscriptionUpdated(updatedSubscription);
              
              // 关闭对话框
              Navigator.of(context).pop();
              
              // 显示成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订阅更新成功')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('保存'),
        ),
      ],
    );
  }
}
