const express = require("express");
const cors = require("cors");
const multer = require("multer");
const dotenv = require("dotenv");

dotenv.config();

const app = express();
const upload = multer({ storage: multer.memoryStorage() });

app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const PLANTNET_API_KEY = process.env.PLANTNET_API_KEY;

app.get("/health", (_req, res) => {
  res.json({ ok: true, message: "서버가 정상 동작 중입니다." });
});

app.post("/analyze-plant", upload.single("image"), async (req, res) => {
  try {
    if (!PLANTNET_API_KEY) {
      return res.status(500).json({
        ok: false,
        message: "PLANTNET_API_KEY가 설정되지 않았습니다.",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        ok: false,
        message: "image 파일이 필요합니다.",
      });
    }

    const formData = new FormData();
    const imageBlob = new Blob([req.file.buffer], {
      type: req.file.mimetype || "image/jpeg",
    });

    formData.append("images", imageBlob, req.file.originalname || "plant.jpg");
    formData.append("organs", "leaf");

    const url = `https://my-api.plantnet.org/v2/identify/all?api-key=${encodeURIComponent(
      PLANTNET_API_KEY
    )}`;

    const apiResponse = await fetch(url, {
      method: "POST",
      body: formData,
    });

    if (!apiResponse.ok) {
      const errorBody = await apiResponse.text();
      return res.status(502).json({
        ok: false,
        message: "PlantNet API 호출에 실패했습니다.",
        detail: errorBody,
      });
    }

    const result = await apiResponse.json();
    const topResult = result?.results?.[0];

    return res.json({
      ok: true,
      rawScore: topResult?.score ?? null,
      plant: {
        scientificName: topResult?.species?.scientificNameWithoutAuthor ?? null,
        commonNames: topResult?.species?.commonNames ?? [],
        family: topResult?.species?.family?.scientificNameWithoutAuthor ?? null,
        genus: topResult?.species?.genus?.scientificNameWithoutAuthor ?? null,
      },
      alternatives: (result?.results || []).slice(0, 3).map((item) => ({
        scientificName: item?.species?.scientificNameWithoutAuthor ?? null,
        score: item?.score ?? null,
      })),
    });
  } catch (error) {
    return res.status(500).json({
      ok: false,
      message: "분석 중 서버 오류가 발생했습니다.",
      detail: error instanceof Error ? error.message : "알 수 없는 오류",
    });
  }
});

app.listen(PORT, () => {
  // 서버 시작 여부를 쉽게 확인하기 위한 로그입니다.
  console.log(`Plant AI 서버 실행: http://localhost:${PORT}`);
});
