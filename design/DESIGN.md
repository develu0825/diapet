---
version: 1.0
name: LastCare
description: >
  반려동물 장례·추모 통합 플랫폼의 디자인 시스템. 선명한 주황을 브랜드 히어로 컬러로,
  따뜻한 크림 뉴트럴을 바탕으로 쓰는 "모던 플랫" 방향. 슬픔의 순간에도 위로·신뢰·명료함을
  전한다. AI 코딩 에이전트가 이 문서를 읽고 일관된 UI를 생성하도록 작성됨.

colors:
  # Brand & Accent
  orange-500: "#F15A24"   # 브랜드 히어로 · 주 버튼 · 강조
  orange-600: "#D84816"   # 버튼 hover/press · 주황 위 진한 텍스트
  orange-400: "#FF7A3D"   # 그라데이션 상단 · 밝은 강조
  orange-300: "#FFB088"   # 보조 아이콘 · 라인
  orange-wash: "#FFF0E8"  # 선택 상태 배경 · 연한 강조 면
  orange-tint: "#FBE0D2"  # 카드 내 하이라이트 · 배지 배경
  # Surface
  paper: "#FDFAF6"        # 앱 배경 (웜 오프화이트, 시안 실측값)
  card: "#FFFFFF"         # 카드 · 입력 표면
  sunset: "#FF6A2C"       # 히어로/스플래시 풀블리드 배경 (레퍼런스 톤)
  # Text
  ink: "#241A14"          # 본문 (웜 니어블랙)
  soft: "#6B5D53"         # 보조 텍스트
  faint: "#9C8E83"        # 캡션 · placeholder
  on-orange: "#FFFFFF"    # 주황 위 텍스트
  # Line
  line: "#EFE4DB"         # 기본 구분선
  line-2: "#E0D2C6"       # 입력 테두리 · 강한 구분
  # Semantic
  ok: "#2E9E6B"           # 등록검증 · 성공
  ok-wash: "#E4F4EC"
  warn: "#E0912F"         # 주의 · 야간 안내
  warn-wash: "#FDF0DD"
  ember: "#BE4718"        # 긴급 진입("아이를 보내주려 해요") — 메인 오렌지와 같은 계열의 깊은 앰버
  ember-wash: "#FBE9E0"
  danger: "#C6402E"       # 오류 전용 (긴급 진입에는 쓰지 않음)
  danger-wash: "#FBE7E2"
  gold: "#D3A23C"         # 별점 · "강매 없음" 프리미엄 신뢰 (황토색 X, 맑은 골드)
  gold-wash: "#F8EFD9"

typography:
  display:   { fontFamily: "Pretendard", fontSize: "28px", fontWeight: 800, lineHeight: "1.22", letterSpacing: "-0.02em" }
  h1:        { fontFamily: "Pretendard", fontSize: "24px", fontWeight: 800, lineHeight: "1.25", letterSpacing: "-0.02em" }
  h2:        { fontFamily: "Pretendard", fontSize: "18px", fontWeight: 750, lineHeight: "1.3",  letterSpacing: "-0.01em" }
  h3:        { fontFamily: "Pretendard", fontSize: "16px", fontWeight: 700, lineHeight: "1.35", letterSpacing: "-0.01em" }
  body:      { fontFamily: "Pretendard", fontSize: "15px", fontWeight: 400, lineHeight: "1.6",  letterSpacing: "0" }
  body-strong:{ fontFamily: "Pretendard", fontSize: "15px", fontWeight: 600, lineHeight: "1.6", letterSpacing: "0" }
  caption:   { fontFamily: "Pretendard", fontSize: "12.5px", fontWeight: 500, lineHeight: "1.5", letterSpacing: "0" }
  eyebrow:   { fontFamily: "Pretendard", fontSize: "11.5px", fontWeight: 800, lineHeight: "1.4", letterSpacing: "0.04em" }
  mono-num:  { fontFamily: "SF Mono, Consolas, monospace", fontSize: "20px", fontWeight: 700, lineHeight: "1.2", letterSpacing: "-0.01em" }

rounded:
  sm: 10
  md: 16
  lg: 22
  xl: 28
  pill: 999

spacing:
  base: 4
  xs: 8
  sm: 12
  md: 16
  lg: 20
  xl: 28
  2xl: 40

components:
  btn-primary:  { backgroundColor: "orange-500", textColor: "on-orange", typography: "body-strong", rounded: "md", padding: "16px 20px" }
  btn-ghost:    { backgroundColor: "card", textColor: "ink", typography: "body-strong", rounded: "md", padding: "16px 20px" }
  btn-urgent:   { backgroundColor: "ember", textColor: "on-orange", typography: "body-strong", rounded: "md", padding: "16px 20px" }
  card:         { backgroundColor: "card", textColor: "ink", typography: "body", rounded: "lg", padding: "16px" }
  badge:        { backgroundColor: "orange-wash", textColor: "orange-600", typography: "eyebrow", rounded: "sm", padding: "4px 9px" }
  option:       { backgroundColor: "card", textColor: "soft", typography: "body-strong", rounded: "sm", padding: "12px 8px" }
  slot:         { backgroundColor: "card", textColor: "soft", typography: "body-strong", rounded: "sm", padding: "11px 6px" }
---

# LastCare — DESIGN.md

## Overview

라스트케어는 반려동물을 떠나보내는 순간부터 장례·사후 행정·추모까지 함께하는 앱이다.
디자인은 두 개의 상반된 요구를 동시에 만족해야 한다: **위기의 순간엔 차분하고 명료하게**,
**추모·사전준비의 순간엔 따뜻하고 다정하게.**

기존의 어둡고 무거운 "장례" 클리셰(검정·회색·차가운 그린) 대신 **햇살 같은 주황**을 택했다.
주황은 노을·금잔화(메리골드, 오래전부터 추모의 꽃)·온기를 상징한다. 슬픔을 부정하지 않되,
"잘 보내주자"는 따뜻한 마무리의 정서를 전한다.

**핵심 특성**
- **웜 미니멀:** 넓은 면적은 크림 뉴트럴(`paper`), 주황은 히어로·CTA·강조에 절제해 사용. 채도를 남발하지 않는다.
- **모던 플랫:** 라운드 스퀘어, 부드러운 그라데이션, 길고 은은한 롱 섀도우(레퍼런스 앱 아이콘 톤).
- **한 화면 한 목적:** 위기 화면일수록 요소를 덜어낸다. 신뢰 신호는 항상 상위 노출.
- **동행형 카피:** 명령형이 아닌 "~할게요 / 천천히 오세요" 톤. 재촉·세일 문구 금지.

---

## Colors

### Brand & Accent
- **Orange 500** `orange-500` `#F15A24` — 브랜드 히어로. 주 버튼, 활성 상태, 핵심 강조.
- **Orange 600** `orange-600` `#D84816` — 버튼 hover/press, 주황 위 진한 텍스트.
- **Orange 400** `orange-400` `#FF7A3D` — 그라데이션 상단 스톱, 밝은 강조.
- **Orange 300** `orange-300` `#FFB088` — 보조 아이콘, 장식 라인.
- **Orange Wash** `orange-wash` `#FFF0E8` — 선택/활성 배경, 연한 강조 면.
- **Orange Tint** `orange-tint` `#FBE0D2` — 배지 배경, 카드 내 하이라이트.
- **Sunset** `sunset` `#FF6A2C` — 히어로·스플래시 풀블리드 배경(레퍼런스 톤). 넓게 쓸 땐 이 화면에만.

> 브랜드 그라데이션: `linear-gradient(160deg, #FF7A3D 0%, #F15A24 100%)` — 아이콘 마크·히어로·주요 CTA에 한정.

### Surface
- **Paper** `paper` `#FDFAF6` — 앱 기본 배경(웜 오프화이트, 시안 실측값). 순백 대신 온기 있는 바탕. 모든 화면(이미지·코드) 배경을 이 값으로 통일해 seam을 없앤다.
- **Card** `card` `#FFFFFF` — 카드·입력 표면.

### Text
- **Ink** `ink` `#241A14` — 본문(웜 니어블랙). 순검정 지양.
- **Soft** `soft` `#6B5D53` — 보조 설명 텍스트.
- **Faint** `faint` `#9C8E83` — 캡션·placeholder.

### Semantic
- **OK** `ok` `#2E9E6B` / `ok-wash` `#E4F4EC` — 등록검증·성공 상태.
- **Warn** `warn` `#E0912F` / `warn-wash` `#FDF0DD` — 주의·야간 안내.
- **Ember** `ember` `#BE4718` / `ember-wash` `#FBE9E0` — 긴급 진입("아이를 보내주려 해요"). 메인 오렌지와 같은 계열의 깊은 앰버 — 응급실 같은 빨강 대신 "긴급하지만 따뜻하게". **진입점 1곳 전용.**
- **Danger** `danger` `#C6402E` / `danger-wash` `#FBE7E2` — 오류·경고 전용. 긴급 진입엔 쓰지 않음. **남용 금지.**
- **Gold** `gold` `#D3A23C` / `gold-wash` `#F8EFD9` — 별점, "강매 없음" 프리미엄 신뢰. 채도 낮은 황토색 금지(썩은 색으로 보임).

> 시맨틱 색은 브랜드 주황과 별개로 **상태 전달에만** 사용한다. 긴급(danger)은 진입점 1곳 외 확산 금지.
> 색만으로 상태를 구분하지 않는다 — 항상 아이콘/텍스트를 병기한다.

---

## Typography

### Font Family
- **주 서체:** `Pretendard` (한글 가독 최우선). 폴백: `system-ui, "Apple SD Gothic Neo", "Malgun Gothic", sans-serif`.
- **숫자:** 금액·시간은 `SF Mono / Consolas` 계열 + `tabular-nums`로 정렬성 확보.
- 웹폰트는 성능·CSP 고려해 번들/셀프호스팅. CDN 의존 지양.

### Hierarchy
| token | size | weight | line-height | letter-spacing | use |
|---|---|---|---|---|---|
| `display` | 28px | 800 | 1.22 | -0.02em | 스플래시·히어로 대제목 |
| `h1` | 24px | 800 | 1.25 | -0.02em | 화면 대제목 |
| `h2` | 18px | 750 | 1.3 | -0.01em | 섹션·화면 제목 |
| `h3` | 16px | 700 | 1.35 | -0.01em | 카드 제목 |
| `body` | 15px | 400 | 1.6 | 0 | 본문 |
| `body-strong` | 15px | 600 | 1.6 | 0 | 강조 본문·버튼 |
| `caption` | 12.5px | 500 | 1.5 | 0 | 보조·캡션 |
| `eyebrow` | 11.5px | 800 | 1.4 | 0.04em | 라벨·오버라인 |
| `mono-num` | 20px | 700 | 1.2 | -0.01em | 금액·확정가 |

### Principles
- 제목은 `text-wrap: balance`, 본문 행간 1.6으로 넉넉히.
- 카피는 동행형. "지금 예약하세요!" ❌ → "천천히 예약해 두셔도 돼요" ✅.
- eyebrow는 주황(`orange-500`)으로 섹션을 안내하되 짧게.

### Font Substitutes
Pretendard 미가용 환경에선 `Wanted Sans` 또는 `system-ui`로 대체. 굵기 대비(400/600/800)만 유지되면 무방.

---

## Layout

### Spacing System
- 기본 단위 **4px**. 토큰: `xs 8 / sm 12 / md 16 / lg 20 / xl 28 / 2xl 40`.
- 카드 padding: 16px(md). 화면 좌우 여백: 20px.
- 세그먼트 옵션·슬롯: 터치 타깃 높이 ≥ 44px 보장.
- 하단 고정 CTA는 콘텐츠와 12–14px 간격 + 배경 페이드.

### Grid & Container
- **모바일 우선(360–430px).** 단일 컬럼 스택이 기본.
- 시간 슬롯: 3열 그리드. 사후 케어 카드: 세로 스택.
- 태블릿/웹(≥768px)은 중앙 정렬 max-width 480px 컨테이너로 확장(v0.2).

### Whitespace Philosophy
크림 바탕(`paper`) 위에 흰 카드를 띄우는 구조. 여백이 곧 위로다. 위기·긴급 화면일수록
요소를 덜어내고, 주황은 "다음 행동" 한 곳에만 집중시킨다.

---

## Elevation & Depth
| level | treatment | use |
|---|---|---|
| 0 | 그림자 없음, `line` 1px | 기본 구분·입력 |
| 1 | `0 2px 8px -2px rgba(58,30,12,.08)` | 카드 기본 |
| 2 | `0 12px 26px -16px rgba(58,30,12,.28)` | hover 카드·업체 카드 |
| 3 | `0 8px 20px -8px rgba(241,90,36,.45)` | 주 CTA(주황 글로우) |
| hero | 롱 섀도우 `24px 24px 0 rgba(0,0,0,.06)` 방향성 | 스플래시 아이콘 |

### Decorative Depth
레퍼런스 앱 아이콘처럼 **라운드 스퀘어 + 그라데이션 마크 + 대각선 롱 섀도우**가 시그니처.
그림자는 웜톤(갈색기)으로. 순회색 그림자 금지 — 차갑게 보인다.

---

## Shapes

### Border Radius Scale
| token | value | use |
|---|---|---|
| `sm` | 10px | 배지·옵션·슬롯·입력 |
| `md` | 16px | 버튼·작은 카드 |
| `lg` | 22px | 카드·모달 |
| `xl` | 28px | 히어로 패널·앱 아이콘(라운드 스퀘어) |
| `pill` | 999px | 태그·토글 |

### Photography & Illustration Geometry
- 반려동물 사진: 라운드(`lg`) 크롭, 따뜻한 채광 우선. 무거운 흑백 지양.
- 로고 마크: 흰 라운드 스퀘어(`xl`) 안에 주황 그라데이션 심볼.
- 아이콘: 인라인 SVG 라인(stroke 2, round cap/join). 이모지는 신뢰·의료 맥락에서 최소화.

---

## Components

### Buttons
- **Primary** `btn-primary` — 배경 브랜드 그라데이션(또는 `orange-500`), 텍스트 흰색 600, rounded `md`, 높이 52px. hover: `orange-600` + translateY(-1px), level-3 글로우.
- **Ghost** `btn-ghost` — 흰 배경 + `line-2` 1px, 텍스트 `ink`. hover: `orange-wash` 배경.
- **Urgent** `btn-urgent` — `ember` 배경. 긴급 진입("아이를 보내주려 해요") 전용, 화면당 1개. 오류 빨강(`danger`)과 구분.

### Badges
높이 ~24px, rounded `sm`, `eyebrow` 타입. 종류:
- `ok` — 등록검증(체크 아이콘 + `ok` 색).
- `watch` — 참관 보장(`orange-wash` 배경 + `orange-600`).
- `gold` — 강매 없음(`gold-wash` + `gold`).

### Cards & Containers
흰 배경, rounded `lg`, `line` 1px, padding 16px, elevation 1. hover 가능한 카드(업체)는 elevation 2 + translateY(-2px).

### Inputs & Segmented Options
- **Option** `option` — 세그먼트 버튼. 기본: `line-2` 테두리 + `soft` 텍스트. 선택: `orange-500` 테두리 + `orange-wash` 배경 + `orange-600` 텍스트. 터치 ≥44px.
- 각 그룹 기본값 사전 선택(위기 상황 입력 최소화).

### Time Slots
3열 그리드. 상태: 기본 / 선택(`orange-500` 채움 + 흰 텍스트) / 마감(`taken`: opacity .4 + 취소선 + 비활성).

### Estimate Banner (확정가)
`orange-500`(또는 그라데이션) 배경 위 흰 텍스트. 금액은 `mono-num`. "부가세 포함 확정가" 라벨 병기.

### Sticky CTA
하단 고정, 배경 `paper` 페이드 그라데이션. 다음 행동 1개만.

### Memorial & QR (신규 기능군)
- **추모 카드:** `orange-wash` 배경 + 라운드 사진 + 기일 D-day. 따뜻한 톤 유지.
- **QR/NFC 추모석:** QR은 흰 카드 안 중앙, 하단에 추모 페이지 링크. 인쇄물용 고대비 버전 별도.

---

## Do's and Don'ts

### Do
- 주황은 "다음 행동"과 신뢰 신호에 집중시킨다.
- 넓은 면적은 크림(`paper`)·흰 카드로 숨 쉬게 한다.
- 동행형·정직한 카피. 확정가·법적 사실은 명확하게.
- 상태는 색 + 아이콘 + 텍스트로 중복 전달.

### Don't
- 주황을 배경 전체에 남발하지 않는다(스플래시/히어로 제외). 세일 앱처럼 보인다.
- 세일·긴급 조장 문구("지금 안 하면 손해", 카운트다운) 금지 — 장례 맥락에 부적절.
- 순검정·순회색·차가운 그림자 금지(웜톤 유지).
- 과한 애니메이션·튀는 모션 금지. 화면 전환은 opacity + 소폭 이동 0.3s, `prefers-reduced-motion` 존중.
- 채도 낮은 황토색 골드 금지 — 맑은 골드(`gold`)만.

### ⚠️ AI 슬롭 회피 (중요)
"AI가 자동 생성한 티"를 내는 아래 패턴을 금지한다.
- **그라데이션으로 채운 라운드 아이콘 박스 + 흰 라인 아이콘** 조합 남용 금지. (앱 로고 마크 1곳만 예외)
- **모든 요소를 "테두리 1px + 둥근 모서리 + 그림자"로 통일**하지 않는다. 요소마다 위계를 달리한다:
  구분이 필요하면 여백·배경 톤 차이 → 그다음 은은한 웜 섀도우 → 테두리는 최후. 테두리+그림자 이중 사용 지양.
- 실제 사진이 들어갈 자리(추모 등)에 **그라데이션 플레이스홀더 박스**를 쓰지 않는다.
  → 프레임(폴라로이드형) + 실사진 또는 중립 웜톤 플레이스홀더로.
- 추모 컴포넌트는 "기능 카드"가 아니라 **키프세이크(기억의 물건)** 처럼. 이름·연도·기일을 사람처럼.
- 이모지 아이콘 남발 금지. 라인 아이콘은 stroke·굵기·크기를 일관되게.

---

## Responsive Behavior

### Breakpoints
| name | width | key changes |
|---|---|---|
| mobile | 360–430px | 기본. 단일 컬럼, 하단 고정 CTA |
| tablet | 431–767px | 좌우 여백 확대, 슬롯 여전히 3열 |
| web | ≥768px | max-width 480px 중앙 컨테이너(v0.2) |

### Touch Targets
모든 탭 대상 ≥ 44×44px. 옵션·슬롯·백 버튼 포함.

### Collapsing Strategy
업체 카드·사후 케어는 세로 스택 유지(가로 스크롤 금지). 긴 견적 내역은 카드 내 스크롤이 아닌 전체 확장.

### Image Behavior
반려동물 사진은 `max-width:100%`, 라운드 크롭 비율 유지. 저사양/야간 로딩 대비 `paper` 톤 플레이스홀더.

---

## Iteration Guide
1. 색·간격·컴포넌트를 바꿀 땐 먼저 이 파일의 front-matter 토큰을 수정한다(코드가 아닌 토큰이 소스 오브 트루스).
2. 새 컴포넌트는 Components 섹션에 이름·토큰·상태를 함께 문서화한 뒤 구현한다.
3. 업체 인터뷰로 견적 룰이 확정되면 Estimate Banner 표기 규칙을 갱신한다.
4. 접근성(대비·터치·모션)은 신규 컴포넌트마다 재검증한다.

## Known Gaps
- 다크 모드 팔레트 미정(야간 임종 다발 → 우선순위 검토 필요).
- 사전준비(Pre-need) 전용 화면군의 비주얼 언어 미확정.
- 생성형 추모(사진→영상/포토북) 결과물의 프레이밍·워터마크 규칙 미정.
- 일러스트 스타일(라인 vs 플랫 컬러) 미확정 — 샘플 후 결정.
- 실제 주황 Hex는 레퍼런스 이미지 기준 근사값. 브랜드 확정 시 재보정.
