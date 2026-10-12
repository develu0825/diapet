# Diapet — 반려동물 장례·추모 통합 플랫폼

반려동물을 떠나보내는 순간부터 장례, 사후 행정, 추모까지 함께하는 모바일 앱.
검정·회색의 무거운 장례 클리셰 대신 **노을빛 주황**으로, 따뜻한 마무리를 돕습니다.

## 📁 프로젝트 구조

```
pet/
├── app/           Flutter 앱 (실제 제품)
│   ├── lib/         화면·위젯·테마·모델
│   ├── assets/      앱 번들 이미지·폰트(Pretendard)
│   └── test/        위젯 테스트
├── design/        디자인 시스템
│   ├── DESIGN.md    색상·타이포·컴포넌트 토큰(소스 오브 트루스)
│   └── preview.html 디자인 시스템 미리보기
├── prototype/     HTML 프로토타입 (Flutter 이전 원본)
│   ├── index.html
│   ├── home-candidates.html
│   └── emergency-candidates.html
├── marketing/     제품 소개·포스터 (Diapet 브랜드)
│   ├── product-sheet.html   제품 소개 A4
│   ├── features-sheet.html  기능 소개 A4
│   └── poster.html          동행 포스터
├── assets/
│   └── img/       화면 시안·반려동물 사진 등 레퍼런스 이미지
└── research/      (로컬 전용) 사업 기밀 리서치 — 버전관리 제외
```

## 🎨 디자인

- **색상**: 주황 `#F15A24`(히어로·CTA·강조에 절제), 웜 크림 `#FDFAF6`(넓은 면적), 웜 니어블랙 `#241A14`
- **서체**: Pretendard (한글 가독 최우선)
- **원칙**: 동행형 카피, 세일·재촉 금지, 상태는 색+아이콘+텍스트 중복 전달. 자세한 내용은 [`design/DESIGN.md`](design/DESIGN.md).

## 📱 앱 실행

```bash
cd app
flutter pub get
flutter run
```

## 주요 화면

온보딩 · 홈 대시보드 · 긴급 대응(코드 타임라인) · 견적 · 장례식장 비교/상세 ·
예약·결제·완료 · 추모 공간(폴라로이드·촛불·QR) · 사전 준비 · 마이페이지
