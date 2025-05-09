import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MainDashboard extends StatelessWidget {
  final void Function(int)? onNavigateToTab;

  const MainDashboard({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // ✅ SafeArea 추가로 상태바와 겹침 방지
        child: Column(
          children: [
            // Hero 영역
            Container(
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB2DFDB), Color(0xFF357A38)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.asset('assets/leaf.png', fit: BoxFit.cover),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Pestify',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'AI 기반 작물 병해충 감지',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 작물 스캔하기 버튼
                    Card(
                      elevation: 4,
                      color: const Color(0xFFE0F2F1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        onTap: () => onNavigateToTab?.call(1),
                        leading: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 53, 122, 56),
                          child: const Icon(LucideIcons.camera, color: Colors.white),
                        ),
                        title: const Text(
                          '작물 스캔하기',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      '기능',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // 기능 카드 2개
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onNavigateToTab?.call(2),
                            child: Card(
                              elevation: 2,
                              color: const Color(0xFFFFF3E0),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: const [
                                    Icon(LucideIcons.alertTriangle, color: Colors.orange),
                                    SizedBox(height: 8),
                                    Text('알림 보기'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onNavigateToTab?.call(3),
                            child: Card(
                              elevation: 2,
                              color: const Color(0xFFE3F2FD),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: const [
                                    Icon(LucideIcons.info, color: Colors.blue),
                                    SizedBox(height: 8),
                                    Text('질병 정보'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // 하단 문구
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(LucideIcons.leaf, size: 16, color: Colors.green),
                          SizedBox(width: 6),
                          Text(
                            '농부들의 작물 보호를 돕습니다',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
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
