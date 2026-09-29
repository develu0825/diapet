import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/screen_bar.dart';
import '../widgets/sticky_cta.dart';

/// 사전 준비 (s-preneed) — 노령·투병 중인 아이를 위한 차분한 사전 준비.
class PreneedScreen extends StatefulWidget {
  const PreneedScreen({super.key});

  @override
  State<PreneedScreen> createState() => _PreneedScreenState();
}

class _PreneedScreenState extends State<PreneedScreen> {
  final _checks = [
    (label: '아이 정보 등록 (종·나이·건강 상태)', done: true),
    (label: '믿을 수 있는 장례식장 미리 찜하기', done: false),
    (label: '함께 보낼 것 · 마지막 인사 준비', done: false),
    (label: '펫로스 상담 사전 안내 받기', done: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenBar(title: '미리 준비하기'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                children: [
                  Text('천천히, 마음의 준비부터', style: AppText.eyebrow),
                  const SizedBox(height: AppSpacing.xs),
                  Text('그날이 오기 전에,\n차분히 준비해 둘게요.',
                      style: AppText.h1.copyWith(fontSize: 25)),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '노령·투병 중인 아이와의 남은 시간에 집중하실 수 있도록, 필요한 것들을 미리 정리해 드려요.',
                    style: AppText.body.copyWith(color: AppColors.soft, fontSize: 14.5),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(children: [
                    const Icon(Icons.fact_check_outlined, size: 16, color: AppColors.orange500),
                    const SizedBox(width: 6),
                    Text('준비 체크리스트', style: AppText.bodyStrong.copyWith(fontSize: 14)),
                  ]),
                  const SizedBox(height: AppSpacing.sm),
                  for (int i = 0; i < _checks.length; i++)
                    _CheckItem(
                      label: _checks[i].label,
                      done: _checks[i].done,
                      onTap: () => setState(() => _checks[i] =
                          (label: _checks[i].label, done: !_checks[i].done)),
                    ),
                  const SizedBox(height: AppSpacing.md),
                  const _PreEstimate(),
                  const SizedBox(height: AppSpacing.sm),
                  _Card(child: Row(
                    children: [
                      const Icon(Icons.notifications_none, size: 22, color: AppColors.orange500),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('정기 케어 알림', style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                          SizedBox(height: 2),
                          Text('건강 변화 체크와 마음 준비를 부담 없이 도와드려요.',
                              style: TextStyle(fontSize: 12.5, color: AppColors.faint)),
                        ],
                      )),
                    ],
                  )),
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '내 아이 정보 저장하기',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사전 준비 정보를 저장했어요.')),
                  );
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(Routes.homeShell));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem({required this.label, required this.done, required this.onTap});
  final String label;
  final bool done;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          decoration: BoxDecoration(
            color: done ? AppColors.okWash : AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: done ? null : const [BoxShadow(
              color: Color.fromRGBO(58, 30, 12, 0.05), offset: Offset(0, 1), blurRadius: 2)],
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: done ? AppColors.ok : AppColors.card,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: done ? AppColors.ok : AppColors.line2, width: 1.5),
                ),
                child: done
                    ? const Icon(Icons.check, size: 15, color: AppColors.onOrange)
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: AppText.body.copyWith(
                fontSize: 14,
                color: done ? AppColors.soft : AppColors.ink,
              ))),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreEstimate extends StatelessWidget {
  const _PreEstimate();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.orangeWash,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('사전 확정 견적', style: AppText.eyebrow),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('보리 · 중형(5~15kg) 기준',
                  style: AppText.body.copyWith(fontSize: 13.5, color: AppColors.soft)),
              Text('35.2만원~', style: AppText.monoNum.copyWith(
                  fontSize: 18, color: AppColors.orange600)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_outline, size: 15, color: AppColors.orange500),
              const SizedBox(width: 6),
              Expanded(child: Text('지금 견적을 저장하면 가격이 오르기 전 금액으로 지켜드려요.',
                  style: AppText.caption.copyWith(color: AppColors.soft, height: 1.5))),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

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
      child: child,
    );
  }
}
