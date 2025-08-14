@echo off
echo 开始运行所有测试...

echo 1. 运行单元测试...
flutter test
if %errorlevel% neq 0 (
    echo 单元测试失败！
    exit /b %errorlevel%
)

echo 2. 运行集成测试...
flutter test integration_test
if %errorlevel% neq 0 (
    echo 集成测试失败！
    exit /b %errorlevel%
)

echo 3. 检查代码格式...
dart format --output=none --set-exit-if-changed .
if %errorlevel% neq 0 (
    echo 代码格式检查失败！
    exit /b %errorlevel%
)

echo 4. 分析项目源代码...
flutter analyze
if %errorlevel% neq 0 (
    echo 代码分析失败！
    exit /b %errorlevel%
)

echo 所有测试完成！