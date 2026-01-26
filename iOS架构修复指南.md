# iOS 架构修复指南

## 问题
错误信息：`Runner's architectures (Intel 64-bit) include none that iPhone 16e can execute (arm64).`

这表示项目配置为 Intel 架构，但 iPhone 需要 arm64 架构。

## 解决方案

### 方法 1：在 Xcode 中手动修复（推荐）

1. **打开项目**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **选择 Runner target**
   - 在左侧项目导航器中点击 "Runner"
   - 确保选中 "Runner" target（不是 project）

3. **修改 Build Settings**
   - 点击 "Build Settings" 标签
   - 在搜索框中输入 "Architectures"
   
4. **设置正确的架构**
   - **Architectures**: 设置为 `$(ARCHS_STANDARD)` 或 `arm64`
   - **Valid Architectures**: 设置为 `arm64 arm64e`
   - **Excluded Architectures (Debug)**: 
     - 对于 "Any iOS Simulator SDK": 设置为 `i386`
   - **Build Active Architecture Only**: 
     - Debug: `Yes`
     - Release: `No`

5. **清理并重新构建**
   - 菜单: Product > Clean Build Folder (⇧⌘K)
   - 菜单: Product > Build (⌘B)

### 方法 2：使用命令行

```bash
# 1. 清理项目
flutter clean

# 2. 删除 Pods
cd ios
rm -rf Pods Podfile.lock
cd ..

# 3. 重新获取依赖
flutter pub get

# 4. 重新安装 Pods
cd ios
pod install
cd ..

# 5. 在 Xcode 中打开并按照方法 1 的步骤 2-5 操作
open ios/Runner.xcworkspace
```

### 方法 3：检查设备选择

确保在 Xcode 中选择了正确的设备：
- 点击顶部工具栏的设备选择器
- 选择你的 iPhone 16e（真机）
- 不要选择模拟器

## 验证修复

运行以下命令检查架构设置：

```bash
cd ios
xcodebuild -showBuildSettings -project Runner.xcodeproj -target Runner -configuration Debug | grep ARCHS
```

应该看到：
```
ARCHS = arm64
VALID_ARCHS = arm64 arm64e
```

## 常见问题

### Q: 为什么会出现这个问题？
A: 通常是因为项目最初在 Intel Mac 上创建，或者架构设置被错误配置。

### Q: 我的 Mac 是 Apple Silicon，还会有这个问题吗？
A: 可能会，因为这是项目配置问题，不是 Mac 硬件问题。

### Q: 修复后还是不行怎么办？
A: 尝试：
1. 重启 Xcode
2. 断开并重新连接 iPhone
3. 在 iPhone 上信任开发者证书
4. 检查 Xcode 的 Signing & Capabilities 设置

## 已应用的 Podfile 修复

Podfile 已经更新，包含以下修复：

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ARCHS'] = 'arm64'
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "i386"
    end
  end
end
```

重新运行 `pod install` 以应用这些更改。
