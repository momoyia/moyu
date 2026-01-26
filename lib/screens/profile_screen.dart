import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import 'itinerary_detail_screen.dart';
import 'add_itinerary_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();
  String _nickname = '漫游雨林的树懒';
  String _bio = '慢慢走，欣赏啊～生活不止眼前的苟且 🌿';
  String? _avatarPath;
  List<Map<String, dynamic>> _itineraries = [];
  int _favoriteCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadItineraries();
    _loadFavoriteCount();
  }

  Future<void> _loadUserData() async {
    final nickname = await _storageService.getNickname();
    final bio = await _storageService.getBio();
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('avatar_path');
    setState(() {
      _nickname = nickname;
      _bio = bio;
      _avatarPath = avatarPath;
    });
  }

  Future<void> _loadFavoriteCount() async {
    final likedStories = await _storageService.getLikedStories();
    setState(() {
      _favoriteCount = likedStories.length;
    });
  }

  Future<void> _pickAvatar() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('avatar_path', image.path);
        setState(() {
          _avatarPath = image.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('头像已更新')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败')),
        );
      }
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppTheme.primaryPink.withOpacity(0.2),
      child: Icon(
        Icons.pets,
        size: 40,
        color: AppTheme.primaryPink,
      ),
    );
  }

  Future<void> _loadItineraries() async {
    setState(() {
      _isLoading = true;
    });
    final itineraries = await _storageService.getItineraries();
    setState(() {
      _itineraries = itineraries;
      _isLoading = false;
    });
  }

  Future<void> _addItinerary() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItineraryScreen(),
      ),
    );

    if (result == true) {
      _loadItineraries();
    }
  }

  Future<void> _deleteItinerary(String id) async {
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
            child: Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _storageService.deleteItinerary(id);
      _loadItineraries();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('行程已删除')),
        );
      }
    }
  }

  void _showEditDialog() {
    final nicknameController = TextEditingController(text: _nickname);
    final bioController = TextEditingController(text: _bio);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: AppTheme.primaryPink,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              '编辑资料',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(
                labelText: '昵称',
                hintText: '请输入昵称',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primaryPink,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: AppTheme.primaryPink,
                ),
              ),
              maxLength: 20,
            ),
            SizedBox(height: 16),
            TextField(
              controller: bioController,
              decoration: InputDecoration(
                labelText: '个人简介',
                hintText: '介绍一下自己吧',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.primaryPink,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.description_outlined,
                  color: AppTheme.primaryPink,
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 100,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final nickname = nicknameController.text.trim();
                      final bio = bioController.text.trim();

                      if (nickname.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('昵称不能为空')),
                        );
                        return;
                      }

                      await _storageService.saveNickname(nickname);
                      await _storageService.saveBio(bio);
                      await _loadUserData();

                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('保存成功'),
                            backgroundColor: AppTheme.primaryPink,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryPink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      '保存',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),

              // Header with Avatar and Settings
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with Camera Icon
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _showEditDialog,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.primaryPink.withOpacity(0.3),
                              width: 3,
                            ),
                            color: AppTheme.primaryPink.withOpacity(0.1),
                          ),
                          child: ClipOval(
                            child: _avatarPath != null
                                ? Image.file(
                                    File(_avatarPath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultAvatar();
                                    },
                                  )
                                : Image.network(
                                    'https://api.dicebear.com/7.x/bottts/png?seed=sloth&backgroundColor=ffc0cb&scale=80',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildDefaultAvatar();
                                    },
                                  ),
                          ),
                        ),
                      ),
                      // Camera Icon
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPink,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Settings Icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Nickname and Bio (left-aligned with avatar)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _nickname,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _showEditDialog,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: AppTheme.primaryPink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    _bio,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      icon: Icons.location_on_outlined,
                      value: '12',
                      label: '旅行足迹',
                      color: AppTheme.primaryPink,
                      onTap: null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.navigation_outlined,
                      value: '3,420',
                      label: '总旅程',
                      color: Color(0xFF3B82F6),
                      onTap: null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatItem(
                      icon: Icons.favorite_border,
                      value: '$_favoriteCount',
                      label: '收藏',
                      color: Color(0xFFF97316),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesScreen(),
                          ),
                        );
                        // 返回后刷新收藏数量
                        _loadFavoriteCount();
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // My Itinerary Section
              Text(
                '我的行程',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              SizedBox(height: 16),

              // Itinerary Cards
              _isLoading
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    )
                  : _itineraries.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.luggage_outlined,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 24),
                              Text(
                                '还没有行程',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                '点击右下角按钮添加你的第一个行程',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: _itineraries.map((itinerary) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: _ItineraryCard(
                                id: itinerary['id'],
                                title: itinerary['title'],
                                destination: itinerary['destination'],
                                departureDate: itinerary['departureDate'],
                                duration: itinerary['duration'],
                                distance: itinerary['distance'],
                                imageUrl: itinerary['imageUrl'],
                                color: Color(itinerary['color']),
                                onDelete: () =>
                                    _deleteItinerary(itinerary['id']),
                                onRefresh: _loadItineraries,
                              ),
                            );
                          }).toList(),
                        ),

              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItinerary,
        backgroundColor: AppTheme.primaryPink,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ItineraryCard extends StatelessWidget {
  final String id;
  final String title;
  final String destination;
  final String departureDate;
  final String duration;
  final String distance;
  final String imageUrl;
  final Color color;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const _ItineraryCard({
    required this.id,
    required this.title,
    required this.destination,
    required this.departureDate,
    required this.duration,
    required this.distance,
    required this.imageUrl,
    required this.color,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItineraryDetailScreen(
              id: id,
              title: title,
              destination: destination,
              departureDate: departureDate,
              duration: duration,
              distance: distance,
              imageUrl: imageUrl,
              color: color,
            ),
          ),
        );

        // If itinerary was deleted, trigger refresh
        if (result == true) {
          onRefresh();
        }
      },
      onLongPress: () {
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
                  SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.delete_outline, color: Colors.red),
                    title: Text(
                      '删除行程',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.grey.shade600),
                    title: Text(
                      '取消',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
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
            // Image
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
              child: Container(
                width: 110,
                height: 140,
                child: Image.asset(
                  imageUrl,
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

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          destination,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),

                    // Details Row
                    Row(
                      children: [
                        // Departure Date
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: color,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  departureDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Duration and Distance
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 12,
                                  color: color,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    duration,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: color,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.navigation_outlined,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    distance,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
