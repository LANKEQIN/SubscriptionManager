import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';

/// 主题构建器
/// 负责创建和管理应用的主题配置
class AppThemeBuilder {
  /// 私有构造函数，防止实例化
  AppThemeBuilder._();

  /// 构建文本主题
  /// [fontSize] 基础字体大小
  static TextTheme buildTextTheme(double fontSize) {
    return TextTheme(
      bodySmall: _buildTextStyle(
        fontSize, 
        AppThemeConstants.fontSizeIncrements['bodySmall']!
      ),
      bodyMedium: _buildTextStyle(
        fontSize, 
        AppThemeConstants.fontSizeIncrements['bodyMedium']!
      ),
      bodyLarge: _buildTextStyle(
        fontSize, 
        AppThemeConstants.fontSizeIncrements['bodyLarge']!
      ),
      titleSmall: _buildTextStyle(
        fontSize, 
        AppThemeConstants.fontSizeIncrements['titleSmall']!
      ),
      titleMedium: _buildTextStyle(
        fontSize, 
        AppThemeConstants.fontSizeIncrements['titleMedium']!
      ),
      titleLarge: _buildTextStyle(
        fontSize, 
        AppThemeConstants.fontSizeIncrements['titleLarge']!
      ),
    );
  }

  /// 构建单个文本样式
  /// [baseSize] 基础字体大小
  /// [increment] 字体大小增量
  static TextStyle _buildTextStyle(double baseSize, int increment) {
    return TextStyle(
      fontSize: ThemeConfigHelper.calculateFontSize(baseSize, increment),
      fontFamily: AppThemeConstants.primaryFontFamily,
      fontFamilyFallback: AppThemeConstants.fontFallbacks,
    );
  }

  /// 构建亮色主题
  /// [colorScheme] 颜色方案
  /// [fontSize] 字体大小
  static ThemeData buildLightTheme(ColorScheme colorScheme, double fontSize) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: AppThemeConstants.primaryFontFamily,
      textTheme: buildTextTheme(fontSize),
    );
  }

  /// 构建暗色主题
  /// [colorScheme] 颜色方案
  /// [fontSize] 字体大小
  static ThemeData buildDarkTheme(ColorScheme colorScheme, double fontSize) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: AppThemeConstants.primaryFontFamily,
      textTheme: buildTextTheme(fontSize),
    );
  }

  /// 构建颜色方案
  /// [seedColor] 种子颜色
  /// [brightness] 亮度
  static ColorScheme buildColorScheme(Color seedColor, [Brightness? brightness]) {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness ?? Brightness.light,
    );
  }

  /// 获取默认颜色方案组合
  /// [customColor] 自定义颜色（可选）
  /// [lightDynamic] 系统动态亮色方案（可选）
  /// [darkDynamic] 系统动态暗色方案（可选）
  static ColorSchemeSet getColorSchemes({
    Color? customColor,
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
  }) {
    ColorScheme lightColorScheme;
    ColorScheme darkColorScheme;

    if (customColor != null) {
      // 使用用户选择的颜色
      lightColorScheme = buildColorScheme(customColor, Brightness.light);
      darkColorScheme = buildColorScheme(customColor, Brightness.dark);
    } else if (lightDynamic != null && darkDynamic != null) {
      // 使用系统动态颜色
      lightColorScheme = lightDynamic;
      darkColorScheme = darkDynamic;
    } else {
      // 使用默认颜色
      lightColorScheme = buildColorScheme(AppThemeConstants.defaultSeedColor, Brightness.light);
      darkColorScheme = buildColorScheme(AppThemeConstants.defaultSeedColor, Brightness.dark);
    }

    return ColorSchemeSet(
      light: lightColorScheme,
      dark: darkColorScheme,
    );
  }
}

/// 颜色方案组合
/// 包含亮色和暗色两种方案
class ColorSchemeSet {
  /// 亮色方案
  final ColorScheme light;
  
  /// 暗色方案  
  final ColorScheme dark;

  /// 构造函数
  const ColorSchemeSet({
    required this.light,
    required this.dark,
  });
}