import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../app_routes.dart';
import '../models/vendor.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/screen_bar.dart';
import '../widgets/vendor_card.dart';

/// 장례식장 비교 (s-list) — 검증된 업체를 확정가로 비교.
///
/// 홈 하단 '장례' 탭 본문으로도, 견적·긴급에서 푸시로도 쓰인다([showBack]).
class VendorListScreen extends StatefulWidget {
  const VendorListScreen({super.key, this.showBack = false});

  final bool showBack;

  @override
  State<VendorListScreen> createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  String _query = '';

  List<Vendor> get _filtered {
    if (_query.trim().isEmpty) return Vendor.seed;
    final q = _query.trim();
    return Vendor.seed
        .where((v) => v.name.contains(q) || v.location.contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final content = ListView(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xl),
      children: [
        Text('가까운 장례식장', style: AppText.h2),
        const SizedBox(height: AppSpacing.sm),
        _SearchBar(onChanged: (v) => setState(() => _query = v)),
        const SizedBox(height: AppSpacing.sm),
        Text.rich(
          TextSpan(
            style: AppText.caption.copyWith(color: AppColors.soft),
            children: const [
              TextSpan(text: '보리 · 중형(5~15kg)', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
              TextSpan(text: ' 기준 확정가 · 모두 '),
              TextSpan(text: '정부 등록 검증', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ok)),
              TextSpan(text: ' 완료'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final v in _filtered) ...[
          VendorCard(
            vendor: v,
            onTap: () => Navigator.of(context)
                .pushNamed(Routes.vendorDetail, arguments: v),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        const SizedBox(height: AppSpacing.xs),
        Text(
          '🔒 정식 등록되지 않은 업체는 노출되지 않아요.\n모든 업체의 허가번호를 실시간 대조합니다.',
          style: AppText.caption.copyWith(color: AppColors.faint, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );

    return Column(
      children: [
        if (widget.showBack)
          const ScreenBar(title: '가까운 장례식장')
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 6),
            child: Row(children: [Image.asset(AppAssets.logoDiapet, height: 27)]),
          ),
        Expanded(child: content),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: AppText.body,
      decoration: InputDecoration(
        hintText: '장례식장·지역 검색',
        hintStyle: AppText.body.copyWith(color: AppColors.faint),
        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.faint),
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.line2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.orange500, width: 1.5),
        ),
      ),
    );
  }
}
