import 'package:flutter/material.dart';
import 'main_dashboard.dart';
import 'camera_page.dart';
import 'alerts_page.dart';
import 'info_page.dart';
import 'components/bottom_navigation.dart'; // 너가 만든 BottomNavigation 컴포넌트 import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late final List<Widget> _pages = [
    MainDashboard(onNavigateToTab: _onItemTapped), // ✅ 콜백 전달
    CameraPage(onNavigateToTab: _onItemTapped),
    AlertsPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
