import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 화면 상단바 — 뒤로 버튼 + 제목 + (선택) 우측 스텝/위젯.
///
/// 견적·상세·예약·결제 등 푸시된 플로우 화면 공통.
class ScreenBar extends StatelessWidget {
  const ScreenBar({super.key, required this.title, this.step, this.trailing});

  final String title;

  /// 우측 단계 표시(예: "1 / 2"). [trailing]이 있으면 무시된다.
  final String? step;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 6, AppSpacing.lg, 14),
      child: Row(
        children: [
          _BackButton(onTap: () => Navigator.of(context).maybePop()),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: AppText.h2)),
          if (trailing != null)
            trailing!
          else if (step != null)
            Text(step!, style: const TextStyle(
              fontFamily: AppText.monoFamily, fontSize: 11, color: AppColors.faint)),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.line2),
        ),
        child: const Icon(Icons.chevron_left, size: 20, color: AppColors.ink),
      ),
    );
  }
}
