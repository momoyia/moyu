#!/bin/bash

# 快速图片压缩脚本
# 在项目根目录直接运行此脚本

echo "🖼️  陌遇应用 - 图片压缩工具"
echo "================================"

# 检查是否有 Python 和 Pillow
if command -v python3 &> /dev/null; then
    if python3 -c "import PIL" &> /dev/null; then
        echo "✅ 使用 Python 版本进行压缩..."
        python3 scripts/compress_images.py
        exit 0
    fi
fi

# 检查是否有 ImageMagick
if command -v magick &> /dev/null || command -v convert &> /dev/null; then
    echo "✅ 使用 ImageMagick 版本进行压缩..."
    ./scripts/compress_images.sh
    exit 0
fi

# 如果都没有，提供安装指导
echo "❌ 未找到压缩工具"
echo ""
echo "请选择一种方式安装依赖："
echo ""
echo "方式1: Python + Pillow (推荐)"
echo "  pip3 install Pillow"
echo "  然后运行: python3 scripts/compress_images.py"
echo ""
echo "方式2: ImageMagick"
echo "  macOS: brew install imagemagick"
echo "  Ubuntu: sudo apt-get install imagemagick"
echo "  然后运行: ./scripts/compress_images.sh"
echo ""
echo "详细说明请查看: scripts/README.md"