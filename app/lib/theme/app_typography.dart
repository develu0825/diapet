import 'package:flutter/widgets.dart';
import 'app_colors.dart';

/// 타이포그래피 토큰 — DESIGN.md v1.0 기준.
///
/// 주 서체는 Pretendard. 아직 폰트를 번들하지 않아 [fontFamily]는 시스템 폴백을
/// 사용한다(DESIGN.md: 미가용 환경에선 system-ui 대체 무방). 폰트 번들 후
/// [fontFamily]만 'Pretendard'로 교체하면 된다.
/// letterSpacing은 em→px 환산값(em * fontSize)을 사용한다.
abstract final class AppText {
  static const String? fontFamily = null; // TODO: 'Pretendard' (폰트 번들 후)
  static const String monoFamily = 'monospace'; // 금액·시간 (SF Mono/Consolas 계열)

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.22,
    letterSpacing: -0.56,
    color: AppColors.ink,
  );
  static const h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w800,
    height: 1.25,
    letterSpacing: -0.48,
    color: AppColors.ink,
  );
  static const h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700, // spec 750 → 근사 w700
    height: 1.3,
    letterSpacing: -0.18,
    color: AppColors.ink,
  );
  static const h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.35,
    letterSpacing: -0.16,
    color: AppColors.ink,
  );
  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.ink,
  );
  static const bodyStrong = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.6,
    color: AppColors.ink,
  );
  static const caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.soft,
  );
  static const eyebrow = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11.5,
    fontWeight: FontWeight.w800,
    height: 1.4,
    letterSpacing: 0.46,
    color: AppColors.orange500,
  );

  /// 금액·확정가 — 모노 + tabular figures.
  static const monoNum = TextStyle(
    fontFamily: monoFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.20,
    fontFeatures: [FontFeature.tabularFigures()],
    color: AppColors.ink,
  );
}
