import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class HiddenContentScreen extends StatefulWidget {
  const HiddenContentScreen({super.key});

  @override
  State<HiddenContentScreen> createState() => _HiddenContentScreenState();
}

class _HiddenContentScreenState extends State<HiddenContentScreen> {
  final StorageService _storageService = StorageService();
  List<String> _hiddenStories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHiddenContent();
  }

  Future<void> _loadHiddenContent() async {
    setState(() {
      _isLoading = true;
    });
    final hidden = await _storageService.getHiddenStories();
    setState(() {
      _hiddenStories = hidden;
      _isLoading = false;
    });
  }

  Future<void> _unhideContent(String storyId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('取消屏蔽'),
        content: Text('确定要取消屏蔽这个内容吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('确定'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // 从屏蔽列表中移除
      final hidden = await _storageService.getHiddenStories();
      hidden.remove(storyId);
      await _storageService.saveHiddenStories(hidden);
      _loadHiddenContent();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已取消屏蔽该内容'),
            backgroundColor: AppTheme.primaryPink,
          ),
        );
      }
    }
  }

  String _getContentTitle(String storyId) {
    // 根据storyId生成内容标题（简化处理）
    final titles = [
      '云南大理古城游记',
      '海南三亚度假攻略',
      '浙江乌镇慢生活',
      '四川成都美食之旅',
      '西藏拉萨朝圣之路',
      '新疆喀纳斯秋色',
      '内蒙古草原风光',
      '青海湖环湖骑行',
    ];
    final index = storyId.hashCode.abs() % titles.length;
    return titles[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '屏蔽内容',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryPink,
              ),
            )
          : _hiddenStories.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _hiddenStories.length,
                  itemBuilder: (context, index) {
                    final storyId = _hiddenStories[index];
                    return _buildContentCard(storyId);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.visibility_off,
            size: 80,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: 16),
          Text(
            '暂无屏蔽内容',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '屏蔽的内容会显示在这里',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(String storyId) {
    final title = _getContentTitle(storyId);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Content Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.article,
              color: Colors.grey.shade500,
              size: 24,
            ),
          ),
          SizedBox(width: 16),

          // Content Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '已屏蔽',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          // Unhide Button
          TextButton(
            onPressed: () => _unhideContent(storyId),
            style: TextButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade700,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '取消屏蔽',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
