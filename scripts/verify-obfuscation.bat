@echo off
:: 代码混淆配置验证脚本（Windows版本）

echo 验证代码混淆配置...

:: 检查ProGuard规则文件是否存在
if exist "android\app\proguard\proguard-rules.pro" (
    echo ✓ ProGuard规则文件存在
) else (
    echo ✗ ProGuard规则文件不存在
)

:: 检查Android构建配置是否正确
findstr "isMinifyEnabled = true" "android\app\build.gradle.kts" >nul
if %errorlevel% == 0 (
    echo ✓ Android混淆配置已启用
) else (
    echo ✗ Android混淆配置未启用
)

:: 检查构建脚本是否存在
if exist "scripts\build-obfuscated.sh" (
    echo ✓ 构建脚本存在
) else (
    echo ✗ 构建脚本不存在
)

if exist "scripts\build-obfuscated.bat" (
    echo ✓ Windows构建脚本存在
) else (
    echo ✗ Windows构建脚本不存在
)

echo 配置验证完成。