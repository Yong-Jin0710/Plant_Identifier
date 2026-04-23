# Plant AI App (Flutter)

식물 사진을 촬영/선택한 뒤, 서버를 통해 AI 분석 결과를 받아오는 Flutter 예제 앱입니다.

## 1) 사전 준비

- Flutter SDK 설치
- Android Studio 또는 Xcode 설정
- 백엔드 서버 실행 중이어야 함

## 2) 실행 방법

1. `plant-ai-server` 먼저 실행
2. 이 폴더에서 아래 명령 실행

```bash
flutter pub get
flutter run
```

## 3) API 주소 변경

`lib/main.dart`의 `baseUrl`을 실행 환경에 맞게 변경하세요.

- Android Emulator: `http://10.0.2.2:3000`
- iOS Simulator: `http://localhost:3000`
- 실제 기기: `http://내컴퓨터로컬IP:3000`
