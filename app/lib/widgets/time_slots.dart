import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 시간 슬롯 항목.
class TimeSlot {
  const TimeSlot(this.label, {this.taken = false});
  final String label;
  final bool taken; // 마감(선택 불가)
}

/// 시간 슬롯 3열 그리드 — DESIGN.md Time Slots.
///
/// 상태: 기본 / 선택(orange 채움 + 흰 텍스트) / 마감(opacity + 취소선).
class TimeSlots extends StatelessWidget {
  const TimeSlots({
    super.key,
    required this.slots,
    required this.selected,
    required this.onSelect,
  });

  final List<TimeSlot> slots;

  /// 선택된 슬롯 라벨.
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.xs,
      crossAxisSpacing: AppSpacing.xs,
      childAspectRatio: 2.6,
      children: [
        for (final slot in slots)
          _Slot(
            slot: slot,
            selected: slot.label == selected,
            onTap: slot.taken ? null : () => onSelect(slot.label),
          ),
      ],
    );
  }
}

class _Slot extends StatelessWidget {
  const _Slot({required this.slot, required this.selected, this.onTap});
  final TimeSlot slot;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color fg = slot.taken
        ? AppColors.faint
        : selected
            ? AppColors.onOrange
            : AppColors.soft;
    return Opacity(
      opacity: slot.taken ? 0.4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.orange500 : AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(
              color: selected ? AppColors.orange500 : AppColors.line2,
              width: 1.5,
            ),
          ),
          child: Text(
            slot.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
              decoration: slot.taken ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
