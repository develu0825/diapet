import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';

/// 천 단위 콤마(예: 1203 → "1,203").
String _grp(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

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

  final _picker = ImagePicker();
  final List<File> _photos = []; // 갤러리에서 고른 추모 사진들(스와이프로 넘김)

  int get _candleCount => _candleLit ? 1204 : 1203;

  Future<void> _addPhotos() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isNotEmpty && mounted) {
      setState(() => _photos.addAll(picked.map((x) => File(x.path))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, 6),
          child: Row(children: [
            Image.asset(AppAssets.logoDiapet, height: 27),
            const Spacer(),
            // 화면 오른쪽 상단: 추모 사진 추가(여러 장 선택).
            _AddPhotoButton(onTap: _addPhotos),
          ]),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xl),
            children: [
              Text('추모 공간', style: AppText.h2),
              const SizedBox(height: AppSpacing.md),
              _MemorialHero(photos: _photos),
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
  const _MemorialHero({required this.photos});

  final List<File> photos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 여러 장의 폴라로이드를 넘겨보는 캐러셀.
        _PolaroidCarousel(photos: photos),
        const SizedBox(height: 18),
        Text('보리를 기억하는 공간', style: AppText.h1.copyWith(fontSize: 24)),
        const SizedBox(height: 4),
        Text('함께한 15년 · 언제나 곁에 있을게',
            style: AppText.body.copyWith(fontSize: 14, color: AppColors.soft)),
      ],
    );
  }
}

/// 여러 장의 폴라로이드를 좌우로 넘겨보는 캐러셀 — 옆 사진이 살짝 보이고
/// 각 장이 조금씩 다른 각도로 기울어 사진 더미를 넘기는 느낌.
class _PolaroidCarousel extends StatefulWidget {
  const _PolaroidCarousel({required this.photos});
  final List<File> photos;

  @override
  State<_PolaroidCarousel> createState() => _PolaroidCarouselState();
}

class _PolaroidCarouselState extends State<_PolaroidCarousel> {
  final _controller = PageController(viewportFraction: 0.82);
  int _index = 0;

  // 폴라로이드마다 살짝 다른 기울기(흩어놓은 사진 느낌).
  static const _angles = [-0.045, 0.028, -0.018, 0.038, -0.03, 0.02];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    final count = photos.isEmpty ? 1 : photos.length;
    final current = _index.clamp(0, count - 1);

    return Column(
      children: [
        SizedBox(
          height: 346,
          child: PageView.builder(
            controller: _controller,
            itemCount: count,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => Center(
              child: _PolaroidCard(
                image: photos.isEmpty
                    ? AssetImage(AppAssets.petRest)
                    : FileImage(photos[i]),
                angle: _angles[i % _angles.length],
              ),
            ),
          ),
        ),
        if (count > 1) ...[
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < count; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == current ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == current ? AppColors.orange500 : AppColors.line2,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 폴라로이드 한 장 — 흰 프레임 + 사진 + 캡션.
class _PolaroidCard extends StatelessWidget {
  const _PolaroidCard({required this.image, required this.angle});
  final ImageProvider image;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        // 폴라로이드: 사방 얇은 테두리 + 두꺼운 하단 여백.
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [BoxShadow(
            color: Color.fromRGBO(58, 30, 12, 0.5),
            offset: Offset(0, 16), blurRadius: 34, spreadRadius: -16)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image(image: image, width: 200, height: 236, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text('보리 · 2011–2026', style: AppText.caption.copyWith(
                fontSize: 13, color: AppColors.soft, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// 화면 오른쪽 상단의 사진 추가 버튼(회색) — 갤러리에서 여러 장 선택.
class _AddPhotoButton extends StatelessWidget {
  const _AddPhotoButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColors.line2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_a_photo_outlined, size: 16, color: AppColors.soft),
            const SizedBox(width: 6),
            Text('사진 추가', style: AppText.caption.copyWith(
                color: AppColors.soft, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
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
            const Text('🕯️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: AppSpacing.xs),
            Flexible(child: Text(
              lit
                  ? '촛불을 켰어요 · ${_grp(count)}명이 함께'
                  : '촛불 켜기 · ${_grp(count)}명이 함께 기억해요',
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
          backgroundColor: AppColors.orangeWash,
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
