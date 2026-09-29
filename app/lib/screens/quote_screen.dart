import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/estimate_banner.dart';
import '../widgets/screen_bar.dart';
import '../widgets/segmented_options.dart';
import '../widgets/sticky_cta.dart';

/// 견적 확인 (s-quote) — 몇 가지 입력으로 부가세 포함 확정가를 미리 보여준다.
class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  int _species = 0;
  int _weight = 0;
  int _region = 0;
  int _memorial = 0;

  static const _weightBase = [200000, 320000, 480000];
  static const _memorialAdd = [0, 50000];

  String get _estimate {
    final total = _weightBase[_weight] + _memorialAdd[_memorial];
    return (total / 10000).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenBar(title: '견적 확인', step: '1 / 2'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                children: [
                  Text.rich(
                    TextSpan(
                      style: AppText.body.copyWith(color: AppColors.soft),
                      children: const [
                        TextSpan(text: '몇 가지만 알려주시면 '),
                        TextSpan(text: '부가세 포함 확정가', style: TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.ink)),
                        TextSpan(text: '를 바로 보여드려요.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Field(
                    label: '어떤 아이인가요?',
                    child: SegmentedOptions(
                      options: const [
                        SegmentOption('강아지'),
                        SegmentOption('고양이'),
                        SegmentOption('그 외'),
                      ],
                      selectedIndex: _species,
                      onChanged: (i) => setState(() => _species = i),
                    ),
                  ),
                  _Field(
                    label: '몸무게',
                    sub: '· 화장 비용의 기준이 됩니다',
                    child: SegmentedOptions(
                      options: const [
                        SegmentOption('~5kg', sub: '소형'),
                        SegmentOption('5~15kg', sub: '중형'),
                        SegmentOption('15kg~', sub: '대형'),
                      ],
                      selectedIndex: _weight,
                      onChanged: (i) => setState(() => _weight = i),
                    ),
                  ),
                  _Field(
                    label: '지역',
                    child: SegmentedOptions(
                      options: const [
                        SegmentOption('서울·경기'),
                        SegmentOption('인천'),
                        SegmentOption('그 외'),
                      ],
                      selectedIndex: _region,
                      onChanged: (i) => setState(() => _region = i),
                    ),
                  ),
                  _Field(
                    label: '추모식',
                    sub: '· 선택',
                    child: SegmentedOptions(
                      options: const [
                        SegmentOption('기본 화장'),
                        SegmentOption('추모식 포함', sub: '+5만'),
                      ],
                      selectedIndex: _memorial,
                      onChanged: (i) => setState(() => _memorial = i),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  EstimateBanner(value: _estimate),
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '장례식장 3곳 보기',
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

class _Field extends StatelessWidget {
  const _Field({required this.label, this.sub, required this.child});
  final String label;
  final String? sub;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: AppText.bodyStrong.copyWith(fontSize: 14),
              children: [
                TextSpan(text: label),
                if (sub != null)
                  TextSpan(text: ' $sub', style: AppText.caption.copyWith(
                    color: AppColors.faint, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}
