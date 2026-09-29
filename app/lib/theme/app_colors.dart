import 'package:flutter/material.dart';

/// LastCare/Diapet 색상 토큰 — DESIGN.md v1.0 기준.
///
/// 주황은 히어로·CTA·강조에만 절제해서 사용하고, 넓은 면적은 웜 크림([paper])으로.
/// 시맨틱 색은 상태 전달에만 사용하며, 색만으로 상태를 구분하지 않는다(아이콘·텍스트 병기).
abstract final class AppColors {
  // Brand & Accent
  static const orange500 = Color(0xFFF15A24); // 브랜드 히어로 · 주 버튼 · 강조
  static const orange600 = Color(0xFFD84816); // hover/press · 주황 위 진한 텍스트
  static const orange400 = Color(0xFFFF7A3D); // 그라데이션 상단 · 밝은 강조
  static const orange300 = Color(0xFFFFB088); // 보조 아이콘 · 라인
  static const orangeWash = Color(0xFFFFF0E8); // 선택 상태 배경 · 연한 강조 면
  static const orangeTint = Color(0xFFFBE0D2); // 배지 배경 · 카드 내 하이라이트
  static const sunset = Color(0xFFFF6A2C); // 히어로/스플래시 풀블리드 배경

  // Surface
  static const paper = Color(0xFFFDFAF6); // 앱 배경 (웜 오프화이트)
  static const card = Color(0xFFFFFFFF); // 카드 · 입력 표면

  // Text
  static const ink = Color(0xFF241A14); // 본문 (웜 니어블랙)
  static const soft = Color(0xFF6B5D53); // 보조 텍스트
  static const faint = Color(0xFF9C8E83); // 캡션 · placeholder
  static const onOrange = Color(0xFFFFFFFF); // 주황 위 텍스트

  // Line
  static const line = Color(0xFFEFE4DB); // 기본 구분선
  static const line2 = Color(0xFFE0D2C6); // 입력 테두리 · 강한 구분

  // Semantic
  static const ok = Color(0xFF2E9E6B); // 등록검증 · 성공
  static const okWash = Color(0xFFE4F4EC);
  static const warn = Color(0xFFE0912F); // 주의 · 야간 안내
  static const warnWash = Color(0xFFFDF0DD);
  static const ember = Color(0xFFBE4718); // 긴급 진입("아이를 보내주려 해요") — 진입점 1곳 전용
  static const emberWash = Color(0xFFFBE9E0);
  static const danger = Color(0xFFC6402E); // 오류 전용 (긴급 진입에는 쓰지 않음)
  static const dangerWash = Color(0xFFFBE7E2);
  static const gold = Color(0xFFD3A23C); // 별점 · "강매 없음" 프리미엄 신뢰
  static const goldWash = Color(0xFFF8EFD9);

  /// 브랜드 그라데이션 — 아이콘 마크·히어로·주요 CTA에 한정.
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange400, orange500],
  );
}
