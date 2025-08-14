import 'dart:math';

class FixedExchangeRateService {
  // 固定汇率表（以USD为基准）
  static const Map<String, double> _exchangeRates = {
    'USD': 1.0,    // 美元
    'CNY': 7.2,    // 人民币
    'EUR': 0.93,   // 欧元
    'GBP': 0.79,   // 英镑
    'JPY': 150.0,  // 日元
    'KRW': 1350.0, // 韩元
    'INR': 83.0,   // 印度卢比
    'RUB': 90.0,   // 卢布
    'AUD': 1.5,    // 澳元
    'CAD': 1.35,   // 加元
    'HKD': 7.8,    // 港币
    'TWD': 32.0,   // 新台币
    'SGD': 1.35,   // 新加坡元
  };

  /// 将指定金额从一种货币转换为另一种货币
  double convertCurrency(double amount, String fromCurrency, String toCurrency) {
    // 如果源货币和目标货币相同，直接返回原金额
    if (fromCurrency == toCurrency) {
      return amount;
    }

    // 获取源货币到USD的汇率
    final fromRate = _exchangeRates[fromCurrency];
    if (fromRate == null) {
      throw Exception('不支持的源货币: $fromCurrency');
    }

    // 获取USD到目标货币的汇率
    final toRate = _exchangeRates[toCurrency];
    if (toRate == null) {
      throw Exception('不支持的目标货币: $toCurrency');
    }

    // 通过USD进行转换
    final amountInUSD = amount / fromRate;
    final result = amountInUSD * toRate;
    
    return result;
  }

  /// 获取所有支持的货币代码
  List<String> getSupportedCurrencies() {
    return _exchangeRates.keys.toList();
  }

  /// 获取指定货币的汇率（相对于USD）
  double getExchangeRate(String currency) {
    return _exchangeRates[currency] ?? 1.0;
  }
}