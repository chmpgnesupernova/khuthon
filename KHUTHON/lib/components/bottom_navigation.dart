import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xFF357A38), // farm-green-dark
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.camera),
          label: '스캔',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.bell),
          label: '알림',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.info),
          label: '정보',
        ),
      ],
    );
  }
}