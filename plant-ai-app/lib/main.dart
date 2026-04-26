import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const PlantAiApp());
}

class PlantAiApp extends StatelessWidget {
  const PlantAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 안드로이드 에뮬레이터에서는 localhost 대신 10.0.2.2를 사용합니다.
    final baseUrl = defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:3000'
        : 'http://localhost:3000';
    final apiService = ApiService(baseUrl: baseUrl);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '식물 AI 분석기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomeScreen(apiService: apiService),
    );
  }
}
