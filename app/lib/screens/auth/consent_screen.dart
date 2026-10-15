import 'package:flutter/material.dart';

import '../../app_routes.dart';
import '../../services/consent_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// 약관·개인정보 동의 화면 — 로그인 직후, 홈 진입 전.
///
/// 필수(만 14세 이상·서비스 이용약관·개인정보 수집·이용)를 모두 체크해야
/// 계속할 수 있고, 마케팅 수신은 선택이다. 동의 결과는 [ConsentStore] 에 저장된다.
class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _age14 = false;
  bool _tos = false;
  bool _privacy = false;
  bool _marketing = false;

  bool get _allRequired => _age14 && _tos && _privacy;
  bool get _allChecked => _age14 && _tos && _privacy && _marketing;

  void _setAll(bool v) => setState(() {
        _age14 = _tos = _privacy = _marketing = v;
      });

  Future<void> _continue() async {
    await consentStore.save(marketing: _marketing);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(Routes.homeShell);
  }

  void _showDoc(String title) {
    // TODO(legal): 실제 약관·개인정보처리방침 전문으로 교체.
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink)),
            const SizedBox(height: AppSpacing.md),
            const Text(
              '약관 전문은 출시 전 법무 검토 후 제공됩니다.\n\n'
              '현재는 자리표시용 안내입니다. 실제 서비스에서는 수집 항목·이용 목적·'
              '보유 기간·제3자 제공·동의 거부 권리 등이 이 자리에 명시됩니다.',
              style: TextStyle(fontSize: 14, color: AppColors.soft, height: 1.7),
            ),
          ],
        ),
      ),
    );
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
              const SizedBox(height: AppSpacing.xl),
              const Text(
                '서비스 이용을 위해\n약관에 동의해주세요',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    height: 1.35),
              ),
              const SizedBox(height: AppSpacing.xs),
              const Text(
                '소중한 정보를 안전하게 지키겠습니다.',
                style: TextStyle(fontSize: 14.5, color: AppColors.soft),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 전체 동의
              _AgreeAllTile(
                key: const Key('consent-agree-all'),
                checked: _allChecked,
                onTap: () => _setAll(!_allChecked),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Divider(color: AppColors.line, height: AppSpacing.lg),

              _ConsentRow(
                label: '[필수] 만 14세 이상입니다',
                checked: _age14,
                onToggle: () => setState(() => _age14 = !_age14),
              ),
              _ConsentRow(
                label: '[필수] 서비스 이용약관 동의',
                checked: _tos,
                onToggle: () => setState(() => _tos = !_tos),
                onView: () => _showDoc('서비스 이용약관'),
              ),
              _ConsentRow(
                label: '[필수] 개인정보 수집·이용 동의',
                checked: _privacy,
                onToggle: () => setState(() => _privacy = !_privacy),
                onView: () => _showDoc('개인정보 수집·이용'),
              ),
              _ConsentRow(
                label: '[선택] 마케팅 정보 수신 동의',
                checked: _marketing,
                onToggle: () => setState(() => _marketing = !_marketing),
                onView: () => _showDoc('마케팅 정보 수신'),
              ),

              const Spacer(),
              Opacity(
                opacity: _allRequired ? 1 : 0.45,
                child: _ContinueButton(
                  onPressed: _allRequired ? _continue : null,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgreeAllTile extends StatelessWidget {
  const _AgreeAllTile({super.key, required this.checked, required this.onTap});

  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            color: checked ? AppColors.orangeWash : AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: checked ? AppColors.orange300 : AppColors.line2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: AppSpacing.md),
            child: Row(
              children: [
                _CheckMark(checked: checked),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  '약관에 전체 동의합니다',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  const _ConsentRow({
    required this.label,
    required this.checked,
    required this.onToggle,
    this.onView,
  });

  final String label;
  final bool checked;
  final VoidCallback onToggle;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            _CheckMark(checked: checked, subtle: true),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14.5, color: AppColors.ink),
              ),
            ),
            if (onView != null)
              GestureDetector(
                onTap: onView,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: Text(
                    '보기',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.faint,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  const _CheckMark({required this.checked, this.subtle = false});

  final bool checked;
  final bool subtle;

  @override
  Widget build(BuildContext context) {
    return Icon(
      checked ? Icons.check_circle : Icons.circle_outlined,
      size: subtle ? 22 : 24,
      color: checked ? AppColors.orange500 : AppColors.line2,
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('consent-continue'),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Container(
            constraints: const BoxConstraints(minHeight: AppSpacing.minTouch + 6),
            alignment: Alignment.center,
            child: const Text(
              '동의하고 시작하기',
              style: TextStyle(
                  color: AppColors.onOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
