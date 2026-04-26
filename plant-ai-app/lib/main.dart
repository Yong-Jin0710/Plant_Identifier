import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'screens/home_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const PlantAiApp());
}

class PlantAiApp extends StatelessWidget {
  const PlantAiApp({super.key});

  // 배포/실행 환경마다 서버 주소를 바꿀 수 있도록 --dart-define 값을 우선 사용합니다.
  static const String _apiBaseUrlFromDefine = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  @override
  Widget build(BuildContext context) {
    // Android 실기기에서는 10.0.2.2가 동작하지 않으므로 실행 시 API_BASE_URL 지정이 필요합니다.
    final baseUrl = _apiBaseUrlFromDefine.isNotEmpty
        ? _apiBaseUrlFromDefine
        : (defaultTargetPlatform == TargetPlatform.android
              ? 'http://10.0.2.2:3000'
              : 'http://localhost:3000');
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
