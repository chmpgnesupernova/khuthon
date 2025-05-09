import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AlertDetailPage extends StatelessWidget {
  final Map<String, dynamic> alert;

  const AlertDetailPage({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(alert['title'] ?? '상세 정보'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📍 위치: ${alert['area'] ?? '알 수 없음'}"),
            const SizedBox(height: 4),
            Text("📅 날짜: ${alert['date'] ?? '미지정'}"),
            const SizedBox(height: 12),
            Text("💬 설명:\n${alert['description'] ?? '없음'}"),
            const SizedBox(height: 16),
            Text("📋 상세 정보:\n${alert['detail'] ?? '정보 없음'}"),
            const SizedBox(height: 16),
            if (alert['imagePath'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: alert['imagePath'].toString().startsWith("assets/")
                    ? Image.asset(alert['imagePath'])
                    : Image.file(File(alert['imagePath'])),
              ),
          ],
        ),
      ),
    );
  }
}
