import 'package:flutter/material.dart';
import 'subscription.dart';
import 'dart:math';

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
                    labelText: '服务名称 *',
                    hintText: '请输入订阅服务名称',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '请输入服务名称';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // 图标选择 (简化版 - 后续可扩展)
                const Row(
                  children: [
                    Text('图标选择', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(width: 8),
                    Icon(Icons.image, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('(后续可选择或上传图标)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // 订阅类型
                DropdownButtonFormField<String>(
                  value: _selectedSubscriptionType,
                  decoration: const InputDecoration(
                    labelText: '订阅类型 *',
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
                    labelText: '价格 *',
                    hintText: '请输入价格',
                    prefixText: '¥ ',
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
                
                // 计费周期
                DropdownButtonFormField<String>(
                  value: _selectedBillingCycle,
                  decoration: const InputDecoration(
                    labelText: '计费周期 *',
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
                    labelText: '下次付费日期 *',
                    hintText: '请选择日期',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('是否开启自动续费'),
                    Switch(
                      value: _autoRenewal,
                      onChanged: (value) {
                        setState(() {
                          _autoRenewal = value;
                        });
                      },
                    ),
                  ],
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
                id: Random().nextInt(100000).toString(),
                name: _serviceNameController.text,
                type: _selectedSubscriptionType!,
                price: double.parse(_priceController.text),
                billingCycle: _selectedBillingCycle!,
                nextPaymentDate: DateTime.parse(_nextPaymentDateController.text),
                autoRenewal: _autoRenewal,
                notes: _notesController.text.isNotEmpty ? _notesController.text : null,
              );
              
              // 调用回调函数传递新订阅
              widget.onSubscriptionAdded?.call(subscription);
              
              // 关闭对话框
              Navigator.of(context).pop();
              
              // 显示成功提示
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('订阅添加成功')),
              );
            }
          },
          child: const Text('保存'),
        ),
      ],
    );
  }
}