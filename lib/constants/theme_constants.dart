import 'package:flutter/material.dart';

/// 应用主题配置常量
/// 统一管理字体、颜色、尺寸等主题相关配置
class AppThemeConstants {
  /// 私有构造函数，防止实例化
  AppThemeConstants._();

  // ==================== 字体配置 ====================
  
  /// 主字体系列列表（按优先级排序）
  static const List<String> fontFamilies = [
    'HarmonyOS Sans', 
    'Segoe UI', 
    'Roboto', 
    'sans-serif'
  ];
  
  /// 主要字体家族
  static const String primaryFontFamily = 'HarmonyOS Sans';
  
  /// 字体后备列表
  static const List<String> fontFallbacks = [
    'Segoe UI', 
    'Roboto', 
    'sans-serif'
  ];

  // ==================== 字体大小配置 ====================
  
  /// 默认字体大小
  static const double defaultFontSize = 16.0;
  
  /// 字体大小选项
  static const List<double> fontSizeOptions = [
    12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0
  ];
  
  /// 字体大小增量映射
  static const Map<String, int> fontSizeIncrements = {
    'bodySmall': -2,
    'bodyMedium': 0,
    'bodyLarge': 2,
    'titleSmall': 2,
    'titleMedium': 4,
    'titleLarge': 6,
  };

  // ==================== 颜色配置 ====================
  
  /// 默认主题色
  static const Color defaultSeedColor = Colors.deepPurple;
  
  /// 预设主题颜色列表
  static const List<Color> presetThemeColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];

  // ==================== 卡片和组件尺寸 ====================
  
  /// 标准圆角半径
  static const double standardBorderRadius = 12.0;
  
  /// 大圆角半径（用于卡片）
  static const double cardBorderRadius = 16.0;
  
  /// 标准内边距
  static const double standardPadding = 16.0;
  
  /// 组件间距
  static const double componentSpacing = 12.0;
  
  /// 小间距
  static const double smallSpacing = 8.0;
  
  /// 大间距
  static const double largeSpacing = 24.0;

  // ==================== 响应式断点 ====================
  
  /// 小屏幕断点
  static const double smallScreenBreakpoint = 350.0;
  
  /// 中等屏幕断点
  static const double mediumScreenBreakpoint = 600.0;
  
  /// 大屏幕断点
  static const double largeScreenBreakpoint = 900.0;

  // ==================== 图标尺寸 ====================
  
  /// 小图标尺寸
  static const double smallIconSize = 20.0;
  
  /// 标准图标尺寸
  static const double standardIconSize = 24.0;
  
  /// 大图标尺寸
  static const double largeIconSize = 32.0;

  // ==================== 底部导航栏配置 ====================
  
  /// 小屏幕底部导航栏高度
  static const double smallNavigationBarHeight = 60.0;
  
  /// 标准底部导航栏高度
  static const double standardNavigationBarHeight = 80.0;
}

/// 主题配置工具类
/// 提供主题相关的工具方法
class ThemeConfigHelper {
  /// 私有构造函数，防止实例化
  ThemeConfigHelper._();

  /// 计算字体大小
  /// [baseSize] 基础字体大小
  /// [increment] 增量
  static double calculateFontSize(double baseSize, int increment) {
    return baseSize + increment;
  }

  /// 根据屏幕宽度判断是否为小屏幕
  static bool isSmallScreen(double screenWidth) {
    return screenWidth < AppThemeConstants.smallScreenBreakpoint;
  }

  /// 根据屏幕宽度判断是否为中等屏幕
  static bool isMediumScreen(double screenWidth) {
    return screenWidth >= AppThemeConstants.smallScreenBreakpoint && 
           screenWidth < AppThemeConstants.largeScreenBreakpoint;
  }

  /// 根据屏幕宽度判断是否为大屏幕
  static bool isLargeScreen(double screenWidth) {
    return screenWidth >= AppThemeConstants.largeScreenBreakpoint;
  }

  /// 根据屏幕大小获取图标尺寸
  static double getIconSize(bool isSmallScreen) {
    return isSmallScreen 
        ? AppThemeConstants.smallIconSize 
        : AppThemeConstants.standardIconSize;
  }

  /// 根据屏幕大小获取导航栏高度
  static double getNavigationBarHeight(bool isSmallScreen) {
    return isSmallScreen 
        ? AppThemeConstants.smallNavigationBarHeight 
        : AppThemeConstants.standardNavigationBarHeight;
  }
}