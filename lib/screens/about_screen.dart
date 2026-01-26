import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          '关于我们',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: 20),

            // App Icon
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/moyu logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 24),

            // Product Name
            Text(
              '陌遇',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            SizedBox(height: 8),

            // Product Slogan
            Text(
              '发现世界，遇见美好',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.primaryPink,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),

            SizedBox(height: 32),

            // Product Introduction
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '产品介绍',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '陌遇是一款专为旅行爱好者打造的智能旅行社交应用。我们致力于为用户提供个性化的旅行体验，让每一次出行都充满惊喜和收获。',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '在这里，你可以发现精彩的旅行故事，规划完美的行程，与志同道合的旅友交流，还能获得AI智能助手的贴心建议。让旅行不再孤单，让每一次探索都成为美好的回忆。',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Core Features
            Text(
              '核心功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),

            SizedBox(height: 16),

            _FeatureCard(
              icon: Icons.explore,
              title: '智能探索',
              description: '基于个人喜好推荐精彩旅行内容，发现更多可能性',
              color: Color(0xFF3B82F6),
            ),

            SizedBox(height: 12),

            _FeatureCard(
              icon: Icons.calendar_today,
              title: '行程管理',
              description: '轻松创建和管理旅行计划，让每次出行都井井有条',
              color: AppTheme.primaryPink,
            ),

            SizedBox(height: 12),

            _FeatureCard(
              icon: Icons.smart_toy,
              title: 'AI助手',
              description: '智能旅行规划师，为你提供个性化的旅行建议和攻略',
              color: AppTheme.accentPurple,
            ),

            SizedBox(height: 12),

            _FeatureCard(
              icon: Icons.people,
              title: '社交分享',
              description: '分享旅行故事，与旅友互动，建立美好的旅行社区',
              color: Color(0xFF10B981),
            ),

            SizedBox(height: 32),

            // Version Info
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '版本信息',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // Footer
            Text(
              '© 2024 陌遇团队',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
            ),

            SizedBox(height: 8),

            Text(
              '让旅行更美好',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                fontStyle: FontStyle.italic,
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
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
  }
}
