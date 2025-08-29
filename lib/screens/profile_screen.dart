import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../constants/theme_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
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
              const SizedBox(height: AppThemeConstants.largeSpacing),
              
              // 主题设置
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
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
                        underline: Container(), // 移除下划线
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: AppThemeConstants.standardPadding),
              
              // 主题颜色设置
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '主题颜色',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppThemeConstants.smallSpacing),
                      const Text('选择应用主题颜色'),
                      const SizedBox(height: AppThemeConstants.standardPadding),
                      Consumer<SubscriptionProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 跟随系统颜色选项
                              GestureDetector(
                                onTap: () {
                                  provider.updateThemeColor(null);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                        border: provider.themeColor == null
                                            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
                                            : null,
                                      ),
                                      child: const Icon(
                                        Icons.auto_awesome,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Text('自动', style: TextStyle(fontSize: 16)),
                                    const Spacer(),
                                    if (provider.themeColor == null)
                                      Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppThemeConstants.standardPadding),
                              const Text(
                                '预设颜色',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppThemeConstants.componentSpacing),
                              // 预定义颜色选项
                              GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: AppThemeConstants.presetThemeColors.map((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      provider.updateThemeColor(color);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(AppThemeConstants.componentSpacing),
                                        border: provider.themeColor == color
                                            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3)
                                            : Border.all(color: Colors.grey.withValues(alpha: 0.5)),
                                      ),
                                      child: provider.themeColor == color 
                                          ? Icon(Icons.check, color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                                          : null,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppThemeConstants.standardPadding),
              
              // 字体大小设置
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: ListTile(
                  title: const Text('字体大小'),
                  subtitle: const Text('调整应用字体大小'),
                  trailing: Consumer<SubscriptionProvider>(
                    builder: (context, provider, child) {
                      return DropdownButton<double>(
                        value: provider.fontSize,
                        items: AppThemeConstants.fontSizeOptions.map((double size) {
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
                        underline: Container(), // 移除下划线
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: AppThemeConstants.largeSpacing * 1.33), // 32
              
              // 应用信息
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeConstants.standardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppThemeConstants.standardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '应用信息',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppThemeConstants.standardPadding),
                      const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('版本'),
                        subtitle: Text('1.0.0'),
                      ),
                      const SizedBox(height: AppThemeConstants.smallSpacing),
                      ListTile(
                        leading: const Icon(Icons.star_border),
                        title: const Text('给我们评分'),
                        onTap: () {
                          // TODO: 实现评分功能
                        },
                      ),
                      const SizedBox(height: AppThemeConstants.smallSpacing),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text('隐私政策'),
                        onTap: () {
                          // TODO: 实现隐私政策页面
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}