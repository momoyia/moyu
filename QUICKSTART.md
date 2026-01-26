# 陌遇 App - 快速启动指南

## 🚀 快速开始

### 前置要求
- Flutter SDK 3.5.0 或更高版本
- Dart SDK 3.5.0 或更高版本
- iOS 开发需要 Xcode 14+
- Android 开发需要 Android Studio

### 1. 克隆项目
```bash
git clone <repository-url>
cd moyu_app
```

### 2. 安装依赖
```bash
flutter pub get
```

### 3. 运行应用
```bash
# 查看可用设备
flutter devices

# iOS 模拟器
flutter run -d ios

# Android 模拟器/设备
flutter run -d android

# Chrome 浏览器
flutter run -d chrome
```

## 📱 应用功能概览

### 首页 - 探索发现
- 精美的全屏首图
- 搜索功能
- 分类导航（自然、户外、文化、娱乐）
- 探索手记展示
- 出行攻略推荐
- 奇遇指南

### 漫游 - 地点探索
- Tinder风格卡片滑动
- 四个分类切换
- 大图沉浸式展示
- 收藏和分享功能

### AI助手 - 智能规划
- 动态AI球体
- 预设问题快捷入口
- 对话输入框

### 我的 - 个人中心
- 个人信息展示
- 旅行数据统计
- 收藏和行程管理

## 🎨 设计特色

### 主色调
- **品牌粉**: #F9457A
- **柔和粉**: #FF8FAB
- **紫色**: #5D5FEF

### 设计风格
- Glassmorphism（毛玻璃）效果
- 大圆角设计（24px）
- 彩色弥散阴影
- 流畅动画过渡

## 📂 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/                      # 数据模型
│   ├── place.dart              # 地点模型
│   └── story.dart              # 故事模型
├── screens/                     # 页面
│   ├── main_screen.dart        # 主屏幕
│   ├── discovery_screen.dart   # 首页
│   ├── roaming_screen.dart     # 漫游
│   ├── ai_screen.dart          # AI助手
│   ├── profile_screen.dart     # 个人中心
│   └── place_detail_screen.dart # 地点详情
├── services/                    # 服务
│   ├── mock_data_service.dart  # 模拟数据
│   └── storage_service.dart    # 本地存储
├── theme/                       # 主题
│   └── app_theme.dart          # 应用主题
└── widgets/                     # 组件
    └── glass_card.dart         # 毛玻璃卡片
```

## 🔧 开发指南

### 添加新页面
1. 在 `lib/screens/` 创建新的 Dart 文件
2. 继承 `StatelessWidget` 或 `StatefulWidget`
3. 在 `main_screen.dart` 中添加导航

### 修改主题
编辑 `lib/theme/app_theme.dart`:
```dart
static const Color primaryPink = Color(0xFFF9457A);
static const Color secondaryPink = Color(0xFFFF8FAB);
```

### 添加数据
编辑 `lib/services/mock_data_service.dart`:
```dart
static List<Place> getMockPlaces() {
  return [
    Place(
      id: '1',
      name: '新地点',
      // ...
    ),
  ];
}
```

## 🐛 常见问题

### Q: 图片无法加载？
A: 确保设备/模拟器有网络连接，应用使用网络图片。

### Q: 如何修改底部导航？
A: 编辑 `lib/screens/main_screen.dart` 中的 `_navItems` 列表。

### Q: 如何添加新的分类？
A: 在对应页面的 `_categories` 列表中添加新项。

### Q: 数据如何持久化？
A: 使用 `StorageService` 类，基于 `shared_preferences`。

## 📦 构建发布版本

### Android APK
```bash
flutter build apk --release
```
输出: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA
```bash
flutter build ios --release
```
然后在 Xcode 中归档和导出

### Web
```bash
flutter build web --release
```
输出: `build/web/`

## 🧪 测试

### 运行测试
```bash
flutter test
```

### 代码分析
```bash
flutter analyze
```

### 格式化代码
```bash
flutter format lib/
```

## 📚 学习资源

### Flutter 官方文档
- [Flutter 文档](https://flutter.dev/docs)
- [Dart 文档](https://dart.dev/guides)

### 设计参考
- [Material Design 3](https://m3.material.io/)
- [Glassmorphism](https://uxdesign.cc/glassmorphism-in-user-interfaces-1f39bb1308c9)

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 许可证

本项目采用 MIT 许可证

## 📞 联系方式

- 项目主页: [GitHub Repository]
- 问题反馈: [Issues]
- 邮箱: [Email]

---

**祝你使用愉快！** 🎉
