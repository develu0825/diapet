import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'screens/coming_soon_screen.dart';
import 'screens/home_shell.dart';
import 'screens/onboarding_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DiapetApp());
}

class DiapetApp extends StatelessWidget {
  const DiapetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diapet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: Routes.onboarding,
      routes: {
        Routes.onboarding: (_) => const OnboardingScreen(),
        Routes.homeShell: (_) => const HomeShell(),
        // 아래는 각 기능 커밋에서 실제 화면으로 교체된다.
        Routes.crisis: (_) => const ComingSoonScreen(title: '긴급 안내'),
        Routes.preneed: (_) => const ComingSoonScreen(title: '사전 준비'),
      },
    );
  }
}
