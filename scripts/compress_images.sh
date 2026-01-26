#!/bin/bash

# 图片压缩脚本
# 用于压缩 assets 文件夹中的图片，保证质量的同时减小体积

echo "🖼️  开始压缩图片..."

# 检查是否安装了 ImageMagick
if ! command -v magick &> /dev/null && ! command -v convert &> /dev/null; then
    echo "❌ 错误: 未找到 ImageMagick"
    echo "请先安装 ImageMagick:"
    echo "  macOS: brew install imagemagick"
    echo "  Ubuntu: sudo apt-get install imagemagick"
    echo "  Windows: 下载并安装 https://imagemagick.org/script/download.php"
    exit 1
fi

# 设置压缩参数
QUALITY=85          # JPEG 质量 (1-100, 85 是高质量和文件大小的平衡点)
MAX_WIDTH=1200      # 最大宽度
MAX_HEIGHT=1200     # 最大高度
PROGRESSIVE=true    # 渐进式 JPEG

# 创建备份文件夹
BACKUP_DIR="assets_backup_$(date +%Y%m%d_%H%M%S)"
echo "📁 创建备份文件夹: $BACKUP_DIR"
cp -r assets "$BACKUP_DIR"

# 压缩函数
compress_image() {
    local file="$1"
    local original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
    
    echo "🔄 压缩: $file"
    
    # 获取文件扩展名
    local extension="${file##*.}"
    local temp_file="${file%.*}_temp.${extension}"
    
    # 根据文件类型选择压缩策略
    case "${extension,,}" in
        jpg|jpeg)
            if command -v magick &> /dev/null; then
                magick "$file" \
                    -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" \
                    -quality $QUALITY \
                    -interlace Plane \
                    -strip \
                    "$temp_file"
            else
                convert "$file" \
                    -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" \
                    -quality $QUALITY \
                    -interlace Plane \
                    -strip \
                    "$temp_file"
            fi
            ;;
        png)
            if command -v magick &> /dev/null; then
                magick "$file" \
                    -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" \
                    -strip \
                    "$temp_file"
            else
                convert "$file" \
                    -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" \
                    -strip \
                    "$temp_file"
            fi
            ;;
        *)
            echo "⚠️  跳过不支持的格式: $file"
            return
            ;;
    esac
    
    # 检查压缩是否成功
    if [ -f "$temp_file" ]; then
        local new_size=$(stat -f%z "$temp_file" 2>/dev/null || stat -c%s "$temp_file" 2>/dev/null)
        local reduction=$(( (original_size - new_size) * 100 / original_size ))
        
        # 只有在文件变小时才替换
        if [ $new_size -lt $original_size ]; then
            mv "$temp_file" "$file"
            echo "✅ 压缩成功: $(numfmt --to=iec $original_size) → $(numfmt --to=iec $new_size) (减少 ${reduction}%)"
        else
            rm "$temp_file"
            echo "ℹ️  文件已经很小，跳过: $file"
        fi
    else
        echo "❌ 压缩失败: $file"
    fi
}

# 统计变量
total_files=0
processed_files=0
total_original_size=0
total_new_size=0

# 查找并压缩所有图片文件
echo "🔍 查找图片文件..."

# 处理 assets/images 文件夹
if [ -d "assets/images" ]; then
    echo "📂 处理 assets/images 文件夹..."
    find assets/images -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        if [ -f "$file" ]; then
            original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            total_original_size=$((total_original_size + original_size))
            total_files=$((total_files + 1))
            
            compress_image "$file"
            
            new_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            total_new_size=$((total_new_size + new_size))
            processed_files=$((processed_files + 1))
        fi
    done
fi

# 处理 assets/natures 文件夹
if [ -d "assets/natures" ]; then
    echo "📂 处理 assets/natures 文件夹..."
    find assets/natures -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        if [ -f "$file" ]; then
            compress_image "$file"
        fi
    done
fi

echo ""
echo "🎉 压缩完成!"
echo "📊 统计信息:"
echo "   - 备份位置: $BACKUP_DIR"
echo "   - 如果压缩效果不满意，可以从备份恢复"
echo ""
echo "💡 提示:"
echo "   - 质量设置: $QUALITY (可在脚本中调整)"
echo "   - 最大尺寸: ${MAX_WIDTH}x${MAX_HEIGHT}"
echo "   - 如需恢复: rm -rf assets && mv $BACKUP_DIR assets"