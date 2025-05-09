import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'alert_detail_page.dart';

class ResultPage extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> result;
  final void Function(int)? onNavigateToTab; // ✅ 인덱스 이동용 콜백 추가

  const ResultPage({
    super.key,
    required this.imagePath,
    required this.result,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final label = result['result'] ?? '알 수 없음';
    final confidence = result['confidence'] != null
        ? (result['confidence'] * 100).toStringAsFixed(1)
        : '-';
    final tip = result['tips'] ?? '조치 방법을 불러올 수 없습니다.';

    if (label != "병해충 없음") {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🚨 병해충 신고가 완료되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
              onPressed: () {
                if (onNavigateToTab != null) {
                  onNavigateToTab!(1); // ✅ 카메라 탭 인덱스로 이동
                } else {
                  Navigator.pop(context); // fallback
                }
              },
            ),
            const SizedBox(width: 8),
            const Text('분석 결과'),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("📷 촬영한 사진", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(imagePath), height: 220),
              ),
              const SizedBox(height: 24),
              Text("🧠 AI 판단 결과", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text("병해충 종류: $label", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              Text("✅ 예방 및 조치 방법", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Text(
                tip,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (onNavigateToTab != null) {
                      onNavigateToTab!(1); // ✅ 카메라 탭으로 이동
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Text('🔄', style: TextStyle(fontSize: 20)),
                  label: const Text("다시 촬영하기"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              if (label == "잎마름병") ...[
  const SizedBox(height: 16),
  SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AlertDetailPage(alert: {
              "title": "잎마름병 발생",
              "area": "내 위치",
              "date": "2025.05.10",
              "description": "고온다습한 날씨로 인해 주의 필요",
              "detail": "잎마름병 대처법은 병 발생 초기부터 주기적으로 약제를 살포하고, 종자 소독, 병든 식물 제거 등을 통해 예방하는 것이 중요합니다. 잎마름병은 특히 고온 다습한 날씨에 발생하기 쉬우므로, 환기 및 햇빛을 쬘 수 있도록 환경을 조성하는 것도 필요합니다. ",
              "icon": LucideIcons.alertTriangle,
              "color": Colors.orange,
              "imagePath": imagePath,
            }),
          ),
        );
      },
      icon: const Icon(LucideIcons.bookOpen),
      label: const Text("자세히 보기"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade100,
        foregroundColor: Colors.orange.shade900,
        padding: const EdgeInsets.symmetric(vertical: 14),
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
  ),
],
            ],
          ),
        ),
      ),
    );
  }
}
