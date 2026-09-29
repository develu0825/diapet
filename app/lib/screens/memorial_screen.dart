import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';

/// 추모 공간 (s-memorial) — 키프세이크형 추모 카드, 촛불, 기일 알림, 방명록, QR.
///
/// DESIGN.md: 추모 컴포넌트는 "기능 카드"가 아니라 기억의 물건처럼. 따뜻한 톤 유지.
class MemorialScreen extends StatefulWidget {
  const MemorialScreen({super.key});

  @override
  State<MemorialScreen> createState() => _MemorialScreenState();
}

class _MemorialScreenState extends State<MemorialScreen> {
  bool _candleLit = false;
  bool _anniversaryAlarm = true;
  bool _shared = false;

  int get _candleCount => _candleLit ? 1204 : 1203;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 6),
          child: Row(children: [Image.asset(AppAssets.logoDiapet, height: 27)]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xl),
            children: [
              Text('추모 공간', style: AppText.h2),
              const SizedBox(height: AppSpacing.md),
              const _MemorialHero(),
              const SizedBox(height: AppSpacing.md),
              _Candle(
                lit: _candleLit,
                count: _candleCount,
                onTap: () => setState(() => _candleLit = true),
              ),
              const SizedBox(height: AppSpacing.sm),
              _Card(child: Row(
                children: [
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('기일 알림', style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink)),
                      SizedBox(height: 2),
                      Text('2027년 3월 14일 · 카톡으로 알려드려요',
                          style: TextStyle(fontSize: 12.5, color: AppColors.soft)),
                    ],
                  )),
                  Switch(
                    value: _anniversaryAlarm,
                    activeThumbColor: AppColors.onOrange,
                    activeTrackColor: AppColors.orange500,
                    onChanged: (v) => setState(() => _anniversaryAlarm = v),
                  ),
                ],
              )),
              _Card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('추모 메시지', style: AppText.eyebrow),
                  const SizedBox(height: AppSpacing.sm),
                  const _Guest(initial: '엄', who: '엄마', msg: '우리 보리, 무지개다리 건너서 아프지 말고 뛰어놀아.'),
                  const SizedBox(height: AppSpacing.sm),
                  const _Guest(initial: '이', who: '이모', msg: '보리야 이모가 많이 사랑했어. 편히 쉬어.'),
                ],
              )),
              _Card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('QR 추모석', style: AppText.eyebrow),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          border: Border.all(color: AppColors.line2),
                        ),
                        child: const Icon(Icons.qr_code_2, size: 52, color: AppColors.ink),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('유골함·추모석에 새겨진 QR', style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text('스캔하면 이 추모 공간이 열려요. 가족 누구나 함께 기억할 수 있어요.',
                              style: TextStyle(fontSize: 12.5, color: AppColors.soft, height: 1.5)),
                        ],
                      )),
                    ],
                  ),
                ],
              )),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: _shared ? '공유 링크가 복사됐어요 ✓' : '추모 공간 공유하기',
                onPressed: () => setState(() => _shared = true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MemorialHero extends StatelessWidget {
  const _MemorialHero();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 폴라로이드형 프레임 — 그라데이션 플레이스홀더 대신 실사진.
        Transform.rotate(
          angle: -0.043,
          child: Container(
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [BoxShadow(
                color: Color.fromRGBO(58, 30, 12, 0.4),
                offset: Offset(0, 10), blurRadius: 22, spreadRadius: -12)],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.asset(AppAssets.petBori,
                      width: 80, height: 66, fit: BoxFit.cover),
                ),
                const SizedBox(height: 6),
                Text('보리 · 2011–2026', style: AppText.caption.copyWith(
                    fontSize: 10, color: AppColors.soft)),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('보리를 기억하는 공간', style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.2)),
            SizedBox(height: 4),
            Text('함께한 15년 · 언제나 곁에 있을게',
                style: TextStyle(fontSize: 12.5, color: AppColors.soft)),
          ],
        )),
      ],
    );
  }
}

class _Candle extends StatelessWidget {
  const _Candle({required this.lit, required this.count, required this.onTap});
  final bool lit;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.orangeWash,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🕯️', style: TextStyle(fontSize: 18)),
            const SizedBox(width: AppSpacing.xs),
            Flexible(child: Text(
              lit ? '촛불을 켰어요 · $count명이 함께' : '촛불 켜기 · $count명이 함께 기억해요',
              style: AppText.bodyStrong.copyWith(color: AppColors.orange600, fontSize: 14),
            )),
          ],
        ),
      ),
    );
  }
}

class _Guest extends StatelessWidget {
  const _Guest({required this.initial, required this.who, required this.msg});
  final String initial;
  final String who;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.orangeTint,
          child: Text(initial, style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.orange600)),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(who, style: AppText.bodyStrong.copyWith(fontSize: 13)),
            const SizedBox(height: 2),
            Text(msg, style: AppText.body.copyWith(fontSize: 13.5, color: AppColors.soft)),
          ],
        )),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
