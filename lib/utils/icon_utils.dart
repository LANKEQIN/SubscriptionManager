import 'package:flutter/material.dart';

class IconUtils {
  /// 从订阅图标字符串创建图标组件
  static Widget buildSubscriptionIcon(BuildContext context, String? iconCode, {double size = 24}) {
    final IconData iconData = getIconData(iconCode);
    
    return Icon(
      iconData,
      color: Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
  
  /// 从订阅图标字符串获取IconData
  static IconData getIconData(String? iconCode) {
    // 使用预定义的常量图标，避免运行时动态创建IconData
    // 这里可以扩展为映射表，将特定的iconCode映射到预定义的常量图标
    if (iconCode == null) {
      return Icons.subscriptions_outlined;
    }
    
    // 由于tree shaking要求使用常量IconData，这里返回一个默认图标
    // 如果需要支持特定图标，应该预先定义所有可能的图标常量
    return Icons.subscriptions_outlined;
  }
}