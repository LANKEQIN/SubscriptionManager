import 'package:flutter_test/flutter_test.dart';
import 'package:subscription_manager/fixed_exchange_rate_service.dart';

void main() {
  group('Currency Conversion Tests', () {
    final exchangeService = FixedExchangeRateService();
    
    test('Same currency conversion', () {
      final result = exchangeService.convertCurrency(100.0, 'CNY', 'CNY');
      expect(result, 100.0);
    });
    
    test('USD to CNY conversion', () {
      final result = exchangeService.convertCurrency(10.0, 'USD', 'CNY');
      expect(result, closeTo(72.0, 0.1));
    });
    
    test('EUR to CNY conversion', () {
      final result = exchangeService.convertCurrency(5.0, 'EUR', 'CNY');
      expect(result, greaterThan(30.0));
    });
    
    test('Monthly fee calculation scenario', () {
      const subscription1Monthly = 68.0;
      const subscription2Yearly = 120.0;
      const subscription2Monthly = subscription2Yearly / 12;
      final subscription2MonthlyCNY = exchangeService.convertCurrency(subscription2Monthly, 'USD', 'CNY');
      
      final totalMonthlyCNY = subscription1Monthly + subscription2MonthlyCNY;
      expect(totalMonthlyCNY, greaterThan(130.0));
      
      const subscription1Yearly = subscription1Monthly * 12;
      final subscription2YearlyCNY = exchangeService.convertCurrency(subscription2Yearly, 'USD', 'CNY');
      final totalYearlyCNY = subscription1Yearly + subscription2YearlyCNY;
      expect(totalYearlyCNY, greaterThan(1500.0));
    });
  });
}