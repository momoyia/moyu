#!/bin/bash

set -e

echo "🚀 开始完整修复 iOS 构建问题..."
echo ""

# 1. 清理 Flutter 项目
echo "1️⃣ 清理 Flutter 项目..."
flutter clean
echo "✅ Flutter 清理完成"
echo ""

# 2. 删除 iOS 缓存
echo "2️⃣ 删除 iOS 缓存和依赖..."
cd ios
rm -rf Pods
rm -rf Podfile.lock
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
cd ..
echo "✅ iOS 缓存清理完成"
echo ""

# 3. 获取 Flutter 依赖
echo "3️⃣ 获取 Flutter 依赖..."
flutter pub get
echo "✅ Flutter 依赖获取完成"
echo ""

# 4. 安装 CocoaPods
echo "4️⃣ 安装 CocoaPods 依赖..."
cd ios
pod install
cd ..
echo "✅ CocoaPods 安装完成"
echo ""

# 5. 打开 Xcode
echo "5️⃣ 打开 Xcode 项目..."
open ios/Runner.xcworkspace

echo ""
echo "✅ 自动修复完成！"
echo ""
echo "📋 接下来请在 Xcode 中手动完成以下步骤："
echo ""
echo "1. 等待 Xcode 完全打开"
echo "2. 在左侧选择 'Runner' 项目"
echo "3. 选择 'Runner' target"
echo "4. 点击 'Build Settings' 标签"
echo "5. 搜索 'Architectures'"
echo "6. 确认以下设置："
echo "   - Architectures: arm64 或 \$(ARCHS_STANDARD)"
echo "   - Valid Architectures: arm64 arm64e"
echo "   - Build Active Architecture Only (Debug): Yes"
echo "7. 在顶部选择你的 iPhone 16e 设备"
echo "8. 点击运行按钮 (▶️) 或按 Cmd+R"
echo ""
echo "如果还有问题，请查看 'iOS架构修复指南.md' 文件"
