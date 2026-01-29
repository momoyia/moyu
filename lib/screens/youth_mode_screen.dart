import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class YouthModeScreen extends StatefulWidget {
  const YouthModeScreen({super.key});

  @override
  State<YouthModeScreen> createState() => _YouthModeScreenState();
}

class _YouthModeScreenState extends State<YouthModeScreen> {
  bool _youthModeEnabled = false;
  bool _hasPassword = false;
  bool _purchaseRestricted = false;
  String? _password;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _youthModeEnabled = prefs.getBool('youth_mode') ?? false;
      _hasPassword = prefs.getString('youth_mode_password') != null;
      _password = prefs.getString('youth_mode_password');
      _purchaseRestricted =
          prefs.getBool('youth_mode_restrict_purchase') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('youth_mode', _youthModeEnabled);
    await prefs.setBool('youth_mode_restrict_purchase', _purchaseRestricted);
  }

  Future<void> _setPassword() async {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('设置密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '设置密码后，关闭青少年模式或进行购买时需要输入密码',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '输入6位数字密码',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '确认密码',
                border: OutlineInputBorder(),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text;
              final confirm = confirmController.text;

              if (password.isEmpty || password.length != 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('请输入6位数字密码')),
                );
                return;
              }

              if (password != confirm) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('两次密码不一致')),
                );
                return;
              }

              Navigator.pop(context, true);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('youth_mode_password', passwordController.text);
      setState(() {
        _hasPassword = true;
        _password = passwordController.text;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('密码设置成功')),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    // 先验证旧密码
    final verified = await _verifyPassword('请输入当前密码');
    if (!verified) return;

    // 设置新密码
    await _setPassword();
  }

  Future<void> _removePassword() async {
    // 先验证密码
    final verified = await _verifyPassword('请输入密码以移除');
    if (!verified) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('移除密码'),
        content: const Text('确定要移除密码保护吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('移除'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('youth_mode_password');
      setState(() {
        _hasPassword = false;
        _password = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('密码已移除')),
        );
      }
    }
  }

  Future<bool> _verifyPassword(String title) async {
    final TextEditingController controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          obscureText: true,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: '密码',
            border: OutlineInputBorder(),
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text == _password) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('密码错误')),
                );
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _toggleYouthMode(bool value) async {
    if (!value && _hasPassword) {
      // 关闭青少年模式需要验证密码
      final verified = await _verifyPassword('请输入密码以关闭青少年模式');
      if (!verified) return;
    }

    setState(() {
      _youthModeEnabled = value;
    });
    await _saveSettings();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(value ? '青少年模式已开启' : '青少年模式已关闭'),
        ),
      );
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
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '青少年模式',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 说明卡片
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '开启青少年模式后，将自动过滤不适宜内容，并可设置密码保护购买功能',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 青少年模式开关
          _buildSwitchTile(
            icon: Icons.child_care,
            title: '启用青少年模式',
            subtitle: '过滤不适宜内容',
            value: _youthModeEnabled,
            onChanged: _toggleYouthMode,
          ),

          if (_youthModeEnabled) ...[
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                '密码保护',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            // 密码设置
            if (!_hasPassword)
              _buildActionTile(
                icon: Icons.lock_outline,
                title: '设置密码',
                subtitle: '设置密码保护购买功能',
                onTap: _setPassword,
              )
            else ...[
              _buildInfoTile(
                icon: Icons.lock,
                title: '密码已设置',
                subtitle: '关闭青少年模式或购买时需要输入密码',
              ),
              _buildActionTile(
                icon: Icons.edit,
                title: '修改密码',
                subtitle: '更改当前密码',
                onTap: _changePassword,
              ),
              _buildActionTile(
                icon: Icons.lock_open,
                title: '移除密码',
                subtitle: '移除密码保护',
                onTap: _removePassword,
                textColor: Colors.red,
              ),
            ],

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                '购买限制',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            // 购买限制开关
            _buildSwitchTile(
              icon: Icons.shopping_cart_outlined,
              title: '限制购买',
              subtitle: _hasPassword ? '购买时需要输入密码' : '需要先设置密码',
              value: _purchaseRestricted,
              onChanged: _hasPassword
                  ? (value) {
                      setState(() {
                        _purchaseRestricted = value;
                      });
                      _saveSettings();
                    }
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            color: const Color(0xFFF9457A).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFF9457A), size: 20),
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
          activeColor: const Color(0xFFF9457A),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            color: (textColor ?? const Color(0xFFF9457A)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: textColor ?? const Color(0xFFF9457A),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.grey.shade800,
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

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.green.shade700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
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
