import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 배지 종류 — DESIGN.md Components > Badges.
/// 색만으로 상태를 구분하지 않도록 아이콘/텍스트를 병기한다.
enum AppBadgeVariant {
  ok, // 등록검증 · 성공
  watch, // 참관 보장
  gold, // 강매 없음 · 프리미엄 신뢰
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.ok,
    this.icon,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (variant) {
      AppBadgeVariant.ok => (AppColors.okWash, AppColors.ok),
      AppBadgeVariant.watch => (AppColors.orangeWash, AppColors.orange600),
      AppBadgeVariant.gold => (AppColors.goldWash, AppColors.gold),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.115,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
