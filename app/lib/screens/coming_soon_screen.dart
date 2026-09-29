import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 아직 이식되지 않은 플로우용 임시 화면. 각 기능 커밋에서 실제 화면으로 교체된다.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.paper,
        surfaceTintColor: Colors.transparent,
        title: Text(title, style: AppText.h2),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            '$title 화면은 준비 중이에요.',
            style: AppText.body.copyWith(color: AppColors.soft),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
