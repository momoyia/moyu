#!/bin/bash

echo "🔧 修复 iOS 构建问题..."

# 1. 清理项目
echo "1️⃣ 清理 Flutter 项目..."
flutter clean

# 2. 删除 iOS 构建缓存
echo "2️⃣ 删除 iOS 缓存..."
rm -rf ios/Pods
rm -rf ios/Podfile.lock
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec

# 3. 获取依赖
echo "3️⃣ 获取 Flutter 依赖..."
flutter pub get

# 4. 安装 CocoaPods
echo "4️⃣ 安装 CocoaPods 依赖..."
cd ios
pod deintegrate
pod install
cd ..

# 5. 构建项目
echo "5️⃣ 构建 iOS 项目..."
flutter build ios --debug --no-codesign

echo "✅ 修复完成！现在可以在 Xcode 中运行项目了。"
