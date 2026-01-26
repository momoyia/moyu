import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final StorageService _storageService = StorageService();
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.story.likes;
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
      setState(() {
        _isLiked = false;
        _likeCount = (_likeCount - 1).clamp(0, 999999);
      });
    } else {
      await _storageService.likeStory(widget.story.id);
      setState(() {
        _isLiked = true;
        _likeCount++;
      });
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.block, color: Colors.red),
                title: Text('拉黑作者'),
                onTap: () async {
                  Navigator.pop(context);
                  await _blockAuthor();
                },
              ),
              ListTile(
                leading: Icon(Icons.visibility_off, color: Colors.orange),
                title: Text('屏蔽此帖'),
                onTap: () async {
                  Navigator.pop(context);
                  await _hideStory();
                },
              ),
              ListTile(
                leading: Icon(Icons.report, color: Colors.grey),
                title: Text('举报'),
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _blockAuthor() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('拉黑作者'),
        content: Text('确定要拉黑 ${widget.story.author} 吗？拉黑后将不再看到该作者的内容。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('拉黑'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      print('=== Blocking Author ===');
      print('Author to block: ${widget.story.author}');
      await _storageService.blockAuthor(widget.story.author);

      // 验证是否保存成功
      final blockedList = await _storageService.getBlockedAuthors();
      print('Blocked authors after save: $blockedList');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已拉黑 ${widget.story.author}')),
        );
        print('Returning true to trigger refresh');
        Navigator.pop(context, true); // 返回并通知刷新
      }
    }
  }

  Future<void> _hideStory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('屏蔽此帖'),
        content: Text('确定要屏蔽这篇帖子吗？屏蔽后将不再看到此内容。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: Text('屏蔽'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      print('=== Hiding Story ===');
      print('Story ID to hide: ${widget.story.id}');
      await _storageService.hideStory(widget.story.id);

      // 验证是否保存成功
      final hiddenList = await _storageService.getHiddenStories();
      print('Hidden stories after save: $hiddenList');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已屏蔽此帖')),
        );
        print('Returning true to trigger refresh');
        Navigator.pop(context, true); // 返回并通知刷新
      }
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('举报'),
        content: Text('感谢您的反馈，我们会尽快处理。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Image with App Bar
          SliverAppBar(
            expandedHeight: 300,
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
            // 首页帖子不显示更多按钮
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    story.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
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
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editor Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 14,
                          color: AppTheme.primaryPink,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '平台小编推荐',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Title
                  Text(
                    story.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 16),

                  // Meta Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: story.avatarUrl != null
                            ? NetworkImage(story.avatarUrl!)
                            : null,
                        backgroundColor: AppTheme.primaryPink.withOpacity(0.2),
                        child: story.avatarUrl == null
                            ? Text(
                                story.author[0],
                                style: TextStyle(
                                  color: AppTheme.primaryPink,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.author,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${story.location ?? "未知地点"} · ${_formatDate(story.createdAt)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked
                                  ? AppTheme.primaryPink
                                  : Colors.grey.shade400,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$_likeCount',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Tags
                  if (story.tags != null && story.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: story.tags!.map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  SizedBox(height: 32),

                  // Introduction Section
                  _SectionTitle(title: '📍 目的地介绍'),
                  SizedBox(height: 12),
                  Text(
                    _getIntroduction(story),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.8,
                    ),
                  ),

                  SizedBox(height: 32),

                  // Best Time Section
                  _SectionTitle(title: '🌤️ 最佳旅行时间'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Color(0xFFFFD54F).withOpacity(0.3)),
                    ),
                    child: Text(
                      _getBestTime(story),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade800,
                        height: 1.6,
                      ),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Must-See Attractions
                  _SectionTitle(title: '✨ 必打卡景点'),
                  SizedBox(height: 16),
                  ..._getAttractions(story).map((attraction) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _AttractionCard(
                        title: attraction['title']!,
                        description: attraction['description']!,
                      ),
                    );
                  }).toList(),

                  SizedBox(height: 24),

                  // Food Recommendations
                  _SectionTitle(title: '🍜 美食推荐'),
                  SizedBox(height: 12),
                  Text(
                    _getFoodRecommendations(story),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.8,
                    ),
                  ),

                  SizedBox(height: 32),

                  // Travel Tips
                  _SectionTitle(title: '💡 旅行小贴士'),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPink.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppTheme.primaryPink.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getTravelTips(story).map((tip) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.primaryPink,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade700,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 32),

                  // Transportation
                  _SectionTitle(title: '🚗 交通指南'),
                  SizedBox(height: 12),
                  Text(
                    _getTransportation(story),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                      height: 1.8,
                    ),
                  ),

                  SizedBox(height: 48),

                  // Bottom CTA
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryPink.withOpacity(0.1),
                          AppTheme.accentPurple.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '准备好开始你的旅程了吗？',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '收藏这篇攻略，随时查看',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return '今天';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${date.month}月${date.day}日';
    }
  }

  String _getIntroduction(Story story) {
    if (story.location?.contains('云南') ?? false) {
      return '云南大理，一个让时光慢下来的地方。这里有苍山洱海的壮美，古城街巷的悠闲，还有白族文化的独特魅力。无论是漫步在古城的青石板路上，还是骑行环洱海，都能感受到这座城市独特的浪漫气息。';
    } else if (story.location?.contains('海南') ?? false) {
      return '海南三亚，中国的热带天堂。碧海蓝天，椰林沙滩，这里是度假的理想之地。温暖的气候、清澈的海水、丰富的海鲜美食，让每一个来到这里的人都能找到属于自己的那份悠闲与惬意。';
    } else if (story.location?.contains('浙江') ?? false) {
      return '江南水乡，诗画浙江。这里有小桥流水人家的古镇风情，有西湖的湖光山色，更有深厚的文化底蕴。漫步在古镇的石板路上，品一杯龙井茶，感受江南独有的温婉与雅致。';
    } else {
      return '这是一个充满魅力的旅行目的地，拥有独特的自然风光和人文景观。无论你是喜欢探险还是享受悠闲，这里都能满足你对旅行的所有期待。让我们一起探索这个美丽的地方吧！';
    }
  }

  String _getBestTime(Story story) {
    if (story.location?.contains('云南') ?? false) {
      return '3-5月和9-11月是大理的最佳旅行时间。春季可以看到漫山遍野的花海，秋季则天高云淡，气候宜人。避开7-8月的雨季和春节黄金周，你会有更好的旅行体验。';
    } else if (story.location?.contains('海南') ?? false) {
      return '11月至次年4月是三亚的最佳旅行季节。此时气候温暖舒适，海水清澈，非常适合下海游泳和水上活动。避开5-10月的台风季节，享受最美的海岛时光。';
    } else {
      return '春秋两季是最佳旅行时间，气候宜人，景色优美。建议避开节假日高峰期，选择工作日出行，可以享受更加舒适的旅行体验。';
    }
  }

  List<Map<String, String>> _getAttractions(Story story) {
    if (story.location?.contains('云南') ?? false) {
      return [
        {
          'title': '大理古城',
          'description': '有着千年历史的古城，保存完好的白族建筑，热闹的人民路，是感受大理文化的最佳去处。',
        },
        {
          'title': '洱海',
          'description': '云南第二大淡水湖，环湖骑行是必体验项目。推荐在海东路看日出，在海西路看日落。',
        },
        {
          'title': '苍山',
          'description': '大理的天然屏障，可以乘坐索道上山，俯瞰洱海全景，感受高山草甸的壮美。',
        },
      ];
    } else if (story.location?.contains('海南') ?? false) {
      return [
        {
          'title': '亚龙湾',
          'description': '被誉为"天下第一湾"，拥有7公里长的银白色海滩，海水清澈见底，是潜水和游泳的绝佳地点。',
        },
        {
          'title': '蜈支洲岛',
          'description': '中国的马尔代夫，水上项目丰富，珊瑚礁保护完好，是潜水爱好者的天堂。',
        },
        {
          'title': '天涯海角',
          'description': '三亚的标志性景点，巨大的石刻"天涯"和"海角"见证了无数浪漫的爱情故事。',
        },
      ];
    } else {
      return [
        {
          'title': '主要景点一',
          'description': '这里有着独特的自然景观和人文历史，是不可错过的打卡地点。',
        },
        {
          'title': '主要景点二',
          'description': '体验当地特色文化，感受不一样的旅行魅力。',
        },
      ];
    }
  }

  String _getFoodRecommendations(Story story) {
    if (story.location?.contains('云南') ?? false) {
      return '大理的美食融合了白族特色和云南风味。必尝的有：乳扇、烤饵块、生皮、酸辣鱼、喜洲粑粑。推荐去人民路和复兴路寻找地道小吃，古城内的小餐馆也有很多惊喜。';
    } else if (story.location?.contains('海南') ?? false) {
      return '三亚的海鲜是必吃美食！推荐第一市场自己买海鲜然后找加工店烹饪。文昌鸡、加积鸭、东山羊、和乐蟹被称为海南四大名菜。还有清补凉、椰子饭等特色小吃不容错过。';
    } else {
      return '当地美食丰富多样，既有传统特色菜肴，也有创新融合料理。建议尝试当地特色小吃，体验最地道的美食文化。';
    }
  }

  List<String> _getTravelTips(Story story) {
    return [
      '提前预订住宿和交通，旺季价格会上涨较多',
      '准备好防晒用品，紫外线较强',
      '尊重当地文化习俗，文明旅游',
      '建议购买旅游保险，保障出行安全',
      '随身携带常用药品，以备不时之需',
    ];
  }

  String _getTransportation(Story story) {
    if (story.location?.contains('云南') ?? false) {
      return '飞机：大理机场有直飞北京、上海、广州等城市的航班。\n火车：大理火车站连接昆明、丽江等地，高铁约2小时到昆明。\n市内交通：古城内步行即可，去洱海可租电动车或自行车，也可以打车。';
    } else if (story.location?.contains('海南') ?? false) {
      return '飞机：三亚凤凰国际机场，国内各大城市均有直飞航班。\n高铁：环岛高铁非常方便，可以轻松到达海南各地。\n市内交通：建议租车自驾或使用打车软件，公交车也很方便。';
    } else {
      return '可通过飞机、高铁、汽车等多种方式到达。市内交通便利，建议根据行程选择合适的交通工具。提前规划路线，可以节省时间和费用。';
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade900,
      ),
    );
  }
}

class _AttractionCard extends StatelessWidget {
  final String title;
  final String description;

  const _AttractionCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPink,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
