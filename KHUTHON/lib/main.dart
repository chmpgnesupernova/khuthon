import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 각 페이지 import (예시)
import 'home_page.dart';
import 'camera_page.dart';
import 'report_page.dart';
import 'alerts_page.dart';
import 'info_page.dart';
import 'result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ 상태바 투명하게 만들고, 아이콘은 어둡게 (흰 배경용)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ 앱 시작화면
      home: HomePage(),

      // ✅ 일반 라우트 등록
      routes: {
        '/camera': (context) => CameraPage(),
        '/report': (context) => ReportPage(),
        '/alerts': (context) => AlertsPage(),
        '/info': (context) => InfoPage(),
      },

      // ✅ arguments가 필요한 페이지는 여기서 처리 (ex. ResultPage)
      onGenerateRoute: (settings) {
  if (settings.name == '/result') {
    final args = settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (context) => ResultPage(
        imagePath: args['imagePath'],
        result: args['result'],
      ),
    );
  }
  return null;
},
    );
  }
}