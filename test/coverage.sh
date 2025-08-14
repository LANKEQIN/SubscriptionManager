#!/bin/bash

echo "生成测试覆盖率报告..."

# 运行测试并生成覆盖率数据
flutter test --coverage

# 如果有lcov工具，则生成HTML报告
if command -v genhtml &> /dev/null
then
    echo "生成HTML覆盖率报告..."
    genhtml coverage/lcov.info -o coverage/html
    echo "HTML报告已生成在 coverage/html/index.html"
else
    echo "提示: 安装 lcov 工具以生成HTML报告"
    echo "Ubuntu/Debian: sudo apt install lcov"
    echo "macOS: brew install lcov"
fi

echo "测试覆盖率报告生成完成！"