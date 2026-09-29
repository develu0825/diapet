import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../models/booking_draft.dart';
import '../models/vendor.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/screen_bar.dart';
import '../widgets/sticky_cta.dart';

class _Package {
  const _Package(this.name, this.base, this.priceLabel, this.desc, {this.tag, this.term});
  final String name;
  final int base;
  final String priceLabel;
  final String desc;
  final String? tag; // 예: "가장 많이 선택"
  final (String, String)? term; // 용어 도움말(제목, 설명)
}

/// 업체 상세 (s-detail) — 패키지 선택 후 예약 진입. 강매 없는 확정가 강조.
class VendorDetailScreen extends StatefulWidget {
  const VendorDetailScreen({super.key, required this.vendor});

  final Vendor vendor;

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  int _selected = 0;

  static const _packages = [
    _Package('기본', 220000, '22.0만', '개별 화장 · 유골함 · 부가세 포함',
        term: ('개별 화장', '한 마리만 단독으로 화장하는 방식이에요. 유골을 온전히 받으실 수 있어요.')),
    _Package('추모식 포함', 275000, '27.5만', '기본 + 추모실·추모식',
        tag: '가장 많이 선택',
        term: ('추모식', '떠나보내기 전, 추모실에서 갖는 마지막 인사 의식이에요.')),
    _Package('프리미엄', 390000, '39.0만', '추모식 + 봉안·수목장 안내 + 고급 유골함',
        term: ('봉안·수목장', '유골을 봉안당에 모시거나, 나무 아래 묻는 자연장이에요.')),
  ];

  void _showTerm((String, String) term) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(term.$1, style: AppText.h3),
            const SizedBox(height: AppSpacing.xs),
            Text(term.$2, style: AppText.body.copyWith(color: AppColors.soft)),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ScreenBar(title: vendor.name),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      AppBadge(
                        label: '허가 ${vendor.licenseNo ?? '검증'}',
                        variant: AppBadgeVariant.ok,
                        icon: Icons.check,
                      ),
                      const AppBadge(label: '전 과정 참관', variant: AppBadgeVariant.watch),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('패키지 선택', style: AppText.eyebrow),
                  const SizedBox(height: AppSpacing.xs),
                  for (int i = 0; i < _packages.length; i++)
                    _PackageCard(
                      package: _packages[i],
                      selected: i == _selected,
                      onTap: () => setState(() => _selected = i),
                      onTerm: _showTerm,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.check, size: 17, color: AppColors.ok),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text('표시 금액 그대로 청구돼요. 현장 추가금·강매 없음.',
                            style: AppText.caption.copyWith(color: AppColors.ok, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  if (vendor.phone != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    _CallRow(phone: vendor.phone!),
                  ],
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '예약하기',
                trailingIcon: Icons.arrow_forward,
                onPressed: () {
                  final pkg = _packages[_selected];
                  Navigator.of(context).pushNamed(
                    Routes.booking,
                    arguments: BookingDraft(
                      vendor: vendor,
                      packageName: pkg.name,
                      base: pkg.base,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.selected,
    required this.onTap,
    required this.onTerm,
  });

  final _Package package;
  final bool selected;
  final VoidCallback onTap;
  final void Function((String, String)) onTerm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AppColors.orangeWash : AppColors.card,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected ? AppColors.orange500 : AppColors.line2,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (package.tag != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.orange500,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(package.tag!, style: const TextStyle(
                      fontSize: 10.5, fontWeight: FontWeight.w800, color: AppColors.onOrange)),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(package.name, style: AppText.h3),
                  Text(package.priceLabel, style: AppText.monoNum.copyWith(
                      fontSize: 17, color: AppColors.orange600)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Flexible(child: Text(package.desc, style: AppText.caption.copyWith(color: AppColors.soft))),
                  if (package.term != null)
                    GestureDetector(
                      onTap: () => onTerm(package.term!),
                      child: Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 16,
                        height: 16,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.line, shape: BoxShape.circle),
                        child: const Text('?', style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.soft)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallRow extends StatelessWidget {
  const _CallRow({required this.phone});
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.line2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.call_outlined, size: 20, color: AppColors.orange500),
          const SizedBox(width: AppSpacing.sm),
          Text('전화 문의', style: AppText.bodyStrong),
          const Spacer(),
          Text(phone, style: AppText.body.copyWith(color: AppColors.soft)),
        ],
      ),
    );
  }
}
