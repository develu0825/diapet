import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 확정가 배너 — DESIGN.md Estimate Banner.
///
/// 그라데이션 배경 위 흰 텍스트. 금액은 mono-num. "부가세 포함" 라벨 병기.
class EstimateBanner extends StatelessWidget {
  const EstimateBanner({
    super.key,
    this.label = '예상 확정가 (부가세 포함)',
    required this.value,
    this.suffix = '만원~',
  });

  final String label;

  /// 금액 본문(예: "22.0").
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppElevation.e3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(label, style: const TextStyle(
              fontSize: 12.5, color: AppColors.onOrange, height: 1.3)),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text.rich(
            TextSpan(
              style: AppText.monoNum.copyWith(color: AppColors.onOrange, fontSize: 22),
              children: [
                TextSpan(text: value),
                TextSpan(text: suffix, style: const TextStyle(
                  fontFamily: null, fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
