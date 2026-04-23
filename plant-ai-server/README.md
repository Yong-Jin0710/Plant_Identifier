# Plant AI Server

Flutter 앱에서 업로드한 식물 사진을 PlantNet API로 전달하고 결과를 반환하는 Node.js 서버입니다.

## 1) 설치

```bash
npm install
```

## 2) 환경변수 설정

`.env.example`를 복사해서 `.env` 파일을 만든 뒤 값을 입력하세요.

```bash
PORT=3000
PLANTNET_API_KEY=발급받은_키
```

## 3) 실행

```bash
npm start
```

## 4) 엔드포인트

- `GET /health`
- `POST /analyze-plant` (multipart/form-data, 필드명: `image`)
