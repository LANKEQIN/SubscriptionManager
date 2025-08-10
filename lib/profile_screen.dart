import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subscription_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 字体大小选项
  final List<double> fontSizeOptions = [12.0, 14.0, 16.0, 18.0, 20.0];
  
  // 预定义的主题颜色选项
  final List<Color> themeColors = [
    Colors.blue,      // 默认蓝色
    Colors.red,       // 红色
    Colors.green,     // 绿色
    Colors.purple,    // 紫色
    Colors.orange,    // 橙色
    Colors.pink,      // 粉色
    Colors.teal,      // 蓝绿色
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '设置',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // 主题设置
            Card(
              child: ListTile(
                title: const Text('主题设置'),
                subtitle: const Text('选择应用主题模式'),
                trailing: Consumer<SubscriptionProvider>(
                  builder: (context, provider, child) {
                    return DropdownButton<ThemeMode>(
                      value: provider.themeMode,
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('跟随系统'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('浅色'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('深色'),
                        ),
                      ],
                      onChanged: (ThemeMode? mode) {
                        if (mode != null) {
                          provider.updateThemeMode(mode);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 主题颜色设置
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '主题颜色',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('选择应用主题颜色'),
                    const SizedBox(height: 16),
                    Consumer<SubscriptionProvider>(
                      builder: (context, provider, child) {
                        return Row(
                          children: [
                            // 跟随系统颜色选项
                            GestureDetector(
                              onTap: () {
                                provider.updateThemeColor(null);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                      border: provider.themeColor == null
                                          ? Border.all(color: Colors.blue, width: 3)
                                          : null,
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text('自动', style: TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // 预定义颜色选项
                            Expanded(
                              child: GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                shrinkWrap: true,
                                children: themeColors.map((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      provider.updateThemeColor(color);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(20),
                                        border: provider.themeColor == color
                                            ? Border.all(color: Colors.blue, width: 3)
                                            : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 字体大小设置
            Card(
              child: ListTile(
                title: const Text('字体大小'),
                subtitle: const Text('调整应用字体大小'),
                trailing: Consumer<SubscriptionProvider>(
                  builder: (context, provider, child) {
                    return DropdownButton<double>(
                      value: provider.fontSize,
                      items: fontSizeOptions.map((double size) {
                        return DropdownMenuItem<double>(
                          value: size,
                          child: Text('${size.toInt()}'),
                        );
                      }).toList(),
                      onChanged: (double? size) {
                        if (size != null) {
                          provider.updateFontSize(size);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}