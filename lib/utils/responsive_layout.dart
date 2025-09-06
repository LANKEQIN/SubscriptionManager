import 'package:flutter/material.dart';
import 'dart:io';

/// 设备类型枚举
enum DeviceType {
  mobile,    // 手机
  tablet,    // 平板
  desktop,   // 桌面
}

/// 屏幕尺寸断点
class BreakPoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
}

/// 响应式布局管理器
class ResponsiveLayout {
  /// 获取设备类型
  static DeviceType getDeviceType(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < BreakPoints.mobile) {
      return DeviceType.mobile;
    } else if (screenWidth < BreakPoints.tablet) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }
  
  /// 检查是否为大屏设备（平板或桌面）
  static bool isLargeScreen(BuildContext context) {
    final deviceType = getDeviceType(context);
    return deviceType == DeviceType.tablet || deviceType == DeviceType.desktop;
  }
  
  /// 检查是否为桌面设备
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }
  
  /// 检查是否为平板设备
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }
  
  /// 检查是否为手机设备
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }
  
  /// 获取平台类型
  static bool isWindows() {
    return Platform.isWindows;
  }
  
  static bool isIOS() {
    return Platform.isIOS;
  }
  
  static bool isAndroid() {
    return Platform.isAndroid;
  }
  
  static bool isMacOS() {
    return Platform.isMacOS;
  }
  
  /// 根据屏幕尺寸返回不同的值
  static T responsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
  
  /// 获取适合的列数
  static int getColumnCount(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }
  
  /// 获取适合的侧边栏宽度
  static double getSidebarWidth(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 0,
      tablet: 280,
      desktop: 320,
    );
  }
  
  /// 获取内容区域的最大宽度
  static double getMaxContentWidth(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: double.infinity,
      tablet: 800,
      desktop: 1200,
    );
  }
  
  /// 获取卡片间距
  static double getCardSpacing(BuildContext context) {
    return responsiveValue(
      context: context,
      mobile: 16.0,
      tablet: 20.0,
      desktop: 24.0,
    );
  }
  
  /// 获取页面边距
  static EdgeInsets getPagePadding(BuildContext context) {
    final padding = responsiveValue(
      context: context,
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    );
    return EdgeInsets.all(padding);
  }
}

/// 响应式构建器组件
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;
  
  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });
  
  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveLayout.getDeviceType(context);
    return builder(context, deviceType);
  }
}

/// 响应式包装器组件
class ResponsiveWrapper extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveWrapper({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType) {
        switch (deviceType) {
          case DeviceType.mobile:
            return mobile;
          case DeviceType.tablet:
            return tablet ?? mobile;
          case DeviceType.desktop:
            return desktop ?? tablet ?? mobile;
        }
      },
    );
  }
}