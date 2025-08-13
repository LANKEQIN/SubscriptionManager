import 'package:flutter/material.dart';

class IconUtils {
  /// 从订阅图标字符串创建图标组件
  static Widget buildSubscriptionIcon(BuildContext context, String? iconCode, {double size = 24}) {
    IconData iconData;
    
    if (iconCode == null) {
      iconData = Icons.subscriptions_outlined;
    } else {
      try {
        iconData = IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
      } catch (e) {
        iconData = Icons.subscriptions_outlined;
      }
    }
    
    return Icon(
      iconData,
      color: Theme.of(context).colorScheme.primary,
      size: size,
    );
  }
  
  /// 从订阅图标字符串获取IconData
  static IconData getIconData(String? iconCode) {
    if (iconCode == null) {
      return Icons.subscriptions_outlined;
    }
    
    try {
      return IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
    } catch (e) {
      return Icons.subscriptions_outlined;
    }
  }
}