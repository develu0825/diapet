import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 세그먼트 옵션 항목.
class SegmentOption {
  const SegmentOption(this.label, {this.sub});
  final String label;

  /// 작은 보조 라벨(예: "소형", "+5만").
  final String? sub;
}

/// 세그먼트 단일 선택 — DESIGN.md Inputs & Segmented Options.
///
/// 선택: orange 테두리 + orange-wash 배경 + orange-600 텍스트. 터치 ≥44px.
/// 위기 상황 입력 최소화를 위해 각 그룹은 기본값을 선택해 둔다.
class SegmentedOptions extends StatelessWidget {
  const SegmentedOptions({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<SegmentOption> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(child: _Opt(
            option: options[i],
            selected: i == selectedIndex,
            onTap: () => onChanged(i),
          )),
        ],
      ],
    );
  }
}

class _Opt extends StatelessWidget {
  const _Opt({required this.option, required this.selected, required this.onTap});
  final SegmentOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? AppColors.orange600 : AppColors.soft;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouch),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.orangeWash : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: selected ? AppColors.orange500 : AppColors.line2,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(option.label, style: TextStyle(
              fontSize: 13.5, fontWeight: FontWeight.w600, color: fg)),
            if (option.sub != null)
              Text(option.sub!, style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: selected ? AppColors.orange500 : AppColors.faint,
              )),
          ],
        ),
      ),
    );
  }
}
