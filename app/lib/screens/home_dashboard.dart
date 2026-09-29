import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../app_routes.dart';
import '../theme/app_colors.dart';
import '../theme/app_elevation.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_tab_bar.dart';

/// 홈 대시보드 (s-home) — 앱의 허브.
///
/// 상단 로고+알림, 인사 히어로, 긴급 진입 ember CTA, 바로가기 그리드, 안심 카피.
class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key, required this.onNavigateTab});

  /// 하단 탭 전환(장례·추모 등)을 [HomeShell]에 위임.
  final ValueChanged<MainTab> onNavigateTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TopBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            children: [
              const _GreetingHero(),
              const SizedBox(height: AppSpacing.md),
              _EmberCta(
                onTap: () => Navigator.of(context).pushNamed(Routes.crisis),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('바로가기', style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              )),
              const SizedBox(height: AppSpacing.sm),
              _QuickGrid(
                onFuneral: () => onNavigateTab(MainTab.funeral),
                onMemorial: () => onNavigateTab(MainTab.memorial),
                onPreneed: () =>
                    Navigator.of(context).pushNamed(Routes.preneed),
                onCounseling: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('펫로스 상담은 준비 중이에요.')),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                '언제든, 다시 찾아주세요. Diapet이 함께할게요.',
                textAlign: TextAlign.center,
                style: AppText.caption.copyWith(color: AppColors.faint, height: 1.7),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 6),
      child: Row(
        children: [
          Image.asset(AppAssets.logoDiapet, height: 27),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, size: 23, color: AppColors.soft),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.ember,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GreetingHero extends StatelessWidget {
  const _GreetingHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppAssets.homeHero,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
          // 상단 paper 페이드 — 텍스트 가독 확보.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.paper, Color(0x66FDFAF6), Color(0x00FDFAF6)],
                stops: [0.1, 0.32, 0.55],
              ),
            ),
          ),
          // 하단 paper 페이드 — 다음 섹션과 seam 제거.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [AppColors.paper, Color(0x00FDFAF6)],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '지금,\n많이 힘드신가요?',
                  style: AppText.h1.copyWith(fontSize: 23, height: 1.3),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '혼자가 아니에요.\nDiapet이 차근차근 도와드릴게요.',
                  style: AppText.body.copyWith(color: AppColors.soft, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmberCta extends StatelessWidget {
  const _EmberCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppElevation.e3,
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('아이를 보내주려 해요', style: TextStyle(
                      color: AppColors.onOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1.3,
                    )),
                    SizedBox(height: 6),
                    Text('지금 무엇을 해야 하는지\n차근차근 안내해드릴게요.', style: TextStyle(
                      color: AppColors.onOrange,
                      fontSize: 13,
                      height: 1.5,
                    )),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.asset(
                  AppAssets.petRest,
                  width: 66,
                  height: 66,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid({
    required this.onFuneral,
    required this.onMemorial,
    required this.onPreneed,
    required this.onCounseling,
  });

  final VoidCallback onFuneral;
  final VoidCallback onMemorial;
  final VoidCallback onPreneed;
  final VoidCallback onCounseling;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      (_TileData(Icons.church_outlined, '장례 예약', const Color(0xFFF15A24)), onFuneral),
      (_TileData(Icons.event_note_outlined, '사전 준비', const Color(0xFF4E9E6A)), onPreneed),
      (_TileData(Icons.favorite_border, '추모 공간', const Color(0xFF8578CE)), onMemorial),
      (_TileData(Icons.chat_bubble_outline, '펫로스 상담', const Color(0xFF5B93C9)), onCounseling),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 18,
      crossAxisSpacing: 12,
      childAspectRatio: 3.4,
      children: [
        for (final (data, onTap) in tiles) _Tile(data: data, onTap: onTap),
      ],
    );
  }
}

class _TileData {
  const _TileData(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;
}

class _Tile extends StatelessWidget {
  const _Tile({required this.data, required this.onTap});
  final _TileData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(data.icon, size: 25, color: data.color),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              data.label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
