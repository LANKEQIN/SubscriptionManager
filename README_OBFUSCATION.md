# 代码混淆配置说明

本项目已配置代码混淆功能，以提高应用程序的安全性。

## Android平台混淆配置

Android平台的混淆配置已添加到以下文件中：
1. `android/app/proguard/proguard-rules.pro` - ProGuard混淆规则文件
2. `android/app/build.gradle.kts` - 已启用混淆配置

### Android混淆特性
- 启用了代码压缩（minifyEnabled）
- 启用了资源压缩（shrinkResources）
- 使用了自定义的ProGuard规则

## iOS平台混淆

iOS平台的代码混淆通过Flutter构建命令实现。

## 构建混淆版本

### 使用构建脚本（推荐）

#### Windows系统
```bash
scripts\build-obfuscated.bat
```

#### macOS/Linux系统
```bash
chmod +x scripts/build-obfuscated.sh
scripts/build-obfuscated.sh
```

### 手动构建命令

#### 构建Android APK（混淆版本）
```bash
flutter build apk --obfuscate --split-debug-info=./build/symbols
```

#### 构建Android App Bundle（混淆版本）
```bash
flutter build appbundle --obfuscate --split-debug-info=./build/symbols
```

#### 构建iOS（混淆版本）
```bash
flutter build ios --obfuscate --split-debug-info=./build/symbols
```

#### 构建IPA（混淆版本）
```bash
flutter build ipa --obfuscate --split-debug-info=./build/symbols
```

## 符号文件

混淆构建过程中会生成符号文件，用于调试混淆后的堆栈跟踪信息。这些文件保存在 `./build/symbols` 目录中，请务必备份这些文件以便后续调试使用。

## 注意事项

1. 代码混淆仅适用于Release构建模式
2. 混淆后的代码可能会影响依赖特定类名或函数名的逻辑
3. 如需调试混淆后的错误，请使用 `flutter symbolize` 命令结合符号文件还原堆栈信息