# 图片压缩工具

这个文件夹包含了用于压缩 `assets` 文件夹中图片的工具，可以在保证质量的同时显著减小文件体积。

## 🛠️ 工具说明

### 1. Python 版本 (推荐)
- **文件**: `compress_images.py`
- **优点**: 跨平台，易于安装依赖
- **依赖**: Python 3 + Pillow 库

### 2. Shell 版本
- **文件**: `compress_images.sh`
- **优点**: 功能强大，支持更多格式
- **依赖**: ImageMagick

## 📦 安装依赖

### Python 版本依赖
```bash
# 安装 Pillow 库
pip install Pillow
# 或者
pip3 install Pillow
```

### Shell 版本依赖
```bash
# macOS
brew install imagemagick

# Ubuntu/Debian
sudo apt-get install imagemagick

# Windows
# 下载并安装: https://imagemagick.org/script/download.php
```

## 🚀 使用方法

### 使用 Python 版本 (推荐)
```bash
# 在项目根目录执行
python3 scripts/compress_images.py
```

### 使用 Shell 版本
```bash
# 给脚本执行权限
chmod +x scripts/compress_images.sh

# 在项目根目录执行
./scripts/compress_images.sh
```

## ⚙️ 压缩配置

### Python 版本配置
在 `compress_images.py` 中修改 `CONFIG` 字典：

```python
CONFIG = {
    'jpeg_quality': 85,      # JPEG 质量 (1-100，推荐 80-90)
    'png_optimize': True,    # PNG 优化
    'max_width': 1200,       # 最大宽度
    'max_height': 1200,      # 最大高度
    'progressive': True,     # 渐进式 JPEG
    'strip_metadata': True,  # 移除元数据
}
```

### Shell 版本配置
在 `compress_images.sh` 中修改变量：

```bash
QUALITY=85          # JPEG 质量 (1-100)
MAX_WIDTH=1200      # 最大宽度
MAX_HEIGHT=1200     # 最大高度
```

## 📊 压缩效果

### 典型压缩效果
- **JPEG 图片**: 通常可以减少 30-60% 的文件大小
- **PNG 图片**: 通常可以减少 10-30% 的文件大小
- **大尺寸图片**: 调整尺寸后可以显著减小文件大小

### 质量建议
- **质量 90-95**: 几乎无损，文件较大
- **质量 85**: 高质量，推荐设置
- **质量 75-80**: 良好质量，文件较小
- **质量 60-70**: 可接受质量，文件很小

## 🔒 安全特性

### 自动备份
- 脚本会自动创建带时间戳的备份文件夹
- 格式: `assets_backup_YYYYMMDD_HHMMSS`
- 如果压缩效果不满意，可以轻松恢复

### 智能压缩
- 只有在文件变小时才会替换原文件
- 如果压缩后文件更大，会保持原文件不变
- 自动处理不同的图片格式和色彩模式

## 📁 支持的文件夹

脚本会自动处理以下文件夹中的图片：
- `assets/images/` - 主要图片资源
- `assets/natures/` - 自然主题图片
- 以及这些文件夹的所有子文件夹

## 🎯 使用场景

### 开发阶段
- 定期压缩新添加的图片资源
- 保持应用包体积合理

### 发布前
- 最终压缩所有图片资源
- 确保最佳的用户体验

### 持续集成
- 可以集成到 CI/CD 流程中
- 自动化图片优化过程

## 🔧 故障排除

### 常见问题

1. **Python 版本问题**
   ```bash
   # 确认 Python 版本
   python3 --version
   
   # 如果没有 python3，尝试
   python --version
   ```

2. **Pillow 安装问题**
   ```bash
   # 升级 pip
   pip install --upgrade pip
   
   # 重新安装 Pillow
   pip uninstall Pillow
   pip install Pillow
   ```

3. **权限问题**
   ```bash
   # 给脚本执行权限
   chmod +x scripts/compress_images.sh
   ```

4. **ImageMagick 问题**
   ```bash
   # 检查是否安装
   magick --version
   # 或者
   convert --version
   ```

### 恢复备份
如果压缩效果不满意：
```bash
# 删除当前 assets 文件夹
rm -rf assets

# 恢复备份（替换为实际的备份文件夹名）
mv assets_backup_20240122_143000 assets
```

## 📈 性能优化建议

1. **批量处理**: 一次性处理所有图片比逐个处理更高效
2. **合适的质量设置**: 根据图片用途选择合适的质量
3. **尺寸优化**: 根据实际显示需求设置最大尺寸
4. **格式选择**: 照片用 JPEG，图标用 PNG

## 🤝 贡献

如果你有改进建议或发现问题，欢迎：
1. 提交 Issue
2. 发起 Pull Request
3. 分享使用经验