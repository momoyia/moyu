import 'package:flutter/material.dart';
import 'discovery_screen.dart';
import 'roaming_screen.dart';
import 'ai_screen.dart';
import 'profile_screen.dart';
import '../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoveryScreen(),
    RoamingScreen(),
    AIScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {
      'label': '首页',
      'icon': Icons.explore_outlined,
      'activeIcon': Icons.explore
    },
    {'label': '发现', 'icon': Icons.map_outlined, 'activeIcon': Icons.map},
    {
      'label': 'AI',
      'icon': Icons.smart_toy_outlined,
      'activeIcon': Icons.smart_toy
    },
    {'label': '我的', 'icon': Icons.person_outline, 'activeIcon': Icons.person},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_navItems.length, (index) {
            final item = _navItems[index];
            final isActive = _currentIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isActive ? item['activeIcon'] : item['icon'],
                      color: isActive
                          ? AppTheme.primaryPink
                          : Colors.grey.shade400,
                      size: 24,
                    ),
                    if (isActive) ...[
                      const SizedBox(height: 1),
                      Text(
                        item['label'],
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryPink,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
