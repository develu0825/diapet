import 'package:flutter/widgets.dart';

/// Elevation(그림자) 토큰 — DESIGN.md v1.0 기준.
///
/// 그림자는 웜톤(갈색기 rgba(58,30,12))으로. 순회색 그림자 금지(차갑게 보임).
/// CSS의 음수 spread를 [BoxShadow.spreadRadius]로 그대로 옮겼다.
abstract final class AppElevation {
  /// level 1 — 카드 기본.
  static const List<BoxShadow> e1 = [
    BoxShadow(
      color: Color.fromRGBO(58, 30, 12, 0.08),
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  /// level 2 — hover 카드·업체 카드.
  static const List<BoxShadow> e2 = [
    BoxShadow(
      color: Color.fromRGBO(58, 30, 12, 0.28),
      offset: Offset(0, 12),
      blurRadius: 26,
      spreadRadius: -16,
    ),
  ];

  /// level 3 — 주 CTA(주황 글로우).
  static const List<BoxShadow> e3 = [
    BoxShadow(
      color: Color.fromRGBO(241, 90, 36, 0.45),
      offset: Offset(0, 8),
      blurRadius: 20,
      spreadRadius: -8,
    ),
  ];
}
