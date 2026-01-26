import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/story.dart';
import 'travel_story_detail_screen.dart';
import '../services/storage_service.dart';

class TravelGuideDetailScreen extends StatefulWidget {
  final Map<String, dynamic> guide;

  const TravelGuideDetailScreen({super.key, required this.guide});

  @override
  State<TravelGuideDetailScreen> createState() =>
      _TravelGuideDetailScreenState();
}

class _TravelGuideDetailScreenState extends State<TravelGuideDetailScreen> {
  final StorageService _storage = StorageService();
  List<Story> _filteredStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndFilterStories();
  }

  Future<void> _loadAndFilterStories() async {
    final allStories = _getRelatedStories();
    final blockedAuthors = await _storage.getBlockedAuthors();
    final hiddenStories = await _storage.getHiddenStories();

    setState(() {
      _filteredStories = allStories.where((story) {
        return !blockedAuthors.contains(story.author) &&
            !hiddenStories.contains(story.id);
      }).toList();
      _isLoading = false;
    });
  }

  List<Map<String, String>> _getHighlights() {
    final place = widget.guide['place'] as String;
    final contentType = widget.guide['contentType'] as String? ?? '景点';

    // 好玩指南的地点
    if (place == '西湖') {
      return [
        {'title': '断桥残雪', 'desc': '西湖十景之一'},
        {'title': '雷峰塔', 'desc': '千年古塔'},
        {'title': '苏堤春晓', 'desc': '漫步湖畔'},
        {'title': '三潭印月', 'desc': '湖中仙境'},
      ];
    } else if (place == '大理古城') {
      return [
        {'title': '古城墙', 'desc': '明代建筑'},
        {'title': '洋人街', 'desc': '文艺聚集地'},
        {'title': '五华楼', 'desc': '古城地标'},
        {'title': '人民路', 'desc': '美食街区'},
      ];
    } else if (place == '鼓浪屿') {
      return [
        {'title': '日光岩', 'desc': '岛上最高峰'},
        {'title': '菽庄花园', 'desc': '海上园林'},
        {'title': '钢琴博物馆', 'desc': '音乐之岛'},
        {'title': '万国建筑', 'desc': '建筑博览'},
      ];
    } else if (place == '外滩') {
      return [
        {'title': '万国建筑群', 'desc': '百年历史'},
        {'title': '黄浦江夜景', 'desc': '璀璨夜色'},
        {'title': '南京路', 'desc': '繁华商业街'},
        {'title': '和平饭店', 'desc': '老上海风情'},
      ];
    }

    // 出行攻略的地点
    if (contentType == '景点') {
      if (place.contains('citywalk') || place.contains('上海')) {
        return [
          {'title': '外滩万国建筑', 'desc': '百年历史建筑群'},
          {'title': '南京路步行街', 'desc': '繁华商业中心'},
          {'title': '田子坊', 'desc': '石库门里弄文化'},
          {'title': '新天地', 'desc': '时尚休闲地标'},
        ];
      } else if (place.contains('云南')) {
        return [
          {'title': '大理古城', 'desc': '白族文化古城'},
          {'title': '洱海', 'desc': '高原明珠湖泊'},
          {'title': '丽江古城', 'desc': '纳西族古镇'},
          {'title': '玉龙雪山', 'desc': '雪域冰川奇观'},
        ];
      } else if (place.contains('浙江')) {
        return [
          {'title': '西湖', 'desc': '江南名湖'},
          {'title': '乌镇', 'desc': '千年水乡'},
          {'title': '西塘', 'desc': '烟雨长廊'},
          {'title': '灵隐寺', 'desc': '千年古刹'},
        ];
      }
    } else if (contentType == '美食') {
      if (place.contains('成都')) {
        return [
          {'title': '火锅', 'desc': '麻辣鲜香'},
          {'title': '串串香', 'desc': '街头美味'},
          {'title': '担担面', 'desc': '传统小吃'},
          {'title': '兔头', 'desc': '特色美食'},
        ];
      } else if (place.contains('台北')) {
        return [
          {'title': '夜市小吃', 'desc': '烟火气息'},
          {'title': '珍珠奶茶', 'desc': '台湾特色'},
          {'title': '牛肉面', 'desc': '经典美味'},
          {'title': '卤肉饭', 'desc': '地道风味'},
        ];
      } else if (place.contains('广州')) {
        return [
          {'title': '早茶', 'desc': '一盅两件'},
          {'title': '烧腊', 'desc': '粤式经典'},
          {'title': '肠粉', 'desc': '传统小吃'},
          {'title': '糖水', 'desc': '甜蜜滋味'},
        ];
      }
    } else if (contentType == '住宿') {
      if (place.contains('丽江')) {
        return [
          {'title': '古城客栈', 'desc': '纳西风情'},
          {'title': '精品民宿', 'desc': '设计感十足'},
          {'title': '庭院酒店', 'desc': '静谧舒适'},
          {'title': '特色客栈', 'desc': '文艺氛围'},
        ];
      } else if (place.contains('三亚')) {
        return [
          {'title': '海景酒店', 'desc': '无敌海景'},
          {'title': '度假村', 'desc': '一价全包'},
          {'title': '亲子酒店', 'desc': '家庭首选'},
          {'title': '豪华酒店', 'desc': '奢华体验'},
        ];
      } else if (place.contains('西双版纳')) {
        return [
          {'title': '雨林木屋', 'desc': '自然野趣'},
          {'title': '傣式民宿', 'desc': '民族风情'},
          {'title': '森林酒店', 'desc': '生态环保'},
          {'title': '特色客栈', 'desc': '静谧舒适'},
        ];
      }
    } else if (contentType == '打卡') {
      if (place.contains('北京')) {
        return [
          {'title': '网红书店', 'desc': '文艺打卡'},
          {'title': '艺术展览', 'desc': '潮流前沿'},
          {'title': '创意园区', 'desc': '工业风格'},
          {'title': '咖啡馆', 'desc': '氛围感满分'},
        ];
      } else if (place.contains('上海')) {
        return [
          {'title': '艺术空间', 'desc': '光影交错'},
          {'title': '美术馆', 'desc': '艺术殿堂'},
          {'title': '创意市集', 'desc': '手作文化'},
          {'title': '网红餐厅', 'desc': '颜值在线'},
        ];
      } else if (place.contains('青海')) {
        return [
          {'title': '茶卡盐湖', 'desc': '天空之镜'},
          {'title': '青海湖', 'desc': '高原明珠'},
          {'title': '日出日落', 'desc': '绝美光影'},
          {'title': '星空拍摄', 'desc': '银河璀璨'},
        ];
      }
    }

    // 默认亮点
    return [
      {'title': '主要景点', 'desc': '必游之地'},
      {'title': '特色美食', 'desc': '地道风味'},
      {'title': '文化体验', 'desc': '深度游览'},
      {'title': '休闲娱乐', 'desc': '放松身心'},
    ];
  }

  List<Story> _getRelatedStories() {
    final province = widget.guide['province'] as String;
    final place = widget.guide['place'] as String;
    final contentType = widget.guide['contentType'] as String? ?? '景点';

    // 使用place和province生成唯一的ID前缀
    final idPrefix = '${place.hashCode.abs()}_${contentType.hashCode.abs()}_';
    final hash = place.hashCode.abs() + contentType.hashCode.abs();

    // 扩展的文化图片池
    final imagePool = [
      'assets/images/culture/adam-kool-ndN00KmbJ1c-unsplash.jpg',
      'assets/images/culture/amo-fif-95YGku-EF_g-unsplash.jpg',
      'assets/images/culture/amo-fif-iIqENVbSaOY-unsplash.jpg',
      'assets/images/culture/anna-mircea-vDeO-TlZFOY-unsplash.jpg',
      'assets/images/culture/annie-spratt-upJFoyr7BBA-unsplash.jpg',
      'assets/images/culture/ao-dai-hoi-an-for-rent-and-sale-ao-dai-photography-in-hoi-an-Z0GoJ0eau5M-unsplash.jpg',
      'assets/images/culture/arol-vinolas-OEgC5_q9MaE-unsplash.jpg',
      'assets/images/culture/atlas-green-hRRjixxRgfQ-unsplash.jpg',
      'assets/images/culture/casey-horner-4rDCa5hBlCs-unsplash.jpg',
      'assets/images/culture/christopher-kuzman-2LhCDvS_7xs-unsplash.jpg',
      'assets/images/culture/eagan-hsu-a0AIBFxVrb4-unsplash.jpg',
      'assets/images/culture/edward-he-uKyzXEc2k_s-unsplash.jpg',
      'assets/images/culture/hanny-naibaho-D7InODIWyK4-unsplash.jpg',
      'assets/images/culture/hulki-okan-tabak-I0o6bUkXc70-unsplash.jpg',
      'assets/images/culture/jack-stapleton-q4KWiWgZ41Q-unsplash.jpg',
      'assets/images/culture/jay-6YbqrgDbUlo-unsplash.jpg',
      'assets/images/culture/kin-li-e5IDfDCg-cE-unsplash.jpg',
      'assets/images/culture/lin-qiu-yi-wan-XPCo3LFs05g-unsplash.jpg',
      'assets/images/culture/michael-jiang-7NZZ1uiTyhE-unsplash.jpg',
      'assets/images/culture/neom-AdkJ-LgpTrE-unsplash.jpg',
      'assets/images/culture/neom-fNXY1xjZQYI-unsplash.jpg',
      'assets/images/culture/norah-s-dMRZ73KsV-U-unsplash.jpg',
      'assets/images/culture/sam-balye-Ny7PxBGxASo-unsplash.jpg',
      'assets/images/culture/sebastian-leon-prado-MgODFmLOaEY-unsplash.jpg',
      'assets/images/culture/seongho-jang-yyQXwtNPyQw-unsplash.jpg',
      'assets/images/culture/squids-z-V8cstdh381A-unsplash.jpg',
      'assets/images/culture/tianqii-Weu8bq4RUdc-unsplash.jpg',
      'assets/images/culture/un-liu-NASa4On6Kbo-unsplash.jpg',
      'assets/images/culture/un-liu-tfumKEOidUQ-unsplash.jpg',
      'assets/images/culture/vigor-poodo-Mss2J6dWAIQ-unsplash.jpg',
      'assets/images/culture/willian-justen-de-vasconcellos-QyyEHtVCvEI-unsplash.jpg',
      'assets/images/culture/yanhao-fang-VshdssqqSV0-unsplash.jpg',
    ];

    // 根据内容类型生成不同的游记
    if (contentType == '景点') {
      return [
        Story(
          id: '${idPrefix}1',
          title: '$province必游景点TOP5',
          author: '旅行达人小王',
          imageUrl: imagePool[(hash + 0) % imagePool.length],
          content: '精选$province最值得去的五大景点，不容错过',
          likes: 328,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=user1',
          tags: ['景点', '必游'],
          category: '景点',
        ),
        Story(
          id: '${idPrefix}2',
          title: '${place}深度游攻略',
          author: '深度游专家',
          imageUrl: imagePool[(hash + 1) % imagePool.length],
          content: '带你深入了解$place的历史文化',
          likes: 256,
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=user2',
          tags: ['深度游', '文化'],
          category: '景点',
        ),
        Story(
          id: '${idPrefix}3',
          title: '$province小众景点推荐',
          author: '小众旅行家',
          imageUrl: imagePool[(hash + 2) % imagePool.length],
          content: '避开人潮，发现$province的隐藏美景',
          likes: 189,
          createdAt: DateTime.now().subtract(Duration(days: 7)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=user3',
          tags: ['小众', '景点'],
          category: '景点',
        ),
        Story(
          id: '${idPrefix}4',
          title: '${place}一日游路线',
          author: '一日游规划师',
          imageUrl: imagePool[(hash + 3) % imagePool.length],
          content: '最优一日游路线，玩转$place',
          likes: 412,
          createdAt: DateTime.now().subtract(Duration(days: 10)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=user4',
          tags: ['一日游', '路线'],
          category: '景点',
        ),
        Story(
          id: '${idPrefix}5',
          title: '$province自然风光之旅',
          author: '自然摄影师',
          imageUrl: imagePool[(hash + 4) % imagePool.length],
          content: '探索$province的自然美景',
          likes: 167,
          createdAt: DateTime.now().subtract(Duration(days: 12)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=user5',
          tags: ['自然', '风光'],
          category: '景点',
        ),
        Story(
          id: '${idPrefix}6',
          title: '${place}历史古迹探访',
          author: '历史爱好者',
          imageUrl: imagePool[(hash + 5) % imagePool.length],
          content: '追溯历史，感受$place的文化底蕴',
          likes: 234,
          createdAt: DateTime.now().subtract(Duration(days: 15)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=user6',
          tags: ['历史', '古迹'],
          category: '景点',
        ),
      ];
    } else if (contentType == '美食') {
      return [
        Story(
          id: '${idPrefix}1',
          title: '$province美食地图',
          author: '美食博主小李',
          imageUrl: imagePool[(hash + 6) % imagePool.length],
          content: '吃遍$province，这份美食地图必收藏',
          likes: 445,
          createdAt: DateTime.now().subtract(Duration(days: 3)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=food1',
          tags: ['美食', '地图'],
          category: '美食',
        ),
        Story(
          id: '${idPrefix}2',
          title: '${place}必吃榜单',
          author: '吃货小张',
          imageUrl: imagePool[(hash + 7) % imagePool.length],
          content: '本地人推荐的$place必吃美食',
          likes: 389,
          createdAt: DateTime.now().subtract(Duration(days: 6)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=food2',
          tags: ['必吃', '推荐'],
          category: '美食',
        ),
        Story(
          id: '${idPrefix}3',
          title: '$province街头小吃探店',
          author: '街头美食家',
          imageUrl: imagePool[(hash + 8) % imagePool.length],
          content: '最地道的街头小吃，烟火气十足',
          likes: 312,
          createdAt: DateTime.now().subtract(Duration(days: 8)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=food3',
          tags: ['小吃', '街头'],
          category: '美食',
        ),
        Story(
          id: '${idPrefix}4',
          title: '${place}网红餐厅打卡',
          author: '网红探店',
          imageUrl: imagePool[(hash + 9) % imagePool.length],
          content: '颜值与美味并存的网红餐厅',
          likes: 523,
          createdAt: DateTime.now().subtract(Duration(days: 11)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=food4',
          tags: ['网红', '餐厅'],
          category: '美食',
        ),
        Story(
          id: '${idPrefix}5',
          title: '$province传统美食寻味',
          author: '传统美食守护者',
          imageUrl: imagePool[(hash + 10) % imagePool.length],
          content: '寻找$province的传统味道',
          likes: 267,
          createdAt: DateTime.now().subtract(Duration(days: 13)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=food5',
          tags: ['传统', '美食'],
          category: '美食',
        ),
        Story(
          id: '${idPrefix}6',
          title: '${place}夜市美食攻略',
          author: '夜市达人',
          imageUrl: imagePool[(hash + 11) % imagePool.length],
          content: '夜幕降临，开启$place的夜市之旅',
          likes: 398,
          createdAt: DateTime.now().subtract(Duration(days: 16)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=food6',
          tags: ['夜市', '美食'],
          category: '美食',
        ),
      ];
    } else if (contentType == '住宿') {
      return [
        Story(
          id: '${idPrefix}1',
          title: '$province特色民宿推荐',
          author: '民宿体验师',
          imageUrl: imagePool[(hash + 12) % imagePool.length],
          content: '精选$province最有特色的民宿',
          likes: 356,
          createdAt: DateTime.now().subtract(Duration(days: 4)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=hotel1',
          tags: ['民宿', '特色'],
          category: '住宿',
        ),
        Story(
          id: '${idPrefix}2',
          title: '${place}高性价比酒店',
          author: '住宿指南',
          imageUrl: imagePool[(hash + 13) % imagePool.length],
          content: '不贵但很赞的$place住宿推荐',
          likes: 289,
          createdAt: DateTime.now().subtract(Duration(days: 7)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=hotel2',
          tags: ['酒店', '性价比'],
          category: '住宿',
        ),
        Story(
          id: '${idPrefix}3',
          title: '$province豪华度假酒店',
          author: '度假专家',
          imageUrl: imagePool[(hash + 14) % imagePool.length],
          content: '享受$province的奢华度假体验',
          likes: 478,
          createdAt: DateTime.now().subtract(Duration(days: 9)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=hotel3',
          tags: ['豪华', '度假'],
          category: '住宿',
        ),
        Story(
          id: '${idPrefix}4',
          title: '${place}青年旅舍体验',
          author: '背包客',
          imageUrl: imagePool[(hash + 15) % imagePool.length],
          content: '在$place遇见有趣的灵魂',
          likes: 234,
          createdAt: DateTime.now().subtract(Duration(days: 12)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=hotel4',
          tags: ['青旅', '背包客'],
          category: '住宿',
        ),
        Story(
          id: '${idPrefix}5',
          title: '$province景区内住宿',
          author: '景区住宿达人',
          imageUrl: imagePool[(hash + 16) % imagePool.length],
          content: '住在景区，看最美的日出日落',
          likes: 412,
          createdAt: DateTime.now().subtract(Duration(days: 14)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=hotel5',
          tags: ['景区', '住宿'],
          category: '住宿',
        ),
        Story(
          id: '${idPrefix}6',
          title: '${place}特色客栈推荐',
          author: '客栈老板',
          imageUrl: imagePool[(hash + 17) % imagePool.length],
          content: '$place最有故事的客栈',
          likes: 345,
          createdAt: DateTime.now().subtract(Duration(days: 17)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=hotel6',
          tags: ['客栈', '特色'],
          category: '住宿',
        ),
      ];
    } else if (contentType == '打卡') {
      return [
        Story(
          id: '${idPrefix}1',
          title: '$province网红打卡地',
          author: '打卡达人',
          imageUrl: imagePool[(hash + 18) % imagePool.length],
          content: '$province最火的打卡地点合集',
          likes: 567,
          createdAt: DateTime.now().subtract(Duration(days: 2)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=photo1',
          tags: ['打卡', '网红'],
          category: '打卡',
        ),
        Story(
          id: '${idPrefix}2',
          title: '${place}拍照攻略',
          author: '摄影师阿杰',
          imageUrl: imagePool[(hash + 19) % imagePool.length],
          content: '最佳拍照机位和时间分享',
          likes: 489,
          createdAt: DateTime.now().subtract(Duration(days: 5)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=photo2',
          tags: ['拍照', '攻略'],
          category: '打卡',
        ),
        Story(
          id: '${idPrefix}3',
          title: '$province艺术空间探访',
          author: '艺术青年',
          imageUrl: imagePool[(hash + 20) % imagePool.length],
          content: '小众艺术空间，文艺青年必去',
          likes: 378,
          createdAt: DateTime.now().subtract(Duration(days: 8)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=photo3',
          tags: ['艺术', '文艺'],
          category: '打卡',
        ),
        Story(
          id: '${idPrefix}4',
          title: '${place}日落观赏点',
          author: '日落追逐者',
          imageUrl: imagePool[(hash + 21) % imagePool.length],
          content: '在$place看最美的日落',
          likes: 623,
          createdAt: DateTime.now().subtract(Duration(days: 11)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=photo4',
          tags: ['日落', '观景'],
          category: '打卡',
        ),
        Story(
          id: '${idPrefix}5',
          title: '$province书店咖啡馆',
          author: '文艺小姐姐',
          imageUrl: imagePool[(hash + 22) % imagePool.length],
          content: '最有氛围感的书店和咖啡馆',
          likes: 445,
          createdAt: DateTime.now().subtract(Duration(days: 13)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=photo5',
          tags: ['书店', '咖啡'],
          category: '打卡',
        ),
        Story(
          id: '${idPrefix}6',
          title: '${place}夜景拍摄指南',
          author: '夜景摄影师',
          imageUrl: imagePool[(hash + 23) % imagePool.length],
          content: '捕捉$place最美的夜色',
          likes: 512,
          createdAt: DateTime.now().subtract(Duration(days: 16)),
          location: province,
          avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=photo6',
          tags: ['夜景', '摄影'],
          category: '打卡',
        ),
      ];
    }

    // 默认返回景点类型
    return [];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Center(
            child: CircularProgressIndicator(color: AppTheme.primaryPink)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // Hero Image Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.guide['imageUrl'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey.shade300);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPink,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.guide['province'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.guide['place'] as String,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.guide['description'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Info Cards
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.schedule,
                      label: '时长',
                      value: widget.guide['duration'] as String,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.account_balance_wallet_outlined,
                      label: '预算',
                      value: widget.guide['budget'] as String,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Highlights Section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPink,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '精彩亮点',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _getHighlights().map((highlight) {
                      return Container(
                        width: (MediaQuery.of(context).size.width - 56) / 2,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPink.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.primaryPink.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              highlight['title']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              highlight['desc']!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Related Stories Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPink,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '相关游记',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${_filteredStories.length} 篇',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Waterfall Grid
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _StoryCard(
                    story: _filteredStories[index],
                    onRefresh: _loadAndFilterStories,
                  );
                },
                childCount: _filteredStories.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryPink, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onRefresh;

  const _StoryCard({required this.story, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelStoryDetailScreen(story: story),
          ),
        );

        // 如果返回值为 true，说明需要刷新列表
        if (result == true) {
          onRefresh();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  story.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      child: Icon(Icons.image, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    story.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8,
                        backgroundImage: story.avatarUrl != null
                            ? NetworkImage(story.avatarUrl!)
                            : null,
                        backgroundColor: AppTheme.primaryPink.withOpacity(0.2),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          story.author,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.favorite_border,
                          size: 12, color: Colors.grey.shade400),
                      SizedBox(width: 4),
                      Text(
                        '${story.likes}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
