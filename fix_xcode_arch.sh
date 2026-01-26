#!/bin/bash

echo "🔧 修复 Xcode 架构设置..."

# 使用 xcodeproj 工具修改项目设置
# 如果没有安装，先安装 xcodeproj gem
if ! gem list xcodeproj -i > /dev/null 2>&1; then
    echo "安装 xcodeproj..."
    sudo gem install xcodeproj
fi

# 创建 Ruby 脚本来修改项目
cat > /tmp/fix_arch.rb << 'EOF'
require 'xcodeproj'

project_path = 'ios/Runner.xcodeproj'
project = Xcodeproj::Project.open(project_path)

project.targets.each do |target|
  if target.name == 'Runner'
    target.build_configurations.each do |config|
      # 设置支持的架构
      config.build_settings['ARCHS'] = '$(ARCHS_STANDARD)'
      config.build_settings['VALID_ARCHS'] = 'arm64 arm64e'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      
      puts "Updated #{config.name} configuration"
    end
  end
end

project.save
puts "✅ Project saved successfully!"
EOF

# 运行 Ruby 脚本
ruby /tmp/fix_arch.rb

# 清理
rm /tmp/fix_arch.rb

echo "✅ 架构设置已修复！"
echo "现在请在 Xcode 中："
echo "1. 打开 ios/Runner.xcworkspace"
echo "2. 选择 Runner target"
echo "3. 在 Build Settings 中搜索 'Architectures'"
echo "4. 确认 Architectures 设置为 'Standard Architectures (arm64)'"
echo "5. 清理项目 (Product > Clean Build Folder)"
echo "6. 重新运行"
