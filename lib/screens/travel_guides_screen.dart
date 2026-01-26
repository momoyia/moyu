import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TravelGuidesScreen extends StatelessWidget {
  const TravelGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guides = [
      {
        'place': '周末citywalk',
        'province': '上海',
        'imageUrl': 'assets/images/culture/adam-kool-ndN00KmbJ1c-unsplash.jpg',
        'description': '漫步魔都街头，感受都市的烟火气息',
        'duration': '2天1夜',
        'budget': '¥800-1500',
        'tags': ['城市漫步', '美食', '文艺'],
      },
      {
        'place': '说走就走',
        'province': '云南',
        'imageUrl': 'assets/images/culture/amo-fif-95YGku-EF_g-unsplash.jpg',
        'description': '彩云之南，诗和远方的完美结合',
        'duration': '5天4夜',
        'budget': '¥2500-4000',
        'tags': ['自然风光', '古镇', '民族文化'],
      },
      {
        'place': '治愈系小城',
        'province': '浙江',
        'imageUrl': 'assets/images/culture/amo-fif-iIqENVbSaOY-unsplash.jpg',
        'description': '江南水乡，慢生活的最佳选择',
        'duration': '3天2夜',
        'budget': '¥1200-2000',
        'tags': ['古镇', '慢生活', '江南'],
      },
      {
        'place': '慢生活指南',
        'province': '福建',
        'imageUrl':
            'assets/images/culture/anna-mircea-vDeO-TlZFOY-unsplash.jpg',
        'description': '闽南风情，海岛与古厝的浪漫',
        'duration': '4天3夜',
        'budget': '¥1800-3000',
        'tags': ['海岛', '古建筑', '美食'],
      },
      {
        'place': '山野探险',
        'province': '四川',
        'imageUrl':
            'assets/images/culture/annie-spratt-upJFoyr7BBA-unsplash.jpg',
        'description': '雪山草地，探索川西秘境',
        'duration': '6天5夜',
        'budget': '¥3000-5000',
        'tags': ['雪山', '草原', '徒步'],
      },
      {
        'place': '海滨度假',
        'province': '海南',
        'imageUrl':
            'assets/images/culture/arol-vinolas-OEgC5_q9MaE-unsplash.jpg',
        'description': '碧海蓝天，热带风情的悠闲时光',
        'duration': '4天3夜',
        'budget': '¥2000-3500',
        'tags': ['海滩', '潜水', '度假'],
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
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
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryPink.withOpacity(0.1),
                      AppTheme.accentPurple.withOpacity(0.1),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 60, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: AppTheme.primaryPink,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              '出行攻略',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '精心策划的旅行路线，让你的旅程更完美',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Grid Layout
          SliverPadding(
            padding: EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _TravelGuideCard(guide: guides[index]);
                },
                childCount: guides.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _TravelGuideCard extends StatelessWidget {
  final Map<String, dynamic> guide;

  const _TravelGuideCard({required this.guide});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to guide detail
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      child: Image.network(
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
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Province tag
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        guide['province'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      guide['place'] as String,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),

                    // Description
                    Text(
                      guide['description'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Spacer(),

                    // Info row
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 12, color: Colors.grey.shade400),
                        SizedBox(width: 4),
                        Text(
                          guide['duration'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            size: 12, color: Colors.grey.shade400),
                        SizedBox(width: 4),
                        Text(
                          guide['budget'] as String,
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
            ),
          ],
        ),
      ),
    );
  }
}
