#!/usr/bin/env python3
"""
图片压缩脚本
用于压缩 assets 文件夹中的图片，保证质量的同时减小体积
"""

import os
import sys
import shutil
from datetime import datetime
from pathlib import Path

try:
    from PIL import Image, ImageOps
    print("✅ PIL 库已安装")
except ImportError:
    print("❌ 错误: 未找到 PIL 库")
    print("请先安装 Pillow:")
    print("  pip install Pillow")
    print("  或者: pip3 install Pillow")
    sys.exit(1)

# 压缩配置
CONFIG = {
    'jpeg_quality': 85,      # JPEG 质量 (1-100)
    'png_optimize': True,    # PNG 优化
    'max_width': 1200,       # 最大宽度
    'max_height': 1200,      # 最大高度
    'progressive': True,     # 渐进式 JPEG
    'strip_metadata': True,  # 移除元数据
}

def format_size(size_bytes):
    """格式化文件大小"""
    if size_bytes == 0:
        return "0B"
    size_names = ["B", "KB", "MB", "GB"]
    i = 0
    while size_bytes >= 1024 and i < len(size_names) - 1:
        size_bytes /= 1024.0
        i += 1
    return f"{size_bytes:.1f}{size_names[i]}"

def get_file_size(file_path):
    """获取文件大小"""
    return os.path.getsize(file_path)

def compress_image(input_path, output_path=None):
    """
    压缩单个图片文件
    
    Args:
        input_path: 输入文件路径
        output_path: 输出文件路径，如果为None则覆盖原文件
    
    Returns:
        tuple: (原始大小, 压缩后大小, 是否成功)
    """
    if output_path is None:
        output_path = input_path
    
    try:
        original_size = get_file_size(input_path)
        
        # 打开图片
        with Image.open(input_path) as img:
            # 转换为RGB模式（如果需要）
            if img.mode in ('RGBA', 'LA', 'P'):
                # 对于透明图片，保持PNG格式
                if input_path.lower().endswith('.png'):
                    pass  # 保持原格式
                else:
                    # 转换为RGB
                    background = Image.new('RGB', img.size, (255, 255, 255))
                    if img.mode == 'P':
                        img = img.convert('RGBA')
                    background.paste(img, mask=img.split()[-1] if img.mode == 'RGBA' else None)
                    img = background
            
            # 调整图片尺寸
            if img.width > CONFIG['max_width'] or img.height > CONFIG['max_height']:
                img.thumbnail((CONFIG['max_width'], CONFIG['max_height']), Image.Resampling.LANCZOS)
            
            # 移除EXIF数据
            if CONFIG['strip_metadata']:
                img = ImageOps.exif_transpose(img)
            
            # 保存压缩后的图片
            save_kwargs = {}
            
            if input_path.lower().endswith(('.jpg', '.jpeg')):
                save_kwargs.update({
                    'format': 'JPEG',
                    'quality': CONFIG['jpeg_quality'],
                    'progressive': CONFIG['progressive'],
                    'optimize': True
                })
            elif input_path.lower().endswith('.png'):
                save_kwargs.update({
                    'format': 'PNG',
                    'optimize': CONFIG['png_optimize']
                })
            
            # 如果是覆盖原文件，先保存到临时文件
            if output_path == input_path:
                temp_path = input_path + '.tmp'
                img.save(temp_path, **save_kwargs)
                
                # 检查压缩效果
                new_size = get_file_size(temp_path)
                if new_size < original_size:
                    # 压缩有效，替换原文件
                    shutil.move(temp_path, output_path)
                else:
                    # 压缩无效，删除临时文件
                    os.remove(temp_path)
                    new_size = original_size
            else:
                img.save(output_path, **save_kwargs)
                new_size = get_file_size(output_path)
        
        return original_size, new_size, True
        
    except Exception as e:
        print(f"❌ 压缩失败 {input_path}: {str(e)}")
        return 0, 0, False

def create_backup():
    """创建备份文件夹"""
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_dir = f"assets_backup_{timestamp}"
    
    if os.path.exists("assets"):
        print(f"📁 创建备份文件夹: {backup_dir}")
        shutil.copytree("assets", backup_dir)
        return backup_dir
    return None

def find_images(directory):
    """查找指定目录下的所有图片文件"""
    image_extensions = {'.jpg', '.jpeg', '.png', '.JPG', '.JPEG', '.PNG'}
    image_files = []
    
    for root, dirs, files in os.walk(directory):
        for file in files:
            if Path(file).suffix in image_extensions:
                image_files.append(os.path.join(root, file))
    
    return image_files

def main():
    """主函数"""
    print("🖼️  开始压缩图片...")
    print(f"📋 压缩配置:")
    print(f"   - JPEG 质量: {CONFIG['jpeg_quality']}")
    print(f"   - 最大尺寸: {CONFIG['max_width']}x{CONFIG['max_height']}")
    print(f"   - PNG 优化: {CONFIG['png_optimize']}")
    print(f"   - 渐进式 JPEG: {CONFIG['progressive']}")
    print()
    
    # 检查 assets 文件夹是否存在
    if not os.path.exists("assets"):
        print("❌ 错误: 未找到 assets 文件夹")
        return
    
    # 创建备份
    backup_dir = create_backup()
    
    # 统计变量
    total_original_size = 0
    total_new_size = 0
    processed_count = 0
    success_count = 0
    
    # 查找所有图片文件
    print("🔍 查找图片文件...")
    image_files = find_images("assets")
    
    if not image_files:
        print("ℹ️  未找到图片文件")
        return
    
    print(f"📊 找到 {len(image_files)} 个图片文件")
    print()
    
    # 压缩每个图片文件
    for image_file in image_files:
        print(f"🔄 压缩: {image_file}")
        
        original_size, new_size, success = compress_image(image_file)
        processed_count += 1
        
        if success:
            success_count += 1
            total_original_size += original_size
            total_new_size += new_size
            
            if new_size < original_size:
                reduction = ((original_size - new_size) / original_size) * 100
                print(f"✅ 压缩成功: {format_size(original_size)} → {format_size(new_size)} (减少 {reduction:.1f}%)")
            else:
                print(f"ℹ️  文件已经很小，跳过压缩")
        
        print()
    
    # 显示统计信息
    print("🎉 压缩完成!")
    print("📊 统计信息:")
    print(f"   - 处理文件: {processed_count}")
    print(f"   - 成功压缩: {success_count}")
    
    if total_original_size > 0:
        total_reduction = ((total_original_size - total_new_size) / total_original_size) * 100
        print(f"   - 原始总大小: {format_size(total_original_size)}")
        print(f"   - 压缩后总大小: {format_size(total_new_size)}")
        print(f"   - 总体减少: {format_size(total_original_size - total_new_size)} ({total_reduction:.1f}%)")
    
    if backup_dir:
        print(f"   - 备份位置: {backup_dir}")
        print("   - 如果压缩效果不满意，可以从备份恢复")
    
    print()
    print("💡 提示:")
    print("   - 可以调整脚本中的 CONFIG 参数来改变压缩设置")
    if backup_dir:
        print(f"   - 如需恢复: rm -rf assets && mv {backup_dir} assets")

if __name__ == "__main__":
    main()