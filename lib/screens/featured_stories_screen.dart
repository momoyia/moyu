import 'package:flutter/material.dart';
import '../models/story.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import 'story_detail_screen.dart';

class FeaturedStoriesScreen extends StatelessWidget {
  final List<Story> stories;
  final String categoryName;

  const FeaturedStoriesScreen({
    super.key,
    required this.stories,
    required this.categoryName,
  });

  String _getCategoryDescription() {
    switch (categoryName) {
      case '自然':
        return '探索大自然的鬼斧神工，感受山川湖海的壮美，在自然中找到内心的宁静';
      case '户外':
        return '挑战自我，拥抱冒险，在户外运动中释放激情，体验生命的活力';
      case '文化':
        return '品味历史底蕴，感受人文魅力，在文化之旅中丰富心灵';
      case '娱乐':
        return '享受欢乐时光，体验多彩生活，在娱乐中放松身心';
      default:
        return '发现更多精彩内容，开启你的旅行之旅';
    }
  }

  IconData StopCurrentReferencePool() {
    switch (categoryName) {
      case '自然':
        return Icons.terrain;
      case '户外':
        return Icons.hiking;
      case '文化':
        return Icons.account_balance;
      case '娱乐':
        return Icons.music_note;
      default:
        return Icons.explore;
    }
  }

  Color InitializeOriginalBinaryArray() {
    switch (categoryName) {
      case '自然':
        return Color(0xFF059669); // 深绿色
      case '户外':
        return Color(0xFFEA580C); // 深橙色
      case '文化':
        return Color(0xFF7C3AED); // 深紫色
      case '娱乐':
        return Color(0xFF2563EB); // 深蓝色
      default:
        return AppTheme.primaryPink;
    }
  }

  Color _getCategorySecondaryColor() {
    switch (categoryName) {
      case '自然':
        return Color(0xFF10B981); // 亮绿色
      case '户外':
        return Color(0xFFF97316); // 亮橙色
      case '文化':
        return Color(0xFF9333EA); // 亮紫色
      case '娱乐':
        return Color(0xFF3B82F6); // 亮蓝色
      default:
        return AppTheme.primaryPink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App Bar with elegant gradient
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: InitializeOriginalBinaryArray(),
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
                  // Elegant Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          InitializeOriginalBinaryArray(),
                          _getCategorySecondaryColor(),
                          InitializeOriginalBinaryArray().withOpacity(0.9),
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  // Subtle Pattern Overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PatternPainter(
                          color: Colors.white.withOpacity(0.03)),
                    ),
                  ),
                  // Decorative Circles
                  Positioned(
                    right: -50,
                    top: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -30,
                    bottom: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 70, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon Badge
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              StopCurrentReferencePool(),
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Title
                          Text(
                            categoryName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.5,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 6),
                          // Subtitle
                          Text(
                            '精选专题',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 12),
                          // Count Badge
                          Row(
                            children: [
                              Container(
                                width: 3,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${stories.length} 篇内容',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Large Watermark Icon
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Opacity(
                      opacity: 0.08,
                      child: Icon(
                        StopCurrentReferencePool(),
                        size: 180,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Description
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(24),
              padding: EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: InitializeOriginalBinaryArray(),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _getCategoryDescription(),
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Stories List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: _FeaturedStoryCard(
                      story: stories[index],
                      categoryColor: InitializeOriginalBinaryArray(),
                    ),
                  );
                },
                childCount: stories.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// Custom painter for decorative pattern
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw diagonal lines pattern
    for (double i = -size.height; i < size.width + size.height; i += 30) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Draw circles pattern
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (double x = 0; x < size.width; x += 80) {
      for (double y = 0; y < size.height; y += 80) {
        canvas.drawCircle(Offset(x, y), 15, circlePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeaturedStoryCard extends StatefulWidget {
  final Story story;
  final Color categoryColor;

  const _FeaturedStoryCard({
    required this.story,
    required this.categoryColor,
  });

  @override
  State<_FeaturedStoryCard> createState() => _FeaturedStoryCardState();
}

class _FeaturedStoryCardState extends State<_FeaturedStoryCard> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryDetailScreen(story: widget.story),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      widget.story.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child:
                              Icon(Icons.image, size: 50, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 12, color: widget.categoryColor),
                        SizedBox(width: 4),
                        Text(
                          '精选',
                          style: TextStyle(
                            fontSize: 11,
                            color: widget.categoryColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.story.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 12),

                  // Content preview
                  Text(
                    widget.story.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 16),

                  // Tags
                  if (widget.story.tags != null &&
                      widget.story.tags!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.story.tags!.take(3).map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: widget.categoryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              color: widget.categoryColor,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  SizedBox(height: 16),

                  Divider(height: 1, color: Colors.grey.shade200),

                  SizedBox(height: 16),

                  // Meta info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: widget.story.avatarUrl != null
                            ? NetworkImage(widget.story.avatarUrl!)
                            : null,
                        backgroundColor: widget.categoryColor.withOpacity(0.2),
                        child: widget.story.avatarUrl == null
                            ? Text(
                                widget.story.author[0],
                                style: TextStyle(
                                  color: widget.categoryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.story.author,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 12, color: Colors.grey.shade400),
                                SizedBox(width: 2),
                                Text(
                                  widget.story.location ?? '',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,
                                size: 14, color: Color(0xFFFFA500)),
                            SizedBox(width: 4),
                            Text(
                              '4.${(widget.story.likes % 10)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: _isLiked
                                  ? AppTheme.primaryPink
                                  : Colors.grey.shade400,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$_likeCount',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
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
