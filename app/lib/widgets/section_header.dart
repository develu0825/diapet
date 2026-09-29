import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 섹션/화면 헤더 — eyebrow(오버라인) + 제목 + 설명 lede.
///
/// eyebrow는 주황으로 섹션을 짧게 안내한다(DESIGN.md Typography 원칙).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    this.eyebrow,
    required this.title,
    this.description,
    this.titleStyle,
  });

  final String? eyebrow;
  final String title;
  final String? description;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!.toUpperCase(), style: AppText.eyebrow),
          const SizedBox(height: AppSpacing.base),
        ],
        Text(title, style: titleStyle ?? AppText.h1),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(description!, style: AppText.body.copyWith(color: AppColors.soft)),
        ],
      ],
    );
  }
}
