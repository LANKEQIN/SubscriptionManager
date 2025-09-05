#!/bin/bash

# Flutter应用混淆构建脚本

# 设置符号文件目录（用于调试混淆后的堆栈跟踪）
SYMBOLS_DIR="./build/symbols"

# 创建符号文件目录
mkdir -p $SYMBOLS_DIR

echo "开始构建混淆版本..."

# 构建Android APK（混淆版本）
echo "构建Android APK（混淆版本）..."
flutter build apk --obfuscate --split-debug-info=$SYMBOLS_DIR

# 构建Android App Bundle（混淆版本）
echo "构建Android App Bundle（混淆版本）..."
flutter build appbundle --obfuscate --split-debug-info=$SYMBOLS_DIR

# 构建iOS（混淆版本）
echo "构建iOS（混淆版本）..."
flutter build ios --obfuscate --split-debug-info=$SYMBOLS_DIR

# 构建IPA（混淆版本）
echo "构建IPA（混淆版本）..."
flutter build ipa --obfuscate --split-debug-info=$SYMBOLS_DIR

echo "所有平台的混淆构建已完成！"
echo "符号文件已保存到: $SYMBOLS_DIR"