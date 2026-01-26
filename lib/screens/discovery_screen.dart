import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';
import '../services/storage_service.dart';
import '../models/story.dart';
import 'story_detail_screen.dart';
import 'featured_stories_screen.dart';
import 'travel_guide_detail_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final StorageService _storageService = StorageService();
  String _nickname = '漫游雨林的树懒';
  int _selectedCategoryId = 1;
  late List<Story> _allStories;
  late List<Story> _filteredStories;

  final List<Map<String, dynamic>> _categories = [
    {
      'id': 1,
      'name': '自然',
      'icon': Icons.terrain,
      'color': 0xFF10B981,
      'bgImage': 'assets/images/1.jpg',
      'title': '探索自然的奥秘'
    },
    {
      'id': 2,
      'name': '户外',
      'icon': Icons.hiking,
      'color': 0xFFF97316,
      'bgImage': 'assets/images/2.jpg',
      'title': '开启户外冒险之旅'
    },
    {
      'id': 3,
      'name': '文化',
      'icon': Icons.account_balance,
      'color': 0xFF8B5CF6,
      'bgImage': 'assets/images/3.jpg',
      'title': '感受文化的魅力'
    },
    {
      'id': 4,
      'name': '娱乐',
      'icon': Icons.music_note,
      'color': 0xFF3B82F6,
      'bgImage': 'assets/images/4.jpg',
      'title': '享受娱乐的时光'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _allStories = MockDataService.getMockStories();
    _filterStories();
  }

  Future<void> _loadNickname() async {
    final nickname = await _storageService.getNickname();
    setState(() {
      _nickname = nickname;
    });
  }

  Future<void> _filterStories() async {
    final selectedCategory =
        _categories.firstWhere((cat) => cat['id'] == _selectedCategoryId);
    final categoryName = selectedCategory['name'] as String;

    // 获取被拉黑的用户和被屏蔽的内容
    final blockedUsers = await _storageService.getBlockedAuthors();
    final hiddenContent = await _storageService.getHiddenStories();

    print('=== Discovery Filter Debug ===');
    print('Category: $categoryName');
    print('Blocked users: $blockedUsers');
    print('Hidden content: $hiddenContent');
    print('Total stories before filter: ${_allStories.length}');

    setState(() {
      _filteredStories = _allStories
          .where((story) => story.discoveryCategory == categoryName)
          .where((story) => !blockedUsers.contains(story.author)) // 过滤被拉黑的用户
          .where((story) => !hiddenContent.contains(story.id)) // 过滤被屏蔽的内容
          .toList();

      print('Filtered stories count: ${_filteredStories.length}');
      print(
          'Filtered story authors: ${_filteredStories.map((s) => s.author).toList()}');
    });
  }

  Map<String, dynamic> get _currentCategory {
    return _categories.firstWhere((cat) => cat['id'] == _selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    // 文化图片列表
    final cultureImages = [
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

    // 根据名称获取文化图片
    String getCultureImage(String name) {
      final hash = name.hashCode.abs();
      final index = hash % cultureImages.length;
      return cultureImages[index];
    }

    final travelGuides = [
      {
        'place': '周末citywalk',
        'province': '上海',
        'imageUrl': getCultureImage('周末citywalk'),
      },
      {
        'place': '说走就走',
        'province': '云南',
        'imageUrl': getCultureImage('说走就走'),
      },
      {
        'place': '治愈系小城',
        'province': '浙江',
        'imageUrl': getCultureImage('治愈系小城'),
      },
    ];

    final funGuides = [
      {
        'place': '西湖',
        'province': '浙江',
        'imageUrl': getCultureImage('西湖'),
      },
      {
        'place': '大理古城',
        'province': '云南',
        'imageUrl': getCultureImage('大理古城'),
      },
      {
        'place': '鼓浪屿',
        'province': '福建',
        'imageUrl': getCultureImage('鼓浪屿'),
      },
      {
        'place': '外滩',
        'province': '上海',
        'imageUrl': getCultureImage('外滩'),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Section with Categories
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 33 / 30,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        _currentCategory['bgImage'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade300,
                            child:
                                Icon(Icons.image, size: 50, color: Colors.grey),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.3),
                              Colors.transparent,
                              AppTheme.primaryPink.withOpacity(0.4),
                            ],
                            stops: [0.0, 0.3, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: 60,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, $_nickname',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _currentCategory['title'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Categories on image
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 24,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _categories.map((cat) {
                            final isSelected = _selectedCategoryId == cat['id'];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryId = cat['id'];
                                  _filterStories();
                                });
                              },
                              child: Container(
                                width: 70,
                                padding: EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      cat['icon'],
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.white,
                                      size: 24,
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      cat['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Section: 精选
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: _SectionHeader(
                title: '精选',
                showMore: true,
                onMoreTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeaturedStoriesScreen(
                        stories: _filteredStories,
                        categoryName: _currentCategory['name'] as String,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 300,
                child: Row(
                  children: [
                    if (_filteredStories.isNotEmpty)
                      Expanded(
                        child: _StoryCard(
                          story: _filteredStories[0],
                          onRefresh: _filterStories,
                        ),
                      ),
                    if (_filteredStories.length > 1) ...[
                      SizedBox(width: 12),
                      Expanded(
                        child: _StoryCard(
                          story: _filteredStories[1],
                          onRefresh: _filterStories,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Section: 出行攻略
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: _SectionHeader(title: '出行攻略'),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(24, 0, 24, 24),
              height: 240,
              child: travelGuides.length >= 3
                  ? Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _GuideCard(guide: travelGuides[0]),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: _GuideCard(guide: travelGuides[1]),
                              ),
                              SizedBox(height: 12),
                              Expanded(
                                child: _GuideCard(guide: travelGuides[2]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        '暂无内容',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    ),
            ),
          ),

          // Section: 好玩指南
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: _SectionHeader(title: '好玩指南'),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 24),
                scrollDirection: Axis.horizontal,
                itemCount: (funGuides.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final firstIndex = index * 2;
                  final secondIndex = firstIndex + 1;
                  final hasSecond = secondIndex < funGuides.length;

                  return Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    margin: EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Expanded(
                          child: _GuideCard(guide: funGuides[firstIndex]),
                        ),
                        if (hasSecond) ...[
                          SizedBox(height: 12),
                          Expanded(
                            child: _GuideCard(guide: funGuides[secondIndex]),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool showMore;
  final VoidCallback? onMoreTap;

  const _SectionHeader({
    required this.title,
    this.showMore = false,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        if (showMore)
          GestureDetector(
            onTap: onMoreTap,
            child: Row(
              children: [
                Text(
                  '查看更多',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _StoryCard extends StatefulWidget {
  final Story story;
  final VoidCallback? onRefresh;

  const _StoryCard({
    required this.story,
    this.onRefresh,
  });

  @override
  State<_StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<_StoryCard> {
  final StorageService _storageService = StorageService();
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();
  }

  Future<void> _loadLikeStatus() async {
    final liked = await _storageService.isStoryLiked(widget.story.id);
    if (mounted) {
      setState(() {
        _isLiked = liked;
      });
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiked) {
      await _storageService.unlikeStory(widget.story.id);
    } else {
      await _storageService.likeStory(widget.story.id);
    }
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print('=== Story Card Tapped ===');
        print('Story: ${widget.story.title}');
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(story: widget.story),
          ),
        );
        print('Returned from detail screen with result: $result');
        // 如果返回true（表示有拉黑或屏蔽操作），刷新列表
        if (result == true && widget.onRefresh != null) {
          print('Calling onRefresh callback');
          widget.onRefresh!();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with 30:32 aspect ratio
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 30 / 32,
                  child: widget.story.imageUrl.startsWith('http')
                      ? Image.network(
                          widget.story.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image,
                                  color: Colors.grey, size: 40),
                            );
                          },
                        )
                      : Image.asset(
                          widget.story.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image,
                                  color: Colors.grey, size: 40),
                            );
                          },
                        ),
                ),
              ),
              // Like button overlay
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _toggleLike,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: _isLiked
                          ? AppTheme.primaryPink
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Title
          Text(
            widget.story.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),

          // Tags
          if (widget.story.tags != null && widget.story.tags!.isNotEmpty) ...[
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: widget.story.tags!.take(2).map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),
          ],

          // Location and Rating
          Row(
            children: [
              Icon(Icons.location_on, size: 13, color: Colors.grey.shade400),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.story.location ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.star, size: 13, color: Color(0xFFFFA500)),
              SizedBox(width: 2),
              Text(
                '4.${(widget.story.likes % 10)}/5',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final Map<String, dynamic> guide;

  const _GuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final place = guide['place'] as String;

        // 为不同的地点设置参数
        Map<String, dynamic> fullGuide;

        if (place == '周末citywalk' || place == '说走就走' || place == '治愈系小城') {
          // 出行攻略的地点
          fullGuide = {
            ...guide,
            'duration': place == '周末citywalk'
                ? '2天1夜'
                : place == '说走就走'
                    ? '5天4夜'
                    : place == '治愈系小城'
                        ? '3天2夜'
                        : '4天3夜',
            'budget': place == '周末citywalk'
                ? '¥800-1500'
                : place == '说走就走'
                    ? '¥2500-4000'
                    : place == '治愈系小城'
                        ? '¥1200-2000'
                        : '¥1800-3000',
            'tags': place == '周末citywalk'
                ? ['城市漫步', '美食', '文艺']
                : place == '说走就走'
                    ? ['自然风光', '古镇', '民族文化']
                    : place == '治愈系小城'
                        ? ['古镇', '慢生活', '江南']
                        : ['海岛', '古建筑', '美食'],
            'description': place == '周末citywalk'
                ? '漫步魔都街头，感受都市的烟火气息'
                : place == '说走就走'
                    ? '彩云之南，诗和远方的完美结合'
                    : place == '治愈系小城'
                        ? '江南水乡，慢生活的最佳选择'
                        : '闽南风情，海岛与古厝的浪漫',
          };
        } else {
          // 好玩指南的地点
          fullGuide = {
            ...guide,
            'duration': place == '西湖'
                ? '1天'
                : place == '大理古城'
                    ? '2天1夜'
                    : place == '鼓浪屿'
                        ? '1天'
                        : place == '外滩'
                            ? '半天'
                            : '1天',
            'budget': place == '西湖'
                ? '¥200-500'
                : place == '大理古城'
                    ? '¥800-1500'
                    : place == '鼓浪屿'
                        ? '¥300-800'
                        : place == '外滩'
                            ? '¥500-1000'
                            : '¥500-1000',
            'tags': place == '西湖'
                ? ['湖泊', '文化', '休闲']
                : place == '大理古城'
                    ? ['古城', '白族', '文化']
                    : place == '鼓浪屿'
                        ? ['海岛', '建筑', '文艺']
                        : place == '外滩'
                            ? ['建筑', '夜景', '都市']
                            : ['景点', '旅游'],
            'description': place == '西湖'
                ? '江南名湖，四季皆美'
                : place == '大理古城'
                    ? '白族文化，风花雪月'
                    : place == '鼓浪屿'
                        ? '海上花园，万国建筑'
                        : place == '外滩'
                            ? '百年外滩，万国建筑博览'
                            : '探索美好风景',
          };
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelGuideDetailScreen(guide: fullGuide),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              (guide['imageUrl'] as String).startsWith('http')
                  ? Image.network(
                      guide['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child:
                              Icon(Icons.image, size: 40, color: Colors.grey),
                        );
                      },
                    )
                  : Image.asset(
                      guide['imageUrl'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child:
                              Icon(Icons.image, size: 40, color: Colors.grey),
                        );
                      },
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guide['place'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.white.withOpacity(0.9),
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          guide['province'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
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
      ),
    );
  }
}
