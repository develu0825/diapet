import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// 메인 하단 탭 — 홈 / 장례 / 추모 / 마이.
enum MainTab {
  home('홈', Icons.home_outlined),
  funeral('장례', Icons.receipt_long_outlined),
  memorial('추모', Icons.favorite_border),
  my('마이', Icons.person_outline);

  const MainTab(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// 하단 탭바 — DESIGN.md 원칙: 활성은 주황, 높이 64, 상단 hairline.
class AppTabBar extends StatelessWidget {
  const AppTabBar({super.key, required this.current, required this.onSelect});

  final MainTab current;
  final ValueChanged<MainTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final tab in MainTab.values)
                _TabItem(
                  tab: tab,
                  selected: tab == current,
                  onTap: () => onSelect(tab),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final MainTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.orange500 : AppColors.faint;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab.icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
