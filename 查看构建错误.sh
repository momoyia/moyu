#!/bin/bash

echo "🔍 检查 iOS 构建错误..."
echo ""

# 尝试构建并捕获错误
flutter build ios --debug --no-codesign 2>&1 | tee build_error.log

echo ""
echo "✅ 错误日志已保存到 build_error.log"
echo "请将错误信息发送给我"
