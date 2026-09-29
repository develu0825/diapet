import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 하단 고정 CTA — DESIGN.md Components > Sticky CTA.
///
/// paper 페이드 그라데이션 위에 다음 행동 1개를 얹는다.
/// 화면 하단(예: [Scaffold.bottomNavigationBar]나 Stack 하단)에 배치한다.
class StickyCta extends StatelessWidget {
  const StickyCta({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00FDFAF6), AppColors.paper],
          stops: [0.0, 0.26],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}
