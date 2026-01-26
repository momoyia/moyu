# 陌遇 App - 文件清单

## 📁 项目文件结构

### 根目录文件
```
moyu_app/
├── README.md                    # 项目介绍和设计规范
├── QUICKSTART.md               # 快速启动指南
├── PROJECT_SUMMARY.md          # 项目总结
├── FEATURES.md                 # 功能特性详解
├── FILES_LIST.md               # 文件清单（本文件）
├── 开发完成说明.md              # 开发完成说明
├── 更新说明.md                  # 更新日志
├── pubspec.yaml                # Flutter项目配置
├── analysis_options.yaml       # 代码分析配置
├── index.html                  # 原型图参考
└── .gitignore                  # Git忽略配置
```

---

## 📱 应用源代码 (lib/)

### 主入口
```
lib/
└── main.dart                   # 应用入口文件
    ├── MoyuApp                 # 应用根组件
    └── main()                  # 主函数
```

### 数据模型 (models/)
```
lib/models/
├── place.dart                  # 地点数据模型
│   ├── Place类                 # 地点实体
│   ├── fromJson()             # JSON反序列化
│   └── toJson()               # JSON序列化
│
└── story.dart                  # 故事数据模型
    ├── Story类                 # 故事实体
    ├── fromJson()             # JSON反序列化
    └── toJson()               # JSON序列化
```

### 页面组件 (screens/)
```
lib/screens/
├── main_screen.dart            # 主屏幕（底部导航）
│   ├── MainScreen             # 主屏幕组件
│   ├── _MainScreenState       # 状态管理
│   └── 底部导航栏实现
│
├── discovery_screen.dart       # 首页（探索发现）
│   ├── DiscoveryScreen        # 首页组件
│   ├── _DiscoveryScreenState  # 状态管理
│   ├── _SectionHeader         # 章节标题组件
│   └── _StoryCard             # 故事卡片组件
│
├── roaming_screen.dart         # 漫游页面
│   ├── RoamingScreen          # 漫游组件
│   ├── _RoamingScreenState    # 状态管理
│   ├── _PlaceCard             # 地点卡片组件
│   └── _ActionButton          # 操作按钮组件
│
├── ai_screen.dart              # AI助手页面
│   ├── AIScreen               # AI组件
│   ├── _AIScreenState         # 状态管理
│   └── AI球体动画实现
│
├── profile_screen.dart         # 个人中心页面
│   ├── ProfileScreen          # 个人中心组件
│   ├── _StatCard              # 统计卡片组件
│   └── _MenuItem              # 菜单项组件
│
└── place_detail_screen.dart    # 地点详情页面
    ├── PlaceDetailScreen      # 详情页组件
    └── 详情展示实现
```

### 服务层 (services/)
```
lib/services/
├── mock_data_service.dart      # 模拟数据服务
│   ├── getMockPlaces()        # 获取地点数据
│   ├── getMockStories()       # 获取故事数据
│   └── getAIQuestions()       # 获取AI问题
│
└── storage_service.dart        # 本地存储服务
    ├── getFavorites()         # 获取收藏
    ├── saveFavorites()        # 保存收藏
    ├── addFavorite()          # 添加收藏
    ├── removeFavorite()       # 删除收藏
    ├── isFavorite()           # 检查收藏
    ├── getVisitedPlaces()     # 获取访问历史
    └── addVisitedPlace()      # 添加访问历史
```

### 主题样式 (theme/)
```
lib/theme/
└── app_theme.dart              # 应用主题配置
    ├── AppTheme类             # 主题类
    ├── 颜色定义               # 品牌色彩
    ├── lightTheme             # 浅色主题
    ├── cardShadow             # 卡片阴影
    └── backgroundGradient     # 背景渐变
```

### UI组件 (widgets/)
```
lib/widgets/
└── glass_card.dart             # 毛玻璃卡片组件
    ├── GlassCard类            # 卡片组件
    └── 毛玻璃效果实现
```

---

## 🎨 资源文件

### Web资源 (web/)
```
web/
├── favicon.png                 # 网站图标
├── index.html                  # Web入口
├── manifest.json               # Web应用清单
└── icons/                      # 应用图标
    ├── Icon-192.png
    ├── Icon-512.png
    ├── Icon-maskable-192.png
    └── Icon-maskable-512.png
```

---

## 📱 平台配置

### Android配置
```
android/
├── app/
│   ├── build.gradle.kts        # 构建配置
│   └── src/
│       ├── main/
│       │   ├── AndroidManifest.xml
│       │   ├── kotlin/         # Kotlin代码
│       │   └── res/            # 资源文件
│       ├── debug/
│       └── profile/
├── build.gradle.kts            # 项目构建配置
├── gradle.properties           # Gradle属性
└── settings.gradle.kts         # Gradle设置
```

### iOS配置
```
ios/
├── Runner/
│   ├── AppDelegate.swift       # 应用委托
│   ├── Info.plist             # 应用信息
│   ├── Assets.xcassets/       # 资源目录
│   └── Base.lproj/            # 本地化资源
├── Runner.xcodeproj/          # Xcode项目
├── Runner.xcworkspace/        # Xcode工作空间
└── Podfile                    # CocoaPods配置
```

### macOS配置
```
macos/
├── Runner/
│   ├── AppDelegate.swift
│   ├── Info.plist
│   ├── Assets.xcassets/
│   └── Configs/
├── Runner.xcodeproj/
└── Runner.xcworkspace/
```

### Linux配置
```
linux/
├── flutter/
│   ├── CMakeLists.txt
│   └── generated_plugin_registrant.cc
└── runner/
    ├── main.cc
    └── my_application.cc
```

### Windows配置
```
windows/
├── flutter/
│   ├── CMakeLists.txt
│   └── generated_plugin_registrant.cc
└── runner/
    ├── main.cpp
    └── flutter_window.cpp
```

---

## 🧪 测试文件

### 单元测试
```
test/
└── widget_test.dart            # Widget测试
```

---

## 🔧 配置文件

### Flutter配置
```
pubspec.yaml                    # 项目依赖配置
├── name: moyu_app
├── version: 1.0.0+1
├── dependencies:
│   ├── flutter
│   ├── cupertino_icons: ^1.0.8
│   ├── shared_preferences: ^2.2.2
│   └── http: ^1.2.0
└── dev_dependencies:
    ├── flutter_test
    └── flutter_lints: ^5.0.0
```

### 代码分析
```
analysis_options.yaml           # 代码分析规则
├── include: package:flutter_lints/flutter.yaml
└── linter rules
```

### Git配置
```
.gitignore                      # Git忽略文件
├── Dart/Flutter忽略
├── Android忽略
├── iOS忽略
└── IDE忽略
```

---

## 📊 文件统计

### 代码文件统计
```
Dart源文件:        13个
├── 页面文件:      6个
├── 模型文件:      2个
├── 服务文件:      2个
├── 主题文件:      1个
├── 组件文件:      1个
└── 入口文件:      1个

总代码行数:        ~2500行
平均文件大小:      ~190行
```

### 文档文件统计
```
Markdown文档:      7个
├── README.md
├── QUICKSTART.md
├── PROJECT_SUMMARY.md
├── FEATURES.md
├── FILES_LIST.md
├── 开发完成说明.md
└── 更新说明.md

总文档行数:        ~2000行
```

### 配置文件统计
```
配置文件:          5个
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
├── .metadata
└── index.html (原型图)
```

---

## 📦 依赖包

### 生产依赖
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8      # iOS风格图标
  shared_preferences: ^2.2.2   # 本地存储
  http: ^1.2.0                 # HTTP请求
```

### 开发依赖
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0        # 代码检查
```

---

## 🗂️ 文件用途说明

### 核心文件
| 文件 | 用途 | 重要性 |
|------|------|--------|
| main.dart | 应用入口 | ⭐⭐⭐⭐⭐ |
| main_screen.dart | 主屏幕 | ⭐⭐⭐⭐⭐ |
| app_theme.dart | 主题配置 | ⭐⭐⭐⭐ |
| pubspec.yaml | 项目配置 | ⭐⭐⭐⭐⭐ |

### 页面文件
| 文件 | 用途 | 重要性 |
|------|------|--------|
| discovery_screen.dart | 首页 | ⭐⭐⭐⭐⭐ |
| roaming_screen.dart | 漫游 | ⭐⭐⭐⭐⭐ |
| ai_screen.dart | AI助手 | ⭐⭐⭐⭐⭐ |
| profile_screen.dart | 个人中心 | ⭐⭐⭐⭐⭐ |
| place_detail_screen.dart | 地点详情 | ⭐⭐⭐⭐ |

### 数据文件
| 文件 | 用途 | 重要性 |
|------|------|--------|
| place.dart | 地点模型 | ⭐⭐⭐⭐ |
| story.dart | 故事模型 | ⭐⭐⭐⭐ |
| mock_data_service.dart | 模拟数据 | ⭐⭐⭐⭐ |
| storage_service.dart | 本地存储 | ⭐⭐⭐⭐ |

### 组件文件
| 文件 | 用途 | 重要性 |
|------|------|--------|
| glass_card.dart | 毛玻璃卡片 | ⭐⭐⭐ |

### 文档文件
| 文件 | 用途 | 重要性 |
|------|------|--------|
| README.md | 项目介绍 | ⭐⭐⭐⭐⭐ |
| QUICKSTART.md | 快速启动 | ⭐⭐⭐⭐ |
| PROJECT_SUMMARY.md | 项目总结 | ⭐⭐⭐⭐ |
| FEATURES.md | 功能详解 | ⭐⭐⭐ |
| FILES_LIST.md | 文件清单 | ⭐⭐⭐ |
| 开发完成说明.md | 完成说明 | ⭐⭐⭐⭐ |
| 更新说明.md | 更新日志 | ⭐⭐⭐ |

---

## 🔍 文件查找指南

### 需要修改UI？
→ 查看 `lib/screens/` 目录下的对应页面文件

### 需要修改主题？
→ 编辑 `lib/theme/app_theme.dart`

### 需要修改数据？
→ 编辑 `lib/services/mock_data_service.dart`

### 需要添加新页面？
→ 在 `lib/screens/` 创建新文件，并在 `main_screen.dart` 添加导航

### 需要添加新组件？
→ 在 `lib/widgets/` 创建新文件

### 需要修改依赖？
→ 编辑 `pubspec.yaml`

### 需要查看文档？
→ 查看根目录的 `.md` 文件

---

## 📝 文件命名规范

### Dart文件
- 使用小写字母和下划线
- 例如: `main_screen.dart`, `mock_data_service.dart`

### 类名
- 使用大驼峰命名
- 例如: `MainScreen`, `MockDataService`

### 私有类
- 使用下划线前缀
- 例如: `_MainScreenState`, `_StoryCard`

### 文档文件
- 使用大写字母和下划线
- 例如: `README.md`, `QUICKSTART.md`

---

**文件总数**: 100+ 个文件  
**核心代码文件**: 13 个  
**文档文件**: 7 个  
**配置文件**: 5 个  
**平台文件**: 70+ 个
