// 추가 import
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraPage extends StatefulWidget {
  final void Function(int)? onNavigateToTab;

  const CameraPage({super.key, this.onNavigateToTab});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _photoTaken = false;
  String? _lastPhotoPath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);

    _controller = CameraController(backCamera, ResolutionPreset.high);
    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> sendImageForPrediction(File imageFile) async {
    final uri = Uri.parse('https://pestify-khuthon.onrender.com/predict');

    final request = http.MultipartRequest('POST', uri)
      ..fields['userId'] = 'test123'
      ..fields['lat'] = '37.56'
      ..fields['lng'] = '127.0'
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);
      print('📬 AI 예측 결과: $data');

      await Navigator.pushNamed(context, '/result', arguments: {
        'imagePath': imageFile.path,
        'result': data,
      });
      if (mounted) {
    setState(() {
      _photoTaken = false;
      _lastPhotoPath = null;
    });
  }
    } else {
      print('❌ 서버 에러: ${response.statusCode}');
    }
  }

  Future<void> _takePhoto() async {
    if (!(_controller?.value.isInitialized ?? false)) return;
    try {
      final image = await _controller!.takePicture();
      setState(() {
        _photoTaken = true;
        _lastPhotoPath = image.path;
      });

      await sendImageForPrediction(File(image.path));

      // ❗ 분석 끝나면 복귀는 result 페이지에서 함
    } catch (e) {
      print('카메라 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ✅ 카메라 or 정지 이미지 구간
            FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && _controller != null) {
                  if (_photoTaken && _lastPhotoPath != null) {
                    return Image.file(File(_lastPhotoPath!), fit: BoxFit.cover, width: double.infinity);
                  } else {
                    return CameraPreview(_controller!);
                  }
                } else {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                }
              },
            ),

            // 🔙 뒤로가기 버튼
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(LucideIcons.chevronLeft, color: Colors.white, size: 24),
                onPressed: () {
                  if (widget.onNavigateToTab != null) {
                    widget.onNavigateToTab!(0);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),

            // 🧠 분석중 표시
            if (_photoTaken)
              const Center(
                child: Text(
                  '분석중 ...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // 📸 촬영 버튼
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.camera,
                      color: Color(0xFF357A38),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),

            // 💡 팁 카드
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("📌 촬영 팁", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    Text("• 병충해가 있는 부분을 향해 카메라를 조준하세요"),
                    Text("• 이미지가 선명하고 밝게 보이도록 하세요"),
                    Text("• 흔들리지 않게 촬영하세요"),
                    Text("• 충분히 가까이에서 찍으세요"),
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
