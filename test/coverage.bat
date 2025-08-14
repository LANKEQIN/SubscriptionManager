@echo off
echo 生成测试覆盖率报告...

echo 运行测试并生成覆盖率数据
flutter test --coverage
if %errorlevel% neq 0 (
    echo 测试失败，无法生成覆盖率数据！
    exit /b %errorlevel%
)

echo.
echo 要生成HTML报告，请安装 lcov 工具
echo.
echo Windows上安装lcov:
echo 1. 安装Chocolatey (如果尚未安装)
echo 2. 运行: choco install lcov
echo.
echo 或者使用 scoop:
echo 运行: scoop install lcov

echo.
echo 测试覆盖率报告生成完成！