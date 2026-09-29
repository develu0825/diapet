/// 간격·라운드 토큰 — DESIGN.md v1.0 기준. 기본 단위 4px.
abstract final class AppSpacing {
  static const double base = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16; // 카드 padding
  static const double lg = 20; // 화면 좌우 여백
  static const double xl = 28;
  static const double xxl = 40;

  /// 최소 터치 타깃 (옵션·슬롯·백 버튼 포함).
  static const double minTouch = 44;
}

/// Border radius 스케일.
abstract final class AppRadius {
  static const double sm = 10; // 배지·옵션·슬롯·입력
  static const double md = 16; // 버튼·작은 카드
  static const double lg = 22; // 카드·모달
  static const double xl = 28; // 히어로 패널·앱 아이콘
  static const double pill = 999; // 태그·토글
}
