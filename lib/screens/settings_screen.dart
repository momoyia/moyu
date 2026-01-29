import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'about_screen.dart';
import 'blocked_users_screen.dart';
import 'hidden_content_screen.dart';
import 'feedback_screen.dart';
import 'login_screen.dart';
import 'coin_store_screen.dart';
import 'youth_mode_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _locationServices = true;

  @override
  void initState() {
    super.initState();
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
          '设置',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // 账户与隐私
          _SectionHeader(title: '账户与隐私'),
          _SettingsTile(
            icon: Icons.account_balance_wallet_rounded,
            title: '金币商店',
            subtitle: '购买金币，畅享更多功能',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoinStoreScreen(),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.block,
            title: '拉黑管理',
            subtitle: '管理已拉黑的用户',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlockedUsersScreen(),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.visibility_off,
            title: '屏蔽内容',
            subtitle: '管理已屏蔽的内容',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HiddenContentScreen(),
                ),
              );
            },
          ),

          SizedBox(height: 24),

          // 通知设置
          _SectionHeader(title: '通知设置'),
          _SwitchTile(
            icon: Icons.notifications,
            title: '推送通知',
            subtitle: '接收新消息和活动通知',
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          _SwitchTile(
            icon: Icons.location_on,
            title: '位置服务',
            subtitle: '允许获取位置信息推荐内容',
            value: _locationServices,
            onChanged: (value) {
              setState(() {
                _locationServices = value;
              });
            },
          ),

          SizedBox(height: 24),

          // 安全模式
          _SectionHeader(title: '安全模式'),
          _SettingsTile(
            icon: Icons.child_care,
            title: '青少年模式',
            subtitle: '内容过滤和购买保护',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => YouthModeScreen(),
                ),
              );
            },
          ),

          SizedBox(height: 24),

          // 帮助与反馈
          _SectionHeader(title: '帮助与反馈'),
          _SettingsTile(
            icon: Icons.help_outline,
            title: '帮助中心',
            subtitle: '常见问题与使用指南',
            onTap: () {
              _showHelpDialog();
            },
          ),
          _SettingsTile(
            icon: Icons.feedback,
            title: '意见反馈',
            subtitle: '告诉我们您的建议',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackScreen(),
                ),
              );
            },
          ),
          _SettingsTile(
            icon: Icons.info_outline,
            title: '关于我们',
            subtitle: '了解陌遇',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutScreen(),
                ),
              );
            },
          ),

          SizedBox(height: 40),

          // 退出登录按钮
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  '退出登录',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('退出登录'),
        content: Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('退出'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('帮助中心'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('常见问题：', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• 如何添加行程？\n  点击我的页面右下角+按钮'),
            SizedBox(height: 4),
            Text('• 如何点赞游记？\n  点击游记卡片上的爱心图标'),
            SizedBox(height: 4),
            Text('• 如何拉黑用户？\n  在游记详情页点击右上角更多选项'),
            SizedBox(height: 4),
            Text('• 如何使用AI助手？\n  切换到AI页面开始对话'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('知道了'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryPink, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade300),
        onTap: onTap,
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryPink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primaryPink, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryPink,
        ),
      ),
    );
  }
}
