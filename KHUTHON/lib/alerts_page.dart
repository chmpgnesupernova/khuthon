import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math';
import 'alert_detail_page.dart'; // ✅ 상세 페이지 import

const userLat = 37.5;
const userLng = 127.0;

double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  const earthRadius = 6371;
  final dLat = _radians(lat2 - lat1);
  final dLng = _radians(lng2 - lng1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_radians(lat1)) * cos(_radians(lat2)) * sin(dLng / 2) * sin(dLng / 2);
  final c = 2 * asin(sqrt(a));
  return earthRadius * c;
}

double _radians(double deg) => deg * pi / 180;

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  final List<Map<String, dynamic>> allAlerts = const [
    {
      "area": "서울 주변 1번 농가",
      "lat": 37.599154,
      "lng": 127.237613,
      "title": "노균병 확산",
      "icon": LucideIcons.shieldAlert,
      "description": "노지 채소 작물에 노균병 발생",
      "tip": "주기적 약제 살포와 통풍 확보가 필요합니다.",
      "color": Colors.teal,
      "date": "2025.05.09",
      "imagePath": "assets/images/nogyun.jpg",
      "detail": "노균병은 잎에 물방울이 맺히는 환경에서 잘 발생하며, 병든 잎은 일찍 제거하고 소각하거나 땅에 묻어야 합니다. 또한 포장 환경을 청결하게 유지하고, 환기를 잘 시켜 습도를 낮추는 것이 중요합니다. 필요한 경우 등록된 약제를 살포하여 방제하는 것이 좋습니다. "
    },
    {
      "area": "서울 주변 2번 농가",
      "lat": 37.722073,
      "lng": 127.068574,
      "title": "총채벌레 감지",
      "icon": LucideIcons.scanFace,
      "description": "총채벌레 발생 초기 징후 확인됨",
      "tip": "끈끈이 트랩 설치 권장",
      "color": Colors.purple,
      "date": "2025.05.08",
      "imagePath": "assets/images/chongchae.jpg",
      "detail": "dkdkk"
    },
    {
      "area": "사용자의 농가",
      "lat": 37.5,
      "lng": 127.0,
      "title": "잎마름병 발생",
      "icon": LucideIcons.alertTriangle,
      "description": "고온다습한 날씨로 인해 주의 필요",
      "tip": "통풍 확보 + 병든 잎 제거",
      "color": Colors.orange,
      "date": "2025.05.10",
      "imagePath": "assets/images/ipmarem.jpg",
      "detail": "잎마름병 대처법은 병 발생 초기부터 주기적으로 약제를 살포하고, 종자 소독, 병든 식물 제거 등을 통해 예방하는 것이 중요합니다. 잎마름병은 특히 고온 다습한 날씨에 발생하기 쉬우므로, 환기 및 햇빛을 쬘 수 있도록 환경을 조성하는 것도 필요합니다. "
    },
    {
      "area": "서울 주변 4번 농가",
      "lat": 37.484824,
      "lng": 127.059684,
      "title": "진딧물 발견",
      "icon": LucideIcons.bug,
      "description": "채소류에 진딧물 다수 발견",
      "tip": "비눗물 또는 유기농 방제제 사용",
      "color": Colors.redAccent,
      "date": "2025.05.06",
      "imagePath": "assets/images/jinditmul.webp",
      "detail": "진딧물은 물이나 알코올로 닦아내거나, 샤워기 물줄기로 제거하는 것이 좋습니다. 또한, 퐁퐁을 희석한 물을 뿌려 진딧물의 단백질을 용해시켜 없애는 방법도 있습니다. 천연 살충제인 님 오일이나 우유를 이용해 진딧물을 퇴치할 수도 있습니다. "
    },
    {
      "area": "서울 주변 5번 농가",
      "lat": 37.765999,
      "lng": 127.085079,
      "title": "노균병 확산",
      "icon": LucideIcons.shieldAlert,
      "description": "노지 채소 작물에 노균병 발생",
      "tip": "주기적 약제 살포와 통풍 확보가 필요합니다.",
      "color": Colors.teal,
      "date": "2025.05.05",
      "imagePath": "assets/images/nogyun.jpg",
      "detail": "노균병은 잎에 물방울이 맺히는 환경에서 잘 발생하며, 병든 잎은 일찍 제거하고 소각하거나 땅에 묻어야 합니다. 또한 포장 환경을 청결하게 유지하고, 환기를 잘 시켜 습도를 낮추는 것이 중요합니다. 필요한 경우 등록된 약제를 살포하여 방제하는 것이 좋습니다. "
    },
    {
      "area": "서울 주변 6번 농가",
      "lat": 37.43983,
      "lng": 127.224434,
      "title": "총채벌레 감지",
      "icon": LucideIcons.scanFace,
      "description": "총채벌레 발생 초기 징후 확인됨",
      "tip": "끈끈이 트랩 설치 권장",
      "color": Colors.purple,
      "date": "2025.05.04",
      "imagePath": "assets/images/chongchae.jpg",
      "detail": "dkdkk"
    },
    {
      "area": "서울 주변 7번 농가",
      "lat": 37.398702,
      "lng": 127.035296,
      "title": "노균병 확산",
      "icon": LucideIcons.shieldAlert,
      "description": "노지 채소 작물에 노균병 발생",
      "tip": "주기적 약제 살포와 통풍 확보가 필요합니다.",
      "color": Colors.teal,
      "date": "2025.05.03",
      "imagePath": "assets/images/nogyun.jpg",
      "detail": "노균병은 잎에 물방울이 맺히는 환경에서 잘 발생하며, 병든 잎은 일찍 제거하고 소각하거나 땅에 묻어야 합니다. 또한 포장 환경을 청결하게 유지하고, 환기를 잘 시켜 습도를 낮추는 것이 중요합니다. 필요한 경우 등록된 약제를 살포하여 방제하는 것이 좋습니다. "
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = allAlerts
        .where((alert) =>
            alert["title"] != "병해충 없음" &&
            calculateDistance(userLat, userLng, alert["lat"], alert["lng"]) <= 30)
        .map((alert) {
          final distance = calculateDistance(userLat, userLng, alert["lat"], alert["lng"]);
          return {...alert, 'distance': distance};
        })
        .toList()
      ..sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

    final topAlerts = filteredAlerts.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("📍 내 주변 병해충 알림"),
        centerTitle: true,
      ),
      body: topAlerts.isEmpty
          ? const Center(child: Text("현재 주변에 알림이 없습니다."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: topAlerts.length,
              itemBuilder: (context, index) {
                final alert = topAlerts[index];
                final km = alert['distance'].toStringAsFixed(1);
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AlertDetailPage(alert: alert),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: alert["color"] as Color,
                      child: Icon(alert["icon"] as IconData, color: Colors.white),
                    ),
                    title: Text(alert["title"] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(alert["area"] as String),
                        Text(alert["date"] as String,
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Text("📏 현재 위치에서 약 ${km}km 떨어짐"),
                        const SizedBox(height: 4),
                        Text("💡 예방책: ${alert["tip"]}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
