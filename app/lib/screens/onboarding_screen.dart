import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../app_routes.dart';
import '../services/auth_service.dart';
import '../services/consent_store.dart';
import '../theme/app_colors.dart';

/// 온보딩(스플래시) (s-onboard) — 풀블리드 이미지. 탭하면 로그인 게이트로.
///
/// "함께한 모든 순간을, 평화롭게." 프로토타입의 전체 이미지 화면을 이식.
/// 이미 로그인·약관동의가 된 사용자는 바로 홈으로, 아니면 로그인으로 보낸다.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    // 저장된 세션을 미리 복원해, 탭 시 목적지를 바로 판단할 수 있게 한다.
    authService.restore();
  }

  Future<void> _enter() async {
    final consented = await consentStore.hasConsented();
    if (!mounted) return;
    final loggedIn = authService.currentUser != null;
    Navigator.of(context).pushReplacementNamed(
      loggedIn && consented ? Routes.homeShell : Routes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sunset,
      body: GestureDetector(
        key: const Key('onboarding-enter'),
        onTap: _enter,
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
