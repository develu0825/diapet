import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// 디자인 토큰을 묶은 앱 테마 — DESIGN.md v1.0.
///
/// 넓은 면적은 웜 크림([AppColors.paper]) 위에 흰 카드를 띄우는 구조.
abstract final class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.orange500,
      onPrimary: AppColors.onOrange,
      secondary: AppColors.orange400,
      onSecondary: AppColors.onOrange,
      error: AppColors.danger,
      onError: AppColors.onOrange,
      surface: AppColors.card,
      onSurface: AppColors.ink,
    );

    const textTheme = TextTheme(
      displayLarge: AppText.display,
      headlineMedium: AppText.h1,
      titleLarge: AppText.h2,
      titleMedium: AppText.h3,
      bodyLarge: AppText.body,
      bodyMedium: AppText.body,
      labelLarge: AppText.bodyStrong,
      bodySmall: AppText.caption,
      labelSmall: AppText.eyebrow,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.paper,
      fontFamily: AppText.fontFamily,
      textTheme: textTheme,
      splashColor: AppColors.orangeWash,
      highlightColor: AppColors.orangeWash,
      // 과한 모션 지양(DESIGN.md) — 페이드 위주 전환.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
