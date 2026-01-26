import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ItineraryDetailScreen extends StatefulWidget {
  final String id;
  final String title;
  final String destination;
  final String departureDate;
  final String duration;
  final String distance;
  final String imageUrl;
  final Color color;

  const ItineraryDetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.destination,
    required this.departureDate,
    required this.duration,
    required this.distance,
    required this.imageUrl,
    required this.color,
  });

  @override
  State<ItineraryDetailScreen> createState() => _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState extends State<ItineraryDetailScreen> {
  final StorageService _storageService = StorageService();

  Future<void> _deleteItinerary() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除行程'),
        content: Text('确定要删除这个行程吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('删除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storageService.deleteItinerary(widget.id);
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('行程已删除'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Close detail screen and return to profile
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Hero Image Header
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: _deleteItinerary,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // 判断是网络图片还是本地资源
                  widget.imageUrl.startsWith('http')
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image,
                                  size: 80, color: Colors.grey),
                            );
                          },
                        )
                      : Image.asset(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: Icon(Icons.image,
                                  size: 80, color: Colors.grey),
                            );
                          },
                        ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Title overlay
                  Positioned(
                    bottom: 24,
                    left: 24,
                    right: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.white70),
                            SizedBox(width: 4),
                            Text(
                              widget.destination,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white70,
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

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.calendar_today_outlined,
                          label: '出发日期',
                          value: widget.departureDate,
                          color: widget.color,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _InfoCard(
                          icon: Icons.access_time,
                          label: '行程时长',
                          value: widget.duration,
                          color: widget.color,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _InfoCard(
                    icon: Icons.navigation_outlined,
                    label: '总距离',
                    value: widget.distance,
                    color: widget.color,
                    isWide: true,
                  ),

                  SizedBox(height: 32),

                  // Day by Day Itinerary
                  Text(
                    '行程安排',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 20),

                  ..._buildDayItinerary(),

                  SizedBox(height: 32),

                  // Travel Tips
                  Text(
                    '旅行贴士',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 16),

                  ..._buildTravelTips(),

                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDayItinerary() {
    final days = _getDayCount();
    return List.generate(days, (index) {
      final dayNum = index + 1;
      return _DayCard(
        dayNumber: dayNum,
        activities: _getActivitiesForDay(dayNum),
        color: widget.color,
      );
    });
  }

  int _getDayCount() {
    final match = RegExp(r'(\d+)天').firstMatch(widget.duration);
    return match != null ? int.parse(match.group(1)!) : 3;
  }

  List<Map<String, String>> _getActivitiesForDay(int day) {
    if (widget.destination.contains('大理')) {
      switch (day) {
        case 1:
          return [
            {'time': '09:00', 'activity': '抵达大理古城', 'desc': '入住客栈，感受古城氛围'},
            {'time': '14:00', 'activity': '漫步古城', 'desc': '人民路、洋人街闲逛'},
            {'time': '18:00', 'activity': '古城晚餐', 'desc': '品尝白族特色美食'},
          ];
        case 2:
          return [
            {'time': '08:00', 'activity': '环洱海骑行', 'desc': '租电动车环海东路'},
            {'time': '12:00', 'activity': '海边午餐', 'desc': '双廊古镇用餐'},
            {'time': '16:00', 'activity': '喜洲古镇', 'desc': '参观白族民居'},
          ];
        default:
          return [
            {'time': '09:00', 'activity': '苍山索道', 'desc': '登顶俯瞰洱海'},
            {'time': '14:00', 'activity': '崇圣寺三塔', 'desc': '感受历史文化'},
            {'time': '17:00', 'activity': '返程', 'desc': '结束愉快旅程'},
          ];
      }
    } else {
      // 乌镇行程
      switch (day) {
        case 1:
          return [
            {'time': '10:00', 'activity': '抵达乌镇', 'desc': '入住民宿'},
            {'time': '14:00', 'activity': '东栅游览', 'desc': '江南水乡风光'},
            {'time': '18:00', 'activity': '水乡夜景', 'desc': '欣赏灯光秀'},
          ];
        case 2:
          return [
            {'time': '09:00', 'activity': '西栅漫步', 'desc': '深度游览古镇'},
            {'time': '12:00', 'activity': '特色午餐', 'desc': '品尝江南美食'},
            {'time': '15:00', 'activity': '手工体验', 'desc': '蓝印花布制作'},
          ];
        default:
          return [
            {'time': '09:00', 'activity': '茶馆品茶', 'desc': '体验慢生活'},
            {'time': '11:00', 'activity': '返程', 'desc': '结束旅程'},
          ];
      }
    }
  }

  List<Widget> _buildTravelTips() {
    final tips = widget.destination.contains('大理')
        ? [
            {'icon': Icons.wb_sunny, 'title': '最佳季节', 'desc': '3-5月、9-11月气候宜人'},
            {'icon': Icons.checkroom, 'title': '穿衣建议', 'desc': '早晚温差大，备好外套'},
            {'icon': Icons.restaurant, 'title': '美食推荐', 'desc': '白族三道茶、乳扇、饵块'},
            {
              'icon': Icons.directions_bus,
              'title': '交通提示',
              'desc': '古城内步行，环海可租车'
            },
          ]
        : [
            {'icon': Icons.wb_sunny, 'title': '最佳季节', 'desc': '春秋两季最适合游览'},
            {'icon': Icons.checkroom, 'title': '穿衣建议', 'desc': '舒适休闲装，备雨具'},
            {'icon': Icons.restaurant, 'title': '美食推荐', 'desc': '红烧羊肉、白水鱼、定胜糕'},
            {'icon': Icons.directions_bus, 'title': '交通提示', 'desc': '古镇内步行游览'},
          ];

    return tips.map((tip) {
      return Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                tip['icon'] as IconData,
                color: widget.color,
                size: 22,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip['title'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    tip['desc'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isWide;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
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

class _DayCard extends StatelessWidget {
  final int dayNumber;
  final List<Map<String, String>> activities;
  final Color color;

  const _DayCard({
    required this.dayNumber,
    required this.activities,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'D$dayNumber',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Text(
                '第${_numberToChinese(dayNumber)}天',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Activities
          ...activities.asMap().entries.map((entry) {
            final index = entry.key;
            final activity = entry.value;
            final isLast = index == activities.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline
                Column(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 60,
                        color: color.withOpacity(0.2),
                      ),
                  ],
                ),
                SizedBox(width: 16),

                // Activity Content
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity['time']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          activity['activity']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          activity['desc']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _numberToChinese(int num) {
    const numbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    return num <= 10 ? numbers[num - 1] : num.toString();
  }
}
