import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../app_routes.dart';
import '../theme/app_colors.dart';

/// 온보딩(스플래시) (s-onboard) — 풀블리드 이미지. 탭하면 홈으로.
///
/// "함께한 모든 순간을, 평화롭게." 프로토타입의 전체 이미지 화면을 이식.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sunset,
      body: GestureDetector(
        key: const Key('onboarding-enter'),
        onTap: () =>
            Navigator.of(context).pushReplacementNamed(Routes.homeShell),
        child: SizedBox.expand(
          child: Image.asset(
            AppAssets.onboarding,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            // 이미지 로드 실패 시에도 진입 가능하도록 폴백.
            errorBuilder: (context, error, stack) => const _OnboardingFallback(),
          ),
        ),
      ),
    );
  }
}

class _OnboardingFallback extends StatelessWidget {
  const _OnboardingFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.sunset,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            '함께한 모든 순간을,\n평화롭게.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.onOrange,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
