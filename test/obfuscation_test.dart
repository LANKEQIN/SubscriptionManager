import 'package:flutter_test/flutter_test.dart';
import 'dart:io';

void main() {
  group('代码混淆配置测试', () {
    test('检查ProGuard规则文件是否存在', () {
      final proguardFile = File('android/app/proguard/proguard-rules.pro');
      expect(proguardFile.existsSync(), true);
    });

    test('检查Android构建配置是否正确', () {
      final buildFile = File('android/app/build.gradle.kts');
      final content = buildFile.readAsStringSync();
      expect(content.contains('isMinifyEnabled = true'), true);
      expect(content.contains('isShrinkResources = true'), true);
    });

    test('检查构建脚本是否存在', () {
      final scriptFile = File('scripts/build-obfuscated.sh');
      expect(scriptFile.existsSync(), true);
      
      final batFile = File('scripts/build-obfuscated.bat');
      expect(batFile.existsSync(), true);
    });

    test('检查验证脚本是否存在', () {
      final scriptFile = File('scripts/verify-obfuscation.sh');
      expect(scriptFile.existsSync(), true);
      
      final batFile = File('scripts/verify-obfuscation.bat');
      expect(batFile.existsSync(), true);
    });
  });
}