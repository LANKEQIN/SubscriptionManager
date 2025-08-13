import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _baseCurrencyKey = 'baseCurrency';
  
  // 默认基准货币为人民币
  static const String defaultBaseCurrency = 'CNY';
  
  /// 获取用户选择的基准货币
  static Future<String> getBaseCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_baseCurrencyKey) ?? defaultBaseCurrency;
  }
  
  /// 设置用户选择的基准货币
  static Future<void> setBaseCurrency(String currencyCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseCurrencyKey, currencyCode);
  }
}