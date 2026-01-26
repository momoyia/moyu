import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/mock_data_service.dart';
import '../services/storage_service.dart';
import '../models/story.dart';
import 'travel_story_detail_screen.dart';

class RoamingScreen extends StatefulWidget {
  const RoamingScreen({super.key});

  @override
  State<RoamingScreen> createState() => _RoamingScreenState();
}

class _RoamingScreenState extends State<RoamingScreen> {
  final StorageService _storageService = StorageService();
  late List<Story> _allStories;
  late List<Story> _filteredStories;
  int _selectedCategoryIndex = 0;
  final List<String> _categories = ['美食', '住宿', '打卡'];

  @override
  void initState() {
    super.initState();
    _allStories = MockDataService.getMockStories();
    _filterStories();
  }

  Future<void> _filterStories() async {
    final selectedCategory = _categories[_selectedCategoryIndex];

    // 获取被拉黑的用户和被屏蔽的内容
    final blockedUsers = await _storageService.getBlockedAuthors();
    final hiddenContent = await _storageService.getHiddenStories();

    setState(() {
      _filteredStories = _allStories
          .where((story) => story.category == selectedCategory)
          .where((story) => !blockedUsers.contains(story.author)) // 过滤被拉黑的用户
          .where((story) => !hiddenContent.contains(story.id)) // 过滤被屏蔽的内容
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '探索',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  Text(
                    '.',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryPink,
                    ),
                  ),
                ],
              ),
            ),

            // Category Navigation
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: _categories.asMap().entries.map((entry) {
                  int index = entry.key;
                  String category = entry.value;
                  bool isSelected = index == _selectedCategoryIndex;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategoryIndex = index;
                          _filterStories();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryPink
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16),

            // Waterfall Grid
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final story = _filteredStories[index];
                          return _WaterfallCard(
                            story: story,
                            onRefresh: _filterStories,
                          );
                        },
                        childCount: _filteredStories.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaterfallCard extends StatefulWidget {
  final Story story;
  final VoidCallback onRefresh;

  const _WaterfallCard({
    required this.story,
    required this.onRefresh,
  });

  @override
  State<_WaterfallCard> createState() => _WaterfallCardState();
}

class _WaterfallCardState extends State<_WaterfallCard> {
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
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TravelStoryDetailScreen(story: widget.story),
          ),
        );

        // 如果返回true，说明用户拉黑或屏蔽了内容，需要刷新列表
        if (result == true) {
          widget.onRefresh();
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
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  width: double.infinity,
                  child: Image.asset(
                    widget.story.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: Icon(Icons.image, color: Colors.grey, size: 40),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      widget.story.title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // User Info
                    Row(
                      children: [
                        ClipOval(
                          child: widget.story.avatarUrl != null
                              ? Image.network(
                                  widget.story.avatarUrl!,
                                  width: 16,
                                  height: 16,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryPink
                                            .withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          widget.story.author[0],
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryPink,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.primaryPink.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.story.author[0],
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryPink,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.story.author,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggleLike,
                          child: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 12,
                            color: _isLiked
                                ? AppTheme.primaryPink
                                : Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(width: 2),
                        Text(
                          '$_likeCount',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
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
