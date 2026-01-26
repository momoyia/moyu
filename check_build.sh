#!/bin/bash

echo "🔍 检查 iOS 项目配置..."
echo ""

echo "1️⃣ 检查架构设置："
cd ios
xcodebuild -showBuildSettings -project Runner.xcodeproj -target Runner -configuration Debug 2>/dev/null | grep -E "ARCHS|VALID_ARCHS|EXCLUDED_ARCHS"
echo ""

echo "2️⃣ 检查 CocoaPods 状态："
pod --version
echo ""

echo "3️⃣ 检查 Flutter 配置："
cd ..
flutter doctor -v
echo ""

echo "✅ 检查完成！"
echo ""
echo "现在请在 Xcode 中："
echo "1. 打开 ios/Runner.xcworkspace"
echo "2. 选择你的 iPhone 16e 设备"
echo "3. 点击 Product > Clean Build Folder (Shift+Cmd+K)"
echo "4. 点击运行按钮"
echo "5. 如果有错误，请复制完整的错误信息给我"
