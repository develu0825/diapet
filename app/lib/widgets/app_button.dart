import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';

/// 버튼 종류 — DESIGN.md Components > Buttons.
enum AppButtonVariant {
  /// 브랜드 그라데이션 + 흰 텍스트 + 주황 글로우. 주 CTA.
  primary,

  /// 흰 배경 + line-2 테두리. 보조 행동.
  ghost,

  /// ember 배경. 긴급 진입 전용, 화면당 1개.
  urgent,
}

/// 공용 버튼. 폭은 부모를 채우며(블록형) 최소 높이 [AppSpacing.minTouch] 보장.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.trailingIcon,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? trailingIcon;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == AppButtonVariant.primary;
    final Color fg = switch (variant) {
      AppButtonVariant.primary => AppColors.onOrange,
      AppButtonVariant.urgent => AppColors.onOrange,
      AppButtonVariant.ghost => AppColors.ink,
    };

    final content = DefaultTextStyle.merge(
      style: const TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.155,
      ).copyWith(color: fg),
      child: IconTheme.merge(
        data: IconThemeData(color: fg, size: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(trailingIcon),
            ],
          ],
        ),
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            gradient: isPrimary ? AppColors.brandGradient : null,
            color: switch (variant) {
              AppButtonVariant.primary => null,
              AppButtonVariant.ghost => AppColors.card,
              AppButtonVariant.urgent => AppColors.ember,
            },
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: variant == AppButtonVariant.ghost
                ? Border.all(color: AppColors.line2)
                : null,
            boxShadow: isPrimary ? AppElevation.e3 : null,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSpacing.minTouch),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
