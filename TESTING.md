# 测试流程说明

本项目包含多种类型的测试，以确保代码质量和功能正确性。

## 测试类型

### 1. 单元测试 (Unit Tests)
单元测试位于 [test/](test/) 目录中，主要用于测试模型和业务逻辑。

运行单元测试:
```bash
flutter test
```

### 2. 小部件测试 (Widget Tests)
小部件测试也位于 [test/](test/) 目录中，用于测试UI组件的功能。

### 3. 集成测试 (Integration Tests)
集成测试位于 [integration_test/](integration_test/) 目录中，用于测试整个应用的端到端功能。

运行集成测试:
```bash
flutter test integration_test
```

## 自动化测试流程

### 本地测试

1. 运行所有测试:
   ```bash
   # Linux/macOS
   ./test/run_all_tests.sh
   
   # Windows
   test\run_all_tests.bat
   ```

2. 生成测试覆盖率报告:
   ```bash
   # Linux/macOS
   ./test/coverage.sh
   
   # Windows
   test\coverage.bat
   ```

### CI/CD 自动化测试

本项目配置了 GitHub Actions 工作流，位于 [.github/workflows/flutter_test.yml](.github/workflows/flutter_test.yml)。

当有代码推送到 `main` 分支或创建拉取请求时，会自动运行以下测试：
1. 代码格式检查
2. 静态代码分析
3. 单元测试
4. 集成测试

## 测试结构

```
test/
├── models/
│   └── subscription_test.dart          # 订阅模型测试
├── providers/
│   └── subscription_provider_test.dart # 提供者测试
├── widgets/
│   └── subscription_card_test.dart     # 小部件测试
├── run_all_tests.sh                    # 测试运行脚本 (Linux/macOS)
├── run_all_tests.bat                   # 测试运行脚本 (Windows)
├── coverage.sh                         # 覆盖率报告脚本 (Linux/macOS)
└── coverage.bat                        # 覆盖率报告脚本 (Windows)

integration_test/
├── app_test.dart                       # 集成测试
```

## 添加新测试

1. 根据测试类型将测试文件放在相应的目录中
2. 遵循现有的测试命名和结构约定
3. 确保新测试通过所有检查

## 测试覆盖率

要生成和查看测试覆盖率报告：

1. 运行 `./test/coverage.sh` (Linux/macOS) 或 `test\coverage.bat` (Windows)
2. 安装 lcov 工具以生成 HTML 报告（可选）
3. 查看生成的覆盖率报告