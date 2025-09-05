#!/bin/bash

# 代码混淆配置验证脚本

echo "验证代码混淆配置..."

# 检查ProGuard规则文件是否存在
if [ -f "android/app/proguard/proguard-rules.pro" ]; then
    echo "✓ ProGuard规则文件存在"
else
    echo "✗ ProGuard规则文件不存在"
fi

# 检查Android构建配置是否正确
if grep -q "isMinifyEnabled = true" "android/app/build.gradle.kts"; then
    echo "✓ Android混淆配置已启用"
else
    echo "✗ Android混淆配置未启用"
fi

# 检查构建脚本是否存在
if [ -f "scripts/build-obfuscated.sh" ]; then
    echo "✓ 构建脚本存在"
else
    echo "✗ 构建脚本不存在"
fi

if [ -f "scripts/build-obfuscated.bat" ]; then
    echo "✓ Windows构建脚本存在"
else
    echo "✗ Windows构建脚本不存在"
fi

echo "配置验证完成。"