import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/sticky_cta.dart';

/// 긴급 대응 (s-crisis) — "지금 이대로 따라 하세요" 코드 타임라인.
///
/// 위기 화면일수록 요소를 덜어내고 동행형 카피로. 재촉·세일 문구 금지.
class CrisisScreen extends StatelessWidget {
  const CrisisScreen({super.key});

  static const _steps = [
    (
      '편안하게 눕혀 주세요',
      '부드러운 수건·담요 위에 옆으로. 사후 1~2시간 안에 눈을 살며시 감겨주세요.',
      AppAssets.crisisIll1,
    ),
    (
      '서늘한 곳에 안치',
      '직사광선을 피하고, 여름엔 배 쪽에 아이스팩(직접 닿지 않게)을 대주세요.',
      AppAssets.crisisIll2,
    ),
    (
      '함께 보낼 것을 챙겨요',
      '좋아하던 담요·장난감, 생전 사진 몇 장. 마지막 인사를 준비하는 시간입니다.',
      AppAssets.crisisIll3,
    ),
    (
      '믿을 수 있는 장례식장을 정해요',
      '가까운 정식 허가 업체를 확정 견적으로 바로 비교·예약할 수 있어요.',
      AppAssets.crisisIll4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _CrisisBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, 4, AppSpacing.lg, AppSpacing.md),
                children: [
                  Text('지금 이대로 따라 하세요',
                      style: AppText.h1.copyWith(height: 1.25)),
                  const SizedBox(height: 9),
                  Text.rich(
                    TextSpan(
                      style: AppText.body.copyWith(color: AppColors.soft, fontSize: 14),
                      children: const [
                        TextSpan(text: '서두르지 않아도 괜찮습니다. 아이는 보통 '),
                        TextSpan(text: '24~48시간', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                        TextSpan(text: ' 안치가 가능해요.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('지금도, 충분히 잘하고 있어요.',
                      style: AppText.bodyStrong.copyWith(
                          color: AppColors.orange500, fontSize: 13)),
                  const SizedBox(height: AppSpacing.lg),
                  for (int i = 0; i < _steps.length; i++)
                    _TimelineStep(
                      number: i + 1,
                      title: _steps[i].$1,
                      desc: _steps[i].$2,
                      illustration: _steps[i].$3,
                      isLast: i == _steps.length - 1,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  const _NightBox(),
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '이제 장례식장 찾기',
                trailingIcon: Icons.arrow_forward,
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.vendorList),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrisisBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 4, AppSpacing.lg, AppSpacing.sm),
      child: Row(
        children: [
          _BackButton(onTap: () => Navigator.of(context).maybePop()),
          Expanded(
            child: Center(child: Image.asset(AppAssets.logoDiapet, height: 22)),
          ),
          const Text('1 / 1', style: TextStyle(
            fontFamily: AppText.monoFamily, fontSize: 11, color: AppColors.faint)),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.line2),
        ),
        child: const Icon(Icons.chevron_left, size: 20, color: AppColors.ink),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.number,
    required this.title,
    required this.desc,
    required this.illustration,
    required this.isLast,
  });

  final int number;
  final String title;
  final String desc;
  final String illustration;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.orangeWash,
                  shape: BoxShape.circle,
                ),
                child: Text('$number', style: const TextStyle(
                  fontFamily: AppText.monoFamily,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.orange600,
                )),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: AppColors.line2)),
            ],
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppElevation.e1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: AppText.h3.copyWith(fontSize: 15)),
                          const SizedBox(height: 4),
                          Text(desc, style: AppText.caption.copyWith(
                            fontSize: 12, color: AppColors.soft, height: 1.5)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(illustration, width: 64),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NightBox extends StatelessWidget {
  const _NightBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warnWash,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.nightlight_outlined, size: 15, color: AppColors.warn),
              const SizedBox(width: 6),
              Text('새벽·야간인가요?', style: AppText.bodyStrong.copyWith(
                fontSize: 13, color: AppColors.warn)),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              style: AppText.caption.copyWith(color: AppColors.soft, height: 1.5),
              children: const [
                TextSpan(text: '지금 예약해 두시면 '),
                TextSpan(text: '당일 오전', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                TextSpan(text: ' 첫 시간으로 잡아드려요. 24시간 상담도 연결됩니다.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
