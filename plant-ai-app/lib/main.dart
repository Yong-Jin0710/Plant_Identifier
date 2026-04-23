import 'package:flutter/material.dart';

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
    const apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '식물 AI 분석기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(apiService: apiService),
    );
  }
}
