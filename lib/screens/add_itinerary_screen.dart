import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';

class AddItineraryScreen extends StatefulWidget {
  const AddItineraryScreen({super.key});

  @override
  State<AddItineraryScreen> createState() => _AddItineraryScreenState();
}

class _AddItineraryScreenState extends State<AddItineraryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _durationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final StorageService _storageService = StorageService();

  Color _selectedColor = Color(0xFF3B82F6);
  final List<Color> _colors = [
    Color(0xFF3B82F6), // 蓝色
    AppTheme.accentPurple, // 紫色
    AppTheme.primaryPink, // 粉色
    Color(0xFF10B981), // 绿色
    Color(0xFFF59E0B), // 橙色
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _departureDateController.dispose();
    _durationController.dispose();
    _distanceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _departureDateController.text = '${picked.month}月${picked.day}日出发';
      });
    }
  }

  Future<void> _saveItinerary() async {
    if (_formKey.currentState!.validate()) {
      final itinerary = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text,
        'destination': _destinationController.text,
        'departureDate': _departureDateController.text,
        'duration': _durationController.text,
        'distance': _distanceController.text,
        'imageUrl': _imageUrlController.text.isEmpty
            ? 'assets/natures/nature1.jpg'
            : _imageUrlController.text,
        'color': _selectedColor.value,
      };

      await _storageService.addItinerary(itinerary);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('行程已保存'),
            backgroundColor: AppTheme.primaryPink,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '添加行程',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveItinerary,
            child: Text(
              '保存',
              style: TextStyle(
                color: AppTheme.primaryPink,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            // 标题
            Text(
              '行程标题',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '例如：云南大理古城之旅',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入行程标题';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // 目的地
            Text(
              '目的地',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(
                hintText: '例如：云南大理',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入目的地';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // 出发日期
            Text(
              '出发日期',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _departureDateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                hintText: '选择出发日期',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon:
                    Icon(Icons.calendar_today, color: AppTheme.primaryPink),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请选择出发日期';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // 行程时长
            Text(
              '行程时长',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(
                hintText: '例如：6天5晚',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入行程时长';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // 总距离
            Text(
              '总距离',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _distanceController,
              decoration: InputDecoration(
                hintText: '例如：2,340km',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入总距离';
                }
                return null;
              },
            ),

            SizedBox(height: 20),

            // 封面图片（可选）
            Text(
              '封面图片（可选）',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                hintText: '输入图片URL或留空使用默认图片',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),

            SizedBox(height: 20),

            // 主题颜色
            Text(
              '主题颜色',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: _colors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.grey.shade800
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
