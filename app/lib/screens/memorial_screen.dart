import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../app_assets.dart';
import '../services/memorial_photo_store.dart';
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
  final _store = MemorialPhotoStore();
  final List<File> _photos = []; // 갤러리에서 고른 추모 사진들(스와이프로 넘김)

  int get _candleCount => _candleLit ? 1204 : 1203;

  @override
  void initState() {
    super.initState();
    _restorePhotos();
  }

  Future<void> _restorePhotos() async {
    final saved = await _store.load();
    if (saved.isNotEmpty && mounted) {
      setState(() => _photos
        ..clear()
        ..addAll(saved));
    }
  }

  Future<void> _addPhotos() async {
    final picked = await _picker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty) return;
    // 전용 폴더로 복사 후 경로를 저장(영속).
    final updated = await _store.addPicked(picked, _photos);
    if (mounted) {
      setState(() => _photos
        ..clear()
        ..addAll(updated));
    }
  }

  // 길게 눌러 여는 사진 관리(삭제·순서 변경) 시트.
  void _openManageSheet() {
    if (_photos.isEmpty) return;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => _ManagePhotosSheet(
        photos: _photos,
        onReorder: (oldIndex, newIndex) {
          setState(() {
            var ni = newIndex;
            if (ni > oldIndex) ni -= 1;
            _photos.insert(ni, _photos.removeAt(oldIndex));
          });
          _store.save(_photos);
        },
        onDelete: (index) {
          setState(() {
            final removed = _photos.removeAt(index);
            try {
              removed.deleteSync(); // 실제 파일도 삭제
            } catch (_) {}
          });
          _store.save(_photos);
        },
      ),
    );
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
              _MemorialHero(
                photos: _photos,
                onAddPhoto: _addPhotos,
                onManage: _openManageSheet,
              ),
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
  const _MemorialHero({
    required this.photos,
    required this.onAddPhoto,
    required this.onManage,
  });

  final List<File> photos;
  final VoidCallback onAddPhoto;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 여러 장의 폴라로이드를 겹쳐 넘겨보는 캐러셀.
        _PolaroidCarousel(
          photos: photos,
          onAddPhoto: onAddPhoto,
          onManage: onManage,
        ),
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
  const _PolaroidCarousel({
    required this.photos,
    required this.onAddPhoto,
    required this.onManage,
  });
  final List<File> photos;
  final VoidCallback onAddPhoto;
  final VoidCallback onManage;

  @override
  State<_PolaroidCarousel> createState() => _PolaroidCarouselState();
}

class _PolaroidCarouselState extends State<_PolaroidCarousel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  double _page = 0; // 연속 위치(소수 = 넘기는 중). 정수에 안착.
  double _from = 0, _to = 0;

  static const _dragUnit = 230.0; // 한 장 넘기는 데 필요한 드래그 거리
  static const _spacing = 64.0; // 겹친 카드 간 가로 간격(뒷 사진이 더 보이도록 넓힘)

  @override
  void initState() {
    super.initState();
    _anim.addListener(() {
      final t = Curves.easeOutCubic.transform(_anim.value);
      setState(() => _page = _from + (_to - _from) * t);
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _settle(double velocity) {
    var target = _page.round();
    if (velocity < -350) {
      target = _page.floor() + 1;
    } else if (velocity > 350) {
      target = _page.ceil() - 1;
    }
    _from = _page;
    _to = target.toDouble();
    _anim.forward(from: 0);
  }

  ImageProvider _img(List<File> photos, int i) =>
      photos.isEmpty ? AssetImage(AppAssets.petRest) : FileImage(photos[i]);

  Widget _stackCard(
    ImageProvider img, {
    required double dx,
    required double scale,
    required double angle,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.translate(
        offset: Offset(dx, 0),
        child: Transform.scale(
          scale: scale,
          child: _PolaroidCard(image: img, angle: angle),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    // 아직 사진이 없을 때: 추가를 권하는 빈 상태(동행형 톤).
    if (photos.isEmpty) {
      return _EmptyPolaroid(onTap: widget.onAddPhoto);
    }
    final count = photos.length;
    final base = _page.round();

    // 현재 위치 주변 카드를 연속 위치로 배치 → 드래그를 따라 부드럽게.
    final entries = <(int, double)>[]; // (정수 인덱스, 가운데 기준 상대 위치)
    for (var o = -3; o <= 3; o++) {
      final idx = base + o;
      final rel = idx - _page;
      if (rel.abs() >= 2.0) continue; // 2칸 밖은 안 그림(거기선 이미 투명)
      entries.add((idx, rel));
    }
    // 멀리 있는 것부터 그려서 가까운(가운데) 카드가 맨 위에 오게.
    entries.sort((a, b) => b.$2.abs().compareTo(a.$2.abs()));
    final cards = <Widget>[];
    for (final (idx, rel) in entries) {
      final photo = ((idx % count) + count) % count;
      final d = rel.abs();
      // 0~1칸: 뒤로 살짝 물러나며 또렷(뒷 사진 잘 보임)
      // 1~2칸: 점점 더 작아지고 투명해져 '스르륵' 사라짐(팝 없음)
      final near = d > 1 ? 1.0 : d;
      final far = d > 1 ? d - 1 : 0.0;
      final scale = 1 - 0.13 * near - 0.17 * far;
      final opacity = d <= 1 ? 1 - 0.06 * d : 0.94 * (2 - d);
      cards.add(_stackCard(
        _img(photos, photo),
        dx: rel * _spacing,
        scale: scale,
        angle: 0, // 기울이지 않고 정렬된 깔끔한 겹침
        opacity: opacity,
      ));
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: widget.onManage, // 길게 눌러 사진 관리(삭제·순서)
      onHorizontalDragStart: (_) => _anim.stop(),
      onHorizontalDragUpdate: (d) =>
          setState(() => _page -= d.primaryDelta! / _dragUnit),
      onHorizontalDragEnd: (d) => _settle(d.primaryVelocity ?? 0),
      child: SizedBox(
        height: 348,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: cards,
        ),
      ),
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
        // 폴라로이드: 사방 얇은 테두리 + 두꺼운 하단 여백. (그림자 없음)
        padding: const EdgeInsets.fromLTRB(13, 13, 13, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
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

/// 사진이 없을 때의 빈 폴라로이드 — 탭하면 사진 추가.
class _EmptyPolaroid extends StatelessWidget {
  const _EmptyPolaroid({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 348,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Transform.rotate(
            angle: -0.02,
            child: Container(
              padding: const EdgeInsets.fromLTRB(13, 13, 13, 22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 200,
                    height: 236,
                    decoration: BoxDecoration(
                      color: AppColors.paper,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: AppColors.line2),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_a_photo_outlined, size: 34, color: AppColors.faint),
                          SizedBox(height: 10),
                          Text('사진을 더해보세요', style: TextStyle(
                              fontSize: 13, color: AppColors.faint, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('소중한 순간을 모아두는 공간', style: AppText.caption.copyWith(
                      fontSize: 13, color: AppColors.soft, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 사진 관리 시트 — 삭제 + 드래그 핸들로 순서 변경(변경 즉시 저장).
class _ManagePhotosSheet extends StatefulWidget {
  const _ManagePhotosSheet({
    required this.photos,
    required this.onReorder,
    required this.onDelete,
  });

  final List<File> photos;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onDelete;

  @override
  State<_ManagePhotosSheet> createState() => _ManagePhotosSheetState();
}

class _ManagePhotosSheetState extends State<_ManagePhotosSheet> {
  @override
  Widget build(BuildContext context) {
    final photos = widget.photos;
    final maxH = MediaQuery.of(context).size.height * 0.55;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('사진 관리', style: AppText.h3),
                const Spacer(),
                Text('끌어서 순서 변경',
                    style: AppText.caption.copyWith(color: AppColors.faint)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (photos.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text('사진이 없어요',
                      style: AppText.body.copyWith(color: AppColors.faint)),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxH),
                child: ReorderableListView.builder(
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  // 드래그 중 강조: 각진 회색 그림자 대신 둥근 모서리 +
                  // 연한 주황 하이라이트 + 부드러운 주황빛 그림자.
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, _) {
                        final t = Curves.easeInOut.transform(animation.value);
                        return Material(
                          color: Colors.transparent,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: Color.lerp(
                                  Colors.white, AppColors.orangeWash, t),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.orange300
                                    .withValues(alpha: 0.8 * t),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(241, 90, 36, 0.28 * t),
                                  blurRadius: 18,
                                  offset: const Offset(0, 6),
                                  spreadRadius: -2,
                                ),
                              ],
                            ),
                            child: child,
                          ),
                        );
                      },
                    );
                  },
                  itemCount: photos.length,
                  onReorder: (o, n) {
                    widget.onReorder(o, n);
                    setState(() {});
                  },
                  itemBuilder: (context, i) {
                    final f = photos[i];
                    return Padding(
                      key: ValueKey(f.path),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(f,
                                width: 46, height: 46, fit: BoxFit.cover),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text('사진 ${i + 1}',
                                style: AppText.bodyStrong.copyWith(fontSize: 14)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: AppColors.danger),
                            onPressed: () {
                              widget.onDelete(i);
                              setState(() {});
                            },
                          ),
                          ReorderableDragStartListener(
                            index: i,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.drag_handle, color: AppColors.faint),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: '완료',
                variant: AppButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
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
