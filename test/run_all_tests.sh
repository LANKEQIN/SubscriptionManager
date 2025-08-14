#!/bin/bash

echo "开始运行所有测试..."

echo "1. 运行单元测试..."
flutter test

echo "2. 运行集成测试..."
flutter test integration_test

echo "3. 检查代码格式..."
dart format --output=none --set-exit-if-changed .

echo "4. 分析项目源代码..."
flutter analyze

echo "所有测试完成！"