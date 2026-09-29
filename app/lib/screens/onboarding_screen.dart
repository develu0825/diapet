import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';

/// 온보딩(스플래시) 자리표시자 — 실제 이미지·카피는 온보딩 기능 커밋에서 완성.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Diapet', style: AppText.display),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '함께한 모든 순간을, 평화롭게.',
                style: AppText.body.copyWith(color: AppColors.soft),
              ),
              const Spacer(),
              AppButton(
                label: '시작하기',
                trailingIcon: Icons.arrow_forward,
                onPressed: () =>
                    Navigator.of(context).pushReplacementNamed(Routes.homeShell),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
