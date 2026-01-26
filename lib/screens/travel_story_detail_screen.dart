import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class TravelStoryDetailScreen extends StatefulWidget {
  final Story story;

  const TravelStoryDetailScreen({super.key, required this.story});

  @override
  State<TravelStoryDetailScreen> createState() =>
      _TravelStoryDetailScreenState();
}

class _TravelStoryDetailScreenState extends State<TravelStoryDetailScreen> {
  final StorageService _storageService = StorageService();
  bool _isLiked = false;
  bool _isBookmarked = false;
  bool _isFollowing = false;
  int _likeCount = 0;
  late int _commentCount;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.story.likes;
    // 根据story id生成不同的评论数量
    _commentCount = _getCommentCountForStory();
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

  int _getCommentCountForStory() {
    // 根据story id的hashCode生成不同的评论数
    final hash = widget.story.id.hashCode.abs();
    return 15 + (hash % 50); // 15-64之间的评论数
  }

  // 根据story ID和索引生成不同的图片
  String _getImageForItinerary(int index, String category) {
    final hash = widget.story.id.hashCode.abs();
    final imageVariant = (hash + index) % 18; // 18种不同的图片

    // 使用实际存在的本地图片
    final imagePool = [
      'assets/images/nature/damiano-baschiera-d4feocYfzAM-unsplash.jpg',
      'assets/images/nature/degleex-ganzorig-wQImoykAwGs-unsplash.jpg',
      'assets/images/nature/florian-schindler-xvldTo5fvrU-unsplash.jpg',
      'assets/images/nature/jeremy-bishop-EwKXn5CapA4-unsplash.jpg',
      'assets/images/nature/le-mucky-4isDWQY0kHI-unsplash.jpg',
      'assets/images/nature/lin-qiu-yi-wan-IEn7ifEeMKM-unsplash.jpg',
      'assets/images/nature/luobing-42Ah4zCgT-w-unsplash.jpg',
      'assets/images/nature/luobing-gRF1pO679ws-unsplash.jpg',
      'assets/images/nature/riccardo-chiarini-2VDa8bnLM8c-unsplash.jpg',
      'assets/images/nature/simon-fitall-5ditmO9_ae0-unsplash.jpg',
      'assets/images/nature/wil-stewart-pHANr-CpbYM-unsplash.jpg',
      'assets/images/nature/aerial photo of green trees.jpg',
      'assets/images/nature/blue starry night.jpg',
      'assets/images/nature/green Northern Lights at night.jpg',
      'assets/images/nature/time lapse photography of body of water.jpg',
      'assets/images/nature/trees surrounded by body water during daytime.jpg',
      'assets/images/nature/a close up of a sand dune with a sky background.jpg',
      'assets/images/nature/a group of antelope standing in the desert.jpg',
    ];

    return imagePool[imageVariant % imagePool.length];
  }

  String _getPersonalizedInsight() {
    final title = widget.story.title.toLowerCase();
    final location = widget.story.location ?? '这个地方';
    final storyId = widget.story.id;
    final hash = storyId.hashCode.abs();
    final variant = hash % 2;

    if (title.contains('美食') || title.contains('探店')) {
      if (variant == 0) {
        return '这次美食之旅让我对$location的饮食文化有了全新的认识。从街边小吃到高档餐厅，每一道菜都承载着当地人的记忆和情感。美食不仅是味蕾的享受，更是了解一座城市最直接的方式。强烈推荐给所有吃货朋友们！';
      } else {
        return '作为一个资深吃货，这次$location的美食探索之旅完全超出了我的预期。无论是传统老店还是创意新餐厅，都让我感受到了这座城市对美食的热爱和坚持。每一口都是幸福的味道，期待下次再来继续探索。';
      }
    } else if (title.contains('住宿') || title.contains('民宿')) {
      if (variant == 0) {
        return '选对住宿真的太重要了！这次精心挑选的民宿不仅位置便利，房东也特别热情，给了很多实用的游玩建议。舒适的住宿环境让整个旅程都变得轻松愉快。好的住宿体验能为旅行加分不少，值得花时间好好选择。';
      } else {
        return '这次住宿体验让我深刻体会到，一个好的落脚点对旅行有多重要。不仅仅是睡觉的地方，更是了解当地生活的窗口。房东分享的故事和建议，让我的旅行变得更加丰富多彩。推荐大家也尝试特色民宿。';
      }
    } else if (title.contains('拍照') ||
        title.contains('打卡') ||
        title.contains('摄影')) {
      if (variant == 0) {
        return '$location真的太适合拍照了！每个角落都是风景，随手一拍都是大片。这次特意研究了最佳拍摄时间和机位，收获满满。如果你也喜欢摄影，一定不要错过这里。记得带上相机，记录下最美的瞬间。';
      } else {
        return '作为摄影爱好者，$location给了我太多创作灵感。从清晨的第一缕阳光到傍晚的金色时刻，每个时段都有不同的美。这次拍摄之旅让我对光影有了更深的理解，也收获了很多满意的作品。期待与大家分享更多拍摄技巧。';
      }
    } else if (title.contains('交通')) {
      if (variant == 0) {
        return '出行前做好交通规划真的能省很多事。这次详细研究了各种交通方式，既节省了时间又控制了预算。分享给大家希望能帮到计划去$location的朋友。合理的交通安排能让旅行更加顺畅，把更多时间留给真正的游玩。';
      } else {
        return '这次旅行让我意识到，交通规划做得好，旅行体验能提升一大截。从机场到酒店，从景点到景点，每一段路程都经过精心安排。虽然前期花了些时间研究，但实际出行时的顺畅让一切都值得。希望这份攻略能帮到大家。';
      }
    } else if (title.contains('周边') || title.contains('小众')) {
      if (variant == 0) {
        return '避开热门景点，探索小众目的地，这次旅行给了我太多惊喜。$location周边还有很多值得一去的地方，人少景美，更能感受到原汁原味的风土人情。如果你也厌倦了人山人海，不妨试试这些小众路线。';
      } else {
        return '这次小众之旅让我重新认识了旅行的意义。远离喧嚣，在安静的角落里感受生活的美好。$location周边的这些地方虽然不出名，但每一处都有自己的故事。慢下来，用心感受，你会发现不一样的风景。';
      }
    } else if (title.contains('三日游') || title.contains('攻略')) {
      if (variant == 0) {
        return '这次$location之行规划得很充实，三天时间把主要景点都逛了一遍。既有深度游览，也有休闲时光，节奏把握得刚刚好。分享这份攻略给大家，希望能帮助到计划去$location的朋友们。记得根据自己的节奏调整行程哦。';
      } else {
        return '三天的时间说长不长，说短不短，但只要规划得当，也能玩得很尽兴。这次$location之旅让我对这座城市有了全面的了解，从历史文化到现代生活，从自然风光到人文景观。希望这份攻略能给大家一些参考和启发。';
      }
    } else {
      if (variant == 0) {
        return '这次旅行让我深深感受到了${location}的独特魅力。无论是自然风光还是人文景观，都给我留下了深刻的印象。每一次旅行都是一次成长，让我看到了不一样的世界。特别推荐给喜欢深度游的朋友们，相信你们也会爱上这里。';
      } else {
        return '${location}之行圆满结束，回想起来依然觉得意犹未尽。这里的一切都那么美好，从风景到美食，从人文到自然。旅行的意义不仅在于看到了什么，更在于感受到了什么。期待下次再来，继续探索这座城市的更多可能。';
      }
    }
  }

  List<Map<String, dynamic>> _getTransportOptions() {
    final title = widget.story.title.toLowerCase();

    if (title.contains('交通')) {
      return [
        {
          'icon': Icons.flight,
          'title': '航空出行',
          'content': '提前2-3个月预订机票价格最优，关注航司会员日活动',
        },
        {
          'icon': Icons.train,
          'title': '高铁动车',
          'content': '准点率高，舒适度好，适合中短途旅行',
        },
        {
          'icon': Icons.directions_car,
          'title': '自驾游',
          'content': '时间自由，可以随时停靠，适合家庭出游',
        },
        {
          'icon': Icons.directions_bus,
          'title': '市内交通',
          'content': '办理交通卡或使用乘车码，地铁公交都很方便',
        },
      ];
    } else if (title.contains('citywalk') ||
        title.contains('城市') ||
        title.contains('上海')) {
      return [
        {
          'icon': Icons.directions_subway,
          'title': '地铁',
          'content': '最推荐的出行方式，准时快捷，覆盖主要景点',
        },
        {
          'icon': Icons.directions_walk,
          'title': '步行',
          'content': 'Citywalk最佳方式，慢慢走慢慢看，感受城市魅力',
        },
        {
          'icon': Icons.pedal_bike,
          'title': '共享单车',
          'content': '短途出行很方便，还能锻炼身体',
        },
      ];
    } else if (title.contains('周边') ||
        title.contains('小众') ||
        title.contains('自然')) {
      return [
        {
          'icon': Icons.directions_car,
          'title': '自驾',
          'content': '最适合周边游，时间自由，可以深入探索',
        },
        {
          'icon': Icons.directions_bus,
          'title': '包车',
          'content': '人多可以考虑包车，省心省力',
        },
        {
          'icon': Icons.local_taxi,
          'title': '打车',
          'content': '景点之间距离远可以打车，注意提前叫车',
        },
      ];
    } else {
      return [
        {
          'icon': Icons.flight,
          'title': '飞机',
          'content': '直飞最方便，提前预订可享优惠价格',
        },
        {
          'icon': Icons.train,
          'title': '高铁/火车',
          'content': '性价比高，沿途风景优美',
        },
        {
          'icon': Icons.directions_bus,
          'title': '市内交通',
          'content': '地铁、公交、打车都很方便，建议办理交通卡',
        },
      ];
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

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? '已收藏到我的页面' : '已取消收藏'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFollowing ? '已关注 ${widget.story.author}' : '已取消关注'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentSheet(
        commentCount: _commentCount,
        storyId: widget.story.id,
        storyTitle: widget.story.title,
      ),
    );
  }

  void _showMoreOptions() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OptionItem(
                icon: Icons.block_outlined,
                title: '拉黑作者',
                color: Colors.grey.shade800,
                onTap: () {
                  Navigator.pop(context);
                  _handleBlock();
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 0.5,
                color: Colors.grey.shade200,
              ),
              _OptionItem(
                icon: Icons.visibility_off_outlined,
                title: '屏蔽此内容',
                color: Colors.grey.shade800,
                onTap: () {
                  Navigator.pop(context);
                  _handleHide();
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 0.5,
                color: Colors.grey.shade200,
              ),
              _OptionItem(
                icon: Icons.flag_outlined,
                title: '举报',
                color: Colors.red.shade600,
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

  void _handleBlock() async {
    final storage = StorageService();
    await storage.blockAuthor(widget.story.author);

    // 返回上一页并传递刷新标记
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已拉黑作者"${widget.story.author}"，将不再看到TA的内容'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleHide() async {
    final storage = StorageService();
    await storage.hideStory(widget.story.id);

    // 返回上一页并传递刷新标记
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已屏蔽此内容'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReportDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(
          storyId: widget.story.id,
          storyTitle: widget.story.title,
          authorName: widget.story.author,
        ),
      ),
    );
  }

  List<Map<String, String>> _getItinerary() {
    final title = widget.story.title.toLowerCase();
    final location = widget.story.location ?? '';
    final storyId = widget.story.id;
    final hash = storyId.hashCode.abs();

    // 根据story ID生成不同的行程变体
    final variant = hash % 3;

    List<Map<String, String>> itinerary = [];

    // 根据游记标题生成不同的行程
    if (title.contains('三日游') || title.contains('攻略')) {
      if (variant == 0) {
        itinerary = [
          {
            'day': 'Day 1',
            'title': '初到$location',
            'content':
                '上午抵达后先去酒店办理入住，下午在附近闲逛熟悉环境。傍晚找一家当地特色餐厅，品尝地道美食，为明天的行程养精蓄锐。',
          },
          {
            'day': 'Day 2',
            'title': '经典景点打卡',
            'content': '一早出发前往必游景点，建议7点前到达避开人流。中午在景区附近用餐，下午继续游览周边景点，晚上可以逛逛夜市。',
          },
          {
            'day': 'Day 3',
            'title': '深度文化体验',
            'content': '上午参观博物馆了解历史文化，下午体验当地特色活动。傍晚在老街散步，购买特产和纪念品，结束愉快的旅程。',
          },
        ];
      } else if (variant == 1) {
        itinerary = [
          {
            'day': 'Day 1',
            'title': '抵达与休整',
            'content': '中午到达办理入住，下午在酒店周边探索，找一家咖啡馆坐坐。晚上去当地人推荐的餐厅，感受地道的饮食文化。',
          },
          {
            'day': 'Day 2',
            'title': '自然风光之旅',
            'content': '清晨出发前往自然景区，呼吸新鲜空气。中午野餐或在景区餐厅用餐，下午继续徒步探索，傍晚返回市区休息。',
          },
          {
            'day': 'Day 3',
            'title': '休闲购物日',
            'content': '睡到自然醒，上午逛逛特色街区和市集。下午在商业区购物，为亲朋好友挑选礼物。晚上整理行李准备返程。',
          },
        ];
      } else {
        itinerary = [
          {
            'day': 'Day 1',
            'title': '城市初印象',
            'content': '下午抵达后先去网红打卡点拍照，感受城市氛围。晚上在繁华商圈逛街，体验当地的夜生活，品尝特色小吃。',
          },
          {
            'day': 'Day 2',
            'title': '历史文化探索',
            'content': '上午游览古建筑群，了解历史故事。下午参观艺术馆或文化中心，傍晚在古街漫步，感受传统与现代的交融。',
          },
          {
            'day': 'Day 3',
            'title': '美食寻味之旅',
            'content': '专门安排一天品尝当地美食，从早茶到夜宵，打卡各种特色餐厅。下午可以参加美食制作体验课程。',
          },
        ];
      }
    } else if (title.contains('美食') || title.contains('探店')) {
      final foodVariant = hash % 2;
      if (foodVariant == 0) {
        itinerary = [
          {
            'day': '早餐',
            'title': '传统早点',
            'content': '从当地特色早餐开始一天，推荐尝试传统小吃。找一家老字号，感受最地道的味道和热闹的氛围。',
          },
          {
            'day': '午餐',
            'title': '招牌菜品',
            'content': '中午前往当地知名餐厅，品尝招牌菜。建议提前预约，避开用餐高峰期，慢慢享受美食时光。',
          },
          {
            'day': '晚餐',
            'title': '夜市小吃',
            'content': '晚上逛夜市，品尝各种街头美食。这里汇集了最接地气的小吃，价格实惠，种类丰富，不容错过。',
          },
        ];
      } else {
        itinerary = [
          {
            'day': '上午',
            'title': '网红餐厅',
            'content': '打卡ins风网红餐厅，不仅味道好，环境也很适合拍照。记得提前预约，热门时段需要等位。',
          },
          {
            'day': '下午',
            'title': '甜品下午茶',
            'content': '下午找一家精致的甜品店，享受悠闲的下午茶时光。推荐尝试当地特色甜品和手工咖啡。',
          },
          {
            'day': '晚上',
            'title': '深夜食堂',
            'content': '晚上去当地人常去的深夜食堂，感受烟火气。这里的食物简单却温暖，是了解城市的另一种方式。',
          },
        ];
      }
    } else if (title.contains('住宿') || title.contains('民宿')) {
      itinerary = [
        {
          'day': '位置',
          'title': '交通便利性',
          'content': '优先选择靠近地铁站或景区的住宿，出行方便能节省大量时间。查看周边配套设施是否齐全。',
        },
        {
          'day': '环境',
          'title': '房间舒适度',
          'content': '关注房间大小、采光、隔音效果。查看床品质量和卫生状况，确保有良好的休息环境。',
        },
        {
          'day': '体验',
          'title': '特色服务',
          'content': '选择有特色的民宿，房东的热情服务和当地建议能让旅行更加丰富。注意查看真实评价。',
        },
      ];
    } else if (title.contains('拍照') ||
        title.contains('打卡') ||
        title.contains('摄影')) {
      final photoVariant = hash % 2;
      if (photoVariant == 0) {
        itinerary = [
          {
            'day': '日出',
            'title': '晨光时刻',
            'content': '清晨5-6点是拍摄日出的最佳时间，光线温柔，色彩丰富。提前踩点选好机位，等待最美的瞬间。',
          },
          {
            'day': '白天',
            'title': '建筑人文',
            'content': '上午光线适合拍摄建筑和街景，寻找有特色的角度。注意构图和光影，避开正午的强光。',
          },
          {
            'day': '日落',
            'title': '黄金时刻',
            'content': '傍晚的金色光线最适合拍人像，找一个视野开阔的地方。日落前后半小时是摄影的黄金时段。',
          },
        ];
      } else {
        itinerary = [
          {
            'day': '蓝调时刻',
            'title': '日落后拍摄',
            'content': '日落后15-30分钟的蓝调时刻，天空呈现迷人的蓝紫色。这是拍摄城市夜景的最佳时机。',
          },
          {
            'day': '夜景',
            'title': '灯光璀璨',
            'content': '夜晚拍摄城市灯光，使用三脚架保证稳定。尝试长曝光拍摄车流和人流，创造动感效果。',
          },
          {
            'day': '特色',
            'title': '创意角度',
            'content': '寻找独特的拍摄角度，如倒影、剪影、框架构图。多尝试不同视角，创作出与众不同的作品。',
          },
        ];
      }
    } else if (title.contains('交通')) {
      itinerary = [
        {
          'day': '出发',
          'title': '选择交通方式',
          'content': '根据距离和预算选择合适的交通工具。飞机快捷但价格高，高铁舒适性价比好，自驾自由度高。',
        },
        {
          'day': '市内',
          'title': '公共交通',
          'content': '到达后办理交通卡，地铁公交都能用。下载当地交通APP，查询路线更方便，避开高峰期出行。',
        },
        {
          'day': '返程',
          'title': '提前规划',
          'content': '返程前一天确认车次或航班，预留充足时间前往车站机场。避免因堵车或其他原因误点。',
        },
      ];
    } else if (title.contains('周边') || title.contains('小众')) {
      itinerary = [
        {
          'day': '上午',
          'title': '出发探索',
          'content': '早起出发前往小众目的地，避开人潮享受宁静。带上相机记录沿途风景，每一处都是惊喜。',
        },
        {
          'day': '下午',
          'title': '深度游览',
          'content': '慢慢游览，不赶时间。可以和当地人聊聊天，了解这里的故事。在自然中放松身心，远离城市喧嚣。',
        },
        {
          'day': '傍晚',
          'title': '返程休息',
          'content': '傍晚返回，在当地餐厅享用晚餐。回顾一天的收获，分享旅行的快乐和感动。',
        },
      ];
    } else {
      // 默认行程 - 根据hash生成不同变体
      final defaultVariant = hash % 3;
      const dayTitles = [
        ['初识之旅', '深度探索', '悠闲时光'],
        ['开启旅程', '精彩体验', '完美收官'],
        ['第一印象', '沉浸式游览', '回味无穷'],
      ];

      itinerary = [
        {
          'day': 'Day 1',
          'title': dayTitles[defaultVariant][0],
          'content': '抵达后先熟悉周边环境，在附近逛逛，品尝当地美食，为接下来的行程做准备。保持轻松的心态，慢慢适应新环境。',
        },
        {
          'day': 'Day 2',
          'title': dayTitles[defaultVariant][1],
          'content': '游览主要景点，深入了解当地文化。合理安排时间，既不赶路也不错过精彩。用心感受每一个瞬间。',
        },
        {
          'day': 'Day 3',
          'title': dayTitles[defaultVariant][2],
          'content': '放慢节奏，享受旅行的乐趣。可以去咖啡馆坐坐，或者在公园散步，感受当地生活的美好。',
        },
      ];
    }

    // 为每个行程项添加个性化的图片
    for (int i = 0; i < itinerary.length; i++) {
      itinerary[i]['image'] = _getImageForItinerary(i, title);
    }

    return itinerary;
  }

  List<String> _getTravelTips() {
    final title = widget.story.title.toLowerCase();
    final storyId = widget.story.id;
    final hash = storyId.hashCode.abs();
    final variant = hash % 2;

    if (title.contains('美食') || title.contains('探店')) {
      if (variant == 0) {
        return [
          '热门餐厅建议提前1-2天预约',
          '尝试当地特色小吃，但注意饮食卫生',
          '可以向当地人打听隐藏的美食店',
          '带上肠胃药以防水土不服',
          '用餐高峰期避开12点和18点',
          '记录美食店的位置，方便下次再来',
        ];
      } else {
        return [
          '网红店排队时间长，建议非高峰期前往',
          '多尝试街边小店，往往有惊喜',
          '注意查看食物过敏原信息',
          '拍照后尽快享用，趁热吃最美味',
          '询问服务员推荐菜品，通常不会错',
          '保存餐厅名片，方便分享给朋友',
        ];
      }
    } else if (title.contains('住宿') || title.contains('民宿')) {
      if (variant == 0) {
        return [
          '提前2周预订可以享受更优惠的价格',
          '仔细阅读评价，特别关注差评内容',
          '确认退改政策，以防行程变化',
          '入住时检查房间设施是否完好',
          '保管好贵重物品，使用保险箱',
          '与房东保持良好沟通，获取当地建议',
        ];
      } else {
        return [
          '选择可以免费取消的房型更灵活',
          '查看房间实拍图，避免照骗',
          '了解周边环境，确保安全和便利',
          '询问是否提供早餐和接送服务',
          '记录房东联系方式，方便紧急联系',
          '退房前检查是否有遗落物品',
        ];
      }
    } else if (title.contains('拍照') ||
        title.contains('打卡') ||
        title.contains('摄影')) {
      if (variant == 0) {
        return [
          '清晨和傍晚是拍照的最佳时间',
          '充满电池和准备备用存储卡',
          '了解当地的拍照禁忌和规定',
          '使用三脚架可以拍出更稳定的照片',
          '尊重他人隐私，拍摄前征得同意',
          '及时备份照片到云端，防止丢失',
        ];
      } else {
        return [
          '研究最佳拍摄机位，提前踩点',
          '带上清洁工具，保持镜头清洁',
          '尝试不同角度和构图方式',
          '利用自然光线，避免过度后期',
          '拍摄人像时注意背景是否杂乱',
          '保存RAW格式，后期调整空间更大',
        ];
      }
    } else if (title.contains('交通')) {
      if (variant == 0) {
        return [
          '提前下载当地交通APP和离线地图',
          '办理交通卡比单次购票更划算',
          '注意地铁和公交的首末班时间',
          '打车时使用正规平台，注意安全',
          '预留充足时间，避免赶不上车',
          '保存重要地点的地址和联系方式',
        ];
      } else {
        return [
          '高峰期避免乘坐公共交通，太拥挤',
          '了解当地交通规则，避免违规',
          '保留所有交通票据，方便报销',
          '长途旅行准备颈枕和眼罩',
          '随身携带充电宝，手机不断电',
          '提前了解目的地的停车情况',
        ];
      }
    } else if (title.contains('周边') || title.contains('小众')) {
      if (variant == 0) {
        return [
          '小众景点信息较少，提前做好攻略',
          '准备好户外装备，如防晒、防虫用品',
          '告知家人或朋友你的行程安排',
          '带上充足的水和食物',
          '尊重当地环境，不留下垃圾',
          '注意天气变化，做好应对准备',
        ];
      } else {
        return [
          '穿着舒适的鞋子，适合长时间行走',
          '带上急救包，以防意外受伤',
          '下载离线地图，避免迷路',
          '尊重当地居民，不打扰他们生活',
          '拍照时注意脚下安全',
          '保持手机电量，方便紧急联系',
        ];
      }
    } else if (title.contains('三日游') || title.contains('攻略')) {
      if (variant == 0) {
        return [
          '提前规划行程，但保留灵活调整空间',
          '预订门票和餐厅，节省现场排队时间',
          '准备一个小背包，装日常必需品',
          '每天不要安排太满，留出休息时间',
          '记录旅行日记，留下美好回忆',
          '购买旅行保险，保障出行安全',
        ];
      } else {
        return [
          '根据天气调整行程，雨天室内活动',
          '合理分配预算，避免超支',
          '带上常用药品，以备不时之需',
          '学几句当地语言，方便沟通',
          '关注当地节日活动，体验特色文化',
          '保持开放心态，享受旅行的每一刻',
        ];
      }
    } else {
      // 默认tips - 根据hash生成不同组合
      if (variant == 0) {
        return [
          '提前预订门票可以节省排队时间',
          '早晨和傍晚是拍照的最佳时间',
          '随身携带充电宝和雨具',
          '尝试当地特色小吃，但注意饮食卫生',
          '尊重当地文化习俗和宗教信仰',
          '保管好贵重物品，注意人身安全',
        ];
      } else {
        return [
          '穿着舒适的鞋子，方便长时间行走',
          '带上防晒用品，保护皮肤',
          '保持手机电量充足，方便联系',
          '多喝水，保持身体水分',
          '与当地人交流，了解更多信息',
          '享受旅行过程，不要太赶时间',
        ];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            actions: [
              Container(
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
                  icon: Icon(Icons.more_horiz, color: Colors.black),
                  onPressed: _showMoreOptions,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.story.imageUrl,
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
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Author Info
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.story.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Author Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: widget.story.avatarUrl != null
                            ? NetworkImage(widget.story.avatarUrl!)
                            : null,
                        backgroundColor: AppTheme.primaryPink.withOpacity(0.2),
                        child: widget.story.avatarUrl == null
                            ? Text(
                                widget.story.author[0],
                                style: TextStyle(
                                  color: AppTheme.primaryPink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                              widget.story.author,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: Colors.grey.shade500),
                                SizedBox(width: 4),
                                Text(
                                  widget.story.location ?? '未知地点',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.access_time,
                                    size: 14, color: Colors.grey.shade500),
                                SizedBox(width: 4),
                                Text(
                                  _formatDate(widget.story.createdAt),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleFollow,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _isFollowing
                                ? Colors.grey.shade200
                                : AppTheme.primaryPink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isFollowing ? '已关注' : '关注',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _isFollowing
                                  ? Colors.grey.shade700
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // Tags
                  if (widget.story.tags != null &&
                      widget.story.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.story.tags!.map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.primaryPink.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryPink,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),

          // Travel Story Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: '✨ 游记心得'),
                  SizedBox(height: 12),
                  Text(
                    widget.story.content,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.8,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _getPersonalizedInsight(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade700,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Itinerary Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: '📅 行程安排'),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: _getItinerary().map((item) {
                  return _ItineraryCard(
                    day: item['day']!,
                    title: item['title']!,
                    content: item['content']!,
                    imageUrl: item['image']!,
                  );
                }).toList(),
              ),
            ),
          ),

          // Transportation Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: '🚗 交通出行'),
                    SizedBox(height: 12),
                    ...(_getTransportOptions().map((item) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _TransportItem(
                          icon: item['icon'] as IconData,
                          title: item['title'] as String,
                          content: item['content'] as String,
                        ),
                      );
                    }).toList()),
                  ],
                ),
              ),
            ),
          ),

          // Travel Tips Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionTitle(title: '💡 旅游Tips'),
                    SizedBox(height: 12),
                    ...(_getTravelTips().map((tip) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFA500),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade800,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Interaction Bar
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Like Button
              GestureDetector(
                onTap: _toggleLike,
                child: Row(
                  children: [
                    Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked
                          ? AppTheme.primaryPink
                          : Colors.grey.shade600,
                      size: 24,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '$_likeCount',
                      style: TextStyle(
                        fontSize: 14,
                        color: _isLiked
                            ? AppTheme.primaryPink
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 32),

              // Comment Button
              GestureDetector(
                onTap: _showComments,
                child: Row(
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '$_commentCount',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Spacer(),

              // Bookmark Button
              GestureDetector(
                onTap: _toggleBookmark,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _isBookmarked
                        ? AppTheme.primaryPink
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color:
                            _isBookmarked ? Colors.white : Colors.grey.shade700,
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        _isBookmarked ? '已收藏' : '收藏',
                        style: TextStyle(
                          fontSize: 14,
                          color: _isBookmarked
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade900,
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  final String day;
  final String title;
  final String content;
  final String imageUrl;

  const _ItineraryCard({
    required this.day,
    required this.title,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                  );
                },
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPink,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.6,
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

class _TransportItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _TransportItem({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppTheme.primaryPink),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Comment Sheet Widget
class _CommentSheet extends StatefulWidget {
  final int commentCount;
  final String storyId;
  final String storyTitle;

  const _CommentSheet({
    required this.commentCount,
    required this.storyId,
    required this.storyTitle,
  });

  @override
  State<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<_CommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = _generateCommentsForStory();

    _commentController.addListener(() {
      setState(() {});
    });
  }

  List<Map<String, dynamic>> _generateCommentsForStory() {
    // 所有可能的评论模板
    final commentTemplates = [
      {
        'templates': [
          '写得太好了！我也想去这里旅游了',
          '攻略很详细，已收藏！',
          '照片拍得真美，请问用的什么相机？',
          '这个地方我去过，确实很不错',
          '感谢分享，正好在计划去这里',
          '太实用了，马上就要出发了',
          '请问住宿推荐哪里比较好？',
          '交通方便吗？',
          '大概需要几天时间？',
          '预算大概多少合适？',
          '有什么必吃的美食吗？',
          '什么季节去最合适？',
          '可以带小孩去吗？',
          '景点门票贵吗？',
          '周边还有什么值得去的地方？',
        ],
        'authors': [
          '旅行爱好者',
          '摄影师小李',
          '美食达人',
          '背包客阿明',
          '周末去哪儿',
          '自由行小助手',
          '旅游博主',
          '探险家小王',
          '度假达人',
          '户外运动爱好者',
          '文艺青年',
          '亲子游妈妈',
        ],
      },
    ];

    // 根据story id生成固定的随机评论
    final hash = widget.storyId.hashCode.abs();
    final random = hash;

    final templates = commentTemplates[0]['templates'] as List<String>;
    final authors = commentTemplates[0]['authors'] as List<String>;

    final numComments = 3 + (hash % 5); // 3-7条评论
    final comments = <Map<String, dynamic>>[];

    for (int i = 0; i < numComments; i++) {
      final templateIndex = (random + i * 7) % templates.length;
      final authorIndex = (random + i * 3) % authors.length;
      final seedIndex = (random + i * 11) % 100;

      final timeOptions = [
        '刚刚',
        '5分钟前',
        '1小时前',
        '2小时前',
        '5小时前',
        '1天前',
        '2天前',
        '3天前'
      ];
      final timeIndex = (random + i * 5) % timeOptions.length;

      final likes = 1 + ((random + i * 13) % 30);

      comments.add({
        'author': authors[authorIndex],
        'avatar':
            'https://api.dicebear.com/7.x/avataaars/png?seed=user$seedIndex',
        'content': templates[templateIndex],
        'time': timeOptions[timeIndex],
        'likes': likes,
      });
    }

    return comments;
  }

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendComment() {
    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'author': '漫游雨林的树懒',
        'avatar':
            'https://api.dicebear.com/7.x/fun-emoji/png?seed=sloth&backgroundColor=f9457a',
        'content': _commentController.text.trim(),
        'time': '刚刚',
        'likes': 0,
      });
    });

    _commentController.clear();
    _focusNode.unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('评论发送成功'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '评论 ${_comments.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey.shade600),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Comments List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            NetworkImage(comment['avatar'] as String),
                        backgroundColor: AppTheme.primaryPink.withOpacity(0.2),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment['author'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade900,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  comment['time'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6),
                            Text(
                              comment['content'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.favorite_border,
                                    size: 16, color: Colors.grey.shade400),
                                SizedBox(width: 4),
                                Text(
                                  '${comment['likes']}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _commentController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: '说点什么...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendComment(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendComment,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _commentController.text.trim().isNotEmpty
                            ? AppTheme.primaryPink
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Option Item Widget
class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Report Screen
class ReportScreen extends StatefulWidget {
  final String storyId;
  final String storyTitle;
  final String authorName;

  const ReportScreen({
    super.key,
    required this.storyId,
    required this.storyTitle,
    required this.authorName,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int? _selectedReasonIndex;
  final TextEditingController _detailController = TextEditingController();

  final List<String> _reportReasons = [
    '虚假信息',
    '垃圾广告',
    '色情低俗',
    '违法违规',
    '侵犯版权',
    '人身攻击',
    '其他原因',
  ];

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_selectedReasonIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('请选择举报原因'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('举报已提交，我们会尽快处理'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '举报内容',
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '举报内容',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          widget.storyTitle,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          '作者：${widget.authorName}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reasons
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '举报原因',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        SizedBox(height: 16),
                        ...(_reportReasons.asMap().entries.map((entry) {
                          final index = entry.key;
                          final reason = entry.value;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedReasonIndex = index;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _selectedReasonIndex == index
                                    ? AppTheme.primaryPink.withOpacity(0.1)
                                    : Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedReasonIndex == index
                                      ? AppTheme.primaryPink
                                      : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _selectedReasonIndex == index
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,
                                    size: 20,
                                    color: _selectedReasonIndex == index
                                        ? AppTheme.primaryPink
                                        : Colors.grey.shade400,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    reason,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _selectedReasonIndex == index
                                          ? AppTheme.primaryPink
                                          : Colors.grey.shade700,
                                      fontWeight: _selectedReasonIndex == index
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList()),
                      ],
                    ),
                  ),

                  // Detail Input
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '补充说明（选填）',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _detailController,
                          maxLines: 4,
                          maxLength: 200,
                          decoration: InputDecoration(
                            hintText: '请详细描述举报原因，帮助我们更好地处理...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit Button
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPink,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '提交举报',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
