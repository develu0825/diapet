import 'package:flutter/material.dart';

import '../../app_assets.dart';
import '../../app_routes.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/consent_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 로그인 화면 — 온보딩 다음, 홈 진입 전 게이트.
///
/// 한국 반려동물 앱 기준 카카오를 최상단에, 애플(iOS 심사)·이메일을 보조로,
/// 부담 없는 '둘러보기'(게스트)를 맨 아래에 둔다. 로그인 성공 후 약관 동의가
/// 없으면 동의 화면으로, 있으면 홈으로 보낸다.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _busy = false;

  Future<void> _signIn(SignInMethod method, {String? email}) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await authService.signIn(method, email: email);
      final consented = await consentStore.hasConsented();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(
        consented ? Routes.homeShell : Routes.consent,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _emailFlow() async {
    final email = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const _EmailSheet(),
    );
    if (email != null && email.isNotEmpty) {
      await _signIn(SignInMethod.email, email: email);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 3),
              Image.asset(AppAssets.logoIcon, width: 72, height: 72),
              const SizedBox(height: AppSpacing.lg),
              Image.asset(AppAssets.logoDiapet, height: 34),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                '가장 힘든 순간, 끝까지 곁을 지킬게요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.soft, height: 1.5),
              ),
              const Spacer(flex: 4),
              _SocialButton(
                key: const Key('login-kakao'),
                label: '카카오로 시작하기',
                background: const Color(0xFFFEE500),
                foreground: const Color(0xFF191600),
                icon: Icons.chat_bubble,
                onPressed: _busy ? null : () => _signIn(SignInMethod.kakao),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SocialButton(
                key: const Key('login-apple'),
                label: 'Apple로 계속하기',
                background: AppColors.ink,
                foreground: AppColors.onOrange,
                icon: Icons.apple,
                onPressed: _busy ? null : () => _signIn(SignInMethod.apple),
              ),
              const SizedBox(height: AppSpacing.sm),
              _SocialButton(
                key: const Key('login-email'),
                label: '이메일로 계속하기',
                background: AppColors.card,
                foreground: AppColors.ink,
                icon: Icons.mail_outline,
                border: true,
                onPressed: _busy ? null : _emailFlow,
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                key: const Key('login-guest'),
                onPressed: _busy ? null : () => _signIn(SignInMethod.guest),
                child: const Text(
                  '먼저 둘러볼게요',
                  style: TextStyle(
                    color: AppColors.soft,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(flex: 2),
              const Text(
                '로그인 시 서비스 이용약관과 개인정보처리방침에 동의하게 됩니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.5, color: AppColors.faint, height: 1.5),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

/// 소셜 로그인 버튼 — 브랜드별 배경/글자색을 받는 블록형 버튼.
class _SocialButton extends StatelessWidget {
  const _SocialButton({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
    required this.onPressed,
    this.border = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: border ? Border.all(color: AppColors.line2) : null,
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSpacing.minTouch + 6),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 19, color: foreground),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 이메일 입력 바텀시트(MVP: 이메일만 받아 목 로그인). 비밀번호·인증은 백엔드 연동 시.
class _EmailSheet extends StatefulWidget {
  const _EmailSheet();

  @override
  State<_EmailSheet> createState() => _EmailSheetState();
}

class _EmailSheetState extends State<_EmailSheet> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _controller.text.trim();
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!valid) {
      setState(() => _error = '올바른 이메일 주소를 입력해주세요.');
      return;
    }
    Navigator.of(context).pop(email);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '이메일로 계속하기',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            key: const Key('login-email-field'),
            controller: _controller,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'name@example.com',
              errorText: _error,
              filled: true,
              fillColor: AppColors.paper,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: const BorderSide(color: AppColors.line2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            key: const Key('login-email-submit'),
            onPressed: _submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orange500,
              minimumSize: const Size.fromHeight(AppSpacing.minTouch + 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: const Text('계속', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
