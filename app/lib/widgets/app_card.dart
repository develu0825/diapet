import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';

/// 흰 카드 표면 — DESIGN.md Components > Cards.
///
/// 기본 elevation 1. 탭 가능한 카드(업체 등)는 [onTap] 지정 시 잉크 반응.
/// DESIGN 원칙상 테두리+그림자 이중 사용을 지양하므로 기본은 그림자만 사용한다.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = 18,
    this.color = AppColors.card,
    this.shadow = AppElevation.e1,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color color;
  final List<BoxShadow> shadow;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final decorated = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: shadow,
      ),
      padding: padding,
      child: child,
    );

    if (onTap == null) return decorated;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: decorated,
      ),
    );
  }
}
