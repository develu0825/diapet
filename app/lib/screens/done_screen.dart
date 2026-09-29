import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../models/booking_draft.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/sticky_cta.dart';
import 'confirm_screen.dart' show won;

/// 예약 완료 (s-done) — 확정 안내 + 장례 이후 사후 케어 안내.
class DoneScreen extends StatelessWidget {
  const DoneScreen({super.key, required this.draft});

  final BookingDraft draft;

  void _toHome(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName(Routes.homeShell));
  }

  @override
  Widget build(BuildContext context) {
    final d = draft;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.md),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: const BoxDecoration(
                            color: AppColors.okWash, shape: BoxShape.circle),
                          child: const Icon(Icons.check, size: 32, color: AppColors.ok),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text('예약이 확정되었어요', style: AppText.h1),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${d.vendor.name} · ${d.date} ${d.time}\n천천히 오세요. 저희가 준비해 두겠습니다.',
                          textAlign: TextAlign.center,
                          style: AppText.body.copyWith(color: AppColors.soft),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SummaryCard(children: [
                    _Row('장례식장', d.vendor.name),
                    _Row('일시', '${d.date} ${d.time}'),
                    _Row('확정 결제액', '${won(d.total)}원 (부가세 포함)'),
                    _Row('참관', '전 과정 가능'),
                  ]),
                  const SizedBox(height: AppSpacing.sm),
                  Row(children: [
                    const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.orange500),
                    const SizedBox(width: 7),
                    Expanded(child: Text('예약 확정 알림을 카카오톡으로 보내드렸어요.',
                        style: AppText.caption.copyWith(color: AppColors.faint))),
                  ]),
                  const SizedBox(height: AppSpacing.xl),
                  Text('장례 이후, 저희가 챙겨드릴게요', style: AppText.h3),
                  const SizedBox(height: AppSpacing.sm),
                  _AfterCare(
                    icon: Icons.fact_check_outlined,
                    title: '동물등록 말소 신고 안내',
                    subtitle: '사망 30일 이내 · 미신고 시 과태료. 정부24 바로가기를 보내드려요.',
                    onTap: () => _snack(context, '정부24 안내를 보내드릴게요.'),
                  ),
                  _AfterCare(
                    icon: Icons.chat_bubble_outline,
                    title: '펫로스 심리 상담 (무료 1회)',
                    subtitle: '혼자 견디지 않으셔도 됩니다. 전문 상담을 연결해 드려요.',
                    onTap: () => _snack(context, '상담 연결은 준비 중이에요.'),
                  ),
                  _AfterCare(
                    icon: Icons.favorite_border,
                    title: '디지털 추모 공간',
                    subtitle: '기일 알림과 함께, 아이를 오래 기억할 공간을 만들어 드려요.',
                    onTap: () => _toHome(context),
                  ),
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '처음으로',
                variant: AppButtonVariant.ghost,
                onPressed: () => _toHome(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(
          color: Color.fromRGBO(58, 30, 12, 0.05), offset: Offset(0, 1), blurRadius: 2)],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.k, this.v);
  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: AppText.body.copyWith(color: AppColors.soft)),
          Flexible(child: Text(v, textAlign: TextAlign.right, style: AppText.bodyStrong)),
        ],
      ),
    );
  }
}

class _AfterCare extends StatelessWidget {
  const _AfterCare({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [BoxShadow(
              color: Color.fromRGBO(58, 30, 12, 0.05), offset: Offset(0, 1), blurRadius: 2)],
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.orange500),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppText.bodyStrong.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppText.caption.copyWith(
                        color: AppColors.soft, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
            ],
          ),
        ),
      ),
    );
  }
}
