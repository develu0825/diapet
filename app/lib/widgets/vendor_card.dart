import 'package:flutter/material.dart';
import '../models/vendor.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_badge.dart';
import 'app_card.dart';

/// 업체 카드 — 이름·거리·확정가·검증 배지·별점. 탭하면 상세로.
class VendorCard extends StatelessWidget {
  const VendorCard({super.key, required this.vendor, this.onTap});

  final Vendor vendor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vendor.name, style: AppText.h3),
                    const SizedBox(height: 3),
                    Text('${vendor.location} · ${vendor.availability}',
                        style: AppText.caption.copyWith(color: AppColors.faint)),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(vendor.priceLabel, style: AppText.monoNum.copyWith(
                      fontSize: 17, color: AppColors.orange600)),
                  Text('부가세 포함', style: AppText.caption.copyWith(
                      fontSize: 10, color: AppColors.faint)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              const AppBadge(label: '등록 검증', variant: AppBadgeVariant.ok, icon: Icons.check),
              if (vendor.observation)
                const AppBadge(label: '참관 보장', variant: AppBadgeVariant.watch),
              if (vendor.noPushSelling)
                const AppBadge(label: '강매 없음', variant: AppBadgeVariant.gold),
            ],
          ),
          const SizedBox(height: 10),
          _Stars(rating: vendor.rating, reviews: vendor.reviews),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  const _Stars({required this.rating, required this.reviews});
  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Icon(i < full ? Icons.star : Icons.star_border,
              size: 13, color: AppColors.gold),
        const SizedBox(width: 5),
        Text('$rating · 후기 $reviews', style: AppText.caption.copyWith(
            color: AppColors.soft, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
