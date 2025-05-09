import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final diseases = [
  {
    "name": "노랑등멸구",
    "symptoms": "노랑등멸구에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "노랑등멸구 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.yellow,
  },
  {
    "name": "먹노린재",
    "symptoms": "먹노린재에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "먹노린재 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.black,
  },
  {
    "name": "벼멸구",
    "symptoms": "벼멸구에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "벼멸구 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.redAccent,
  },
  {
    "name": "벼줄기굴나방",
    "symptoms": "벼줄기굴나방에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "벼줄기굴나방 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.indigo,
  },
  {
    "name": "벼줄기굴파리",
    "symptoms": "벼줄기굴파리에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "벼줄기굴파리 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.deepPurple,
  },
  {
    "name": "잎말림나방",
    "symptoms": "잎말림나방에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "잎말림나방 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.brown,
  },
  {
    "name": "줄무늬잎벌레",
    "symptoms": "줄무늬잎벌레에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "줄무늬잎벌레 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.amber,
  },
  {
    "name": "혹명나방",
    "symptoms": "혹명나방에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "혹명나방 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.orange,
  },
  {
    "name": "혹파리",
    "symptoms": "혹파리에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "혹파리 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.teal,
  },
  {
    "name": "흰등멸구",
    "symptoms": "흰등멸구에 의해 잎이 손상되거나 조직이 괴사할 수 있습니다.",
    "prevention": "흰등멸구 예방을 위해 정기적인 예찰과 적절한 방제를 실시하세요.",
    "icon": LucideIcons.bug,
    "color": Colors.grey,
  },
];

    return Scaffold(
      appBar: AppBar(title: const Text("질병 정보")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: diseases.length,
        itemBuilder: (context, index) {
          final d = diseases[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: d["color"] as Color,
                child: Icon(d["icon"] as IconData, color: Colors.white),
              ),
              title: Text(
                d["name"] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text("증상: ${d["symptoms"]}"),
                  Text("예방법: ${d["prevention"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}