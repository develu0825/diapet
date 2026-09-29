import 'package:flutter/material.dart';
import '../app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_tab_bar.dart';

/// 마이페이지 (s-my) — 내 아이 / 내 정보 / 설정 서브탭.
class MyScreen extends StatefulWidget {
  const MyScreen({super.key, this.onNavigateTab});

  /// 이력에서 추모 공간 등으로 이동할 때 탭 전환 위임.
  final ValueChanged<MainTab>? onNavigateTab;

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _tab = 0;
  int _selectedPet = 0;
  bool _kakaoAlarm = true;
  bool _anniversary = true;
  bool _events = false;

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _Hero(),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SegTabs(
                current: _tab,
                onChanged: (i) => setState(() => _tab = i),
              ),
              const SizedBox(height: AppSpacing.md),
              switch (_tab) {
                0 => _PetsPane(
                    selectedPet: _selectedPet,
                    onSelectPet: (i) => setState(() => _selectedPet = i),
                    onHistory: _snack,
                    onMemorial: () => widget.onNavigateTab?.call(MainTab.memorial),
                    onHelp: _snack,
                  ),
                1 => _InfoPane(
                    kakao: _kakaoAlarm,
                    anniversary: _anniversary,
                    events: _events,
                    onKakao: (v) => setState(() => _kakaoAlarm = v),
                    onAnniversary: (v) => setState(() => _anniversary = v),
                    onEvents: (v) => setState(() => _events = v),
                    onRow: _snack,
                  ),
                _ => _SettingsPane(onRow: _snack),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 180),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.myHero),
          alignment: Alignment(1.0, 0.2),
          fit: BoxFit.contain,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.paper, Color(0x73FDFAF6), Color(0x00FDFAF6)],
            stops: [0.32, 0.52, 0.76],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 14, AppSpacing.lg, AppSpacing.md),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppAssets.logoDiapet, height: 26),
              const SizedBox(height: AppSpacing.lg),
              Text.rich(
                TextSpan(
                  style: AppText.h1.copyWith(fontSize: 22, height: 1.35),
                  children: const [
                    TextSpan(text: '다연님,\n'),
                    TextSpan(text: '보리', style: TextStyle(color: AppColors.orange500)),
                    TextSpan(text: '와 함께라서\n언제나 행복했어요.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegTabs extends StatelessWidget {
  const _SegTabs({required this.current, required this.onChanged});
  final int current;
  final ValueChanged<int> onChanged;

  static const _labels = ['내 아이', '내 정보', '설정'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.orangeWash,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: i == current ? AppColors.card : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: i == current ? const [BoxShadow(
                      color: Color.fromRGBO(58, 30, 12, 0.08),
                      offset: Offset(0, 1), blurRadius: 4)] : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(_labels[i], style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: i == current ? AppColors.orange600 : AppColors.soft,
                  )),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── 내 아이 ──────────────────────────────────────────────
class _PetsPane extends StatelessWidget {
  const _PetsPane({
    required this.selectedPet,
    required this.onSelectPet,
    required this.onHistory,
    required this.onMemorial,
    required this.onHelp,
  });

  final int selectedPet;
  final ValueChanged<int> onSelectPet;
  final ValueChanged<String> onHistory;
  final VoidCallback onMemorial;
  final ValueChanged<String> onHelp;

  static const _pets = [
    (name: '보리', pic: AppAssets.petBori, days: '함께한 지 1,240일',
     dates: '2023. 4. 12. ~ 2026. 8. 30.', meta: '강아지 · 중형(5~15kg) · 서울'),
    (name: '나비', pic: AppAssets.petNabi, days: '함께한 지 2,980일',
     dates: '2018. 3. 2. ~ 2026. 5. 10.', meta: '고양이 · 소형(~5kg) · 서울'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _pets.length; i++)
          _PetCard(
            name: _pets[i].name,
            pic: _pets[i].pic,
            days: _pets[i].days,
            dates: _pets[i].dates,
            meta: _pets[i].meta,
            selected: i == selectedPet,
            onTap: () => onSelectPet(i),
          ),
        _AddPet(onTap: () => onHelp('새로운 아이 등록은 곧 제공됩니다.')),
        const SizedBox(height: AppSpacing.lg),
        const _SectionTitle('최근 이용 내역'),
        _HistRow(icon: Icons.event_note_outlined, color: AppColors.orange500,
            title: '장례 예약', sub: '2026년 8월 30일 · 하늘펫 동물병원',
            onTap: () => onHistory('예약 정보를 불러왔어요.')),
        _HistRow(icon: Icons.favorite_border, color: const Color(0xFF8578CE),
            title: '추모 공간 생성', sub: '2026년 9월 1일', onTap: onMemorial),
        _HistRow(icon: Icons.description_outlined, color: const Color(0xFF5B93C9),
            title: '동물등록 말소 안내 확인', sub: '2026년 9월 2일',
            onTap: () => onHistory('말소 신고 안내를 보내드렸어요.')),
        const SizedBox(height: AppSpacing.lg),
        const _SectionTitle('도움이 필요하신가요?'),
        _HelpGrid(onHelp: onHelp),
        const SizedBox(height: AppSpacing.lg),
        const _QuoteBand(),
      ],
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.name, required this.pic, required this.days,
    required this.dates, required this.meta, required this.selected, required this.onTap,
  });
  final String name, pic, days, dates, meta;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AppColors.orangeWash : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: selected ? Border.all(color: AppColors.orange300) : null,
            boxShadow: selected ? null : const [BoxShadow(
              color: Color.fromRGBO(58, 30, 12, 0.05), offset: Offset(0, 1), blurRadius: 2)],
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Image.asset(pic, width: 54, height: 54, fit: BoxFit.cover),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(name, style: AppText.h3.copyWith(fontSize: 15)),
                    const SizedBox(width: 6),
                    Text(days, style: AppText.caption.copyWith(color: AppColors.faint)),
                  ]),
                  const SizedBox(height: 2),
                  Text(dates, style: AppText.caption.copyWith(color: AppColors.soft)),
                  Text(meta, style: AppText.caption.copyWith(color: AppColors.faint)),
                ],
              )),
              if (selected)
                const Icon(Icons.check_circle, size: 20, color: AppColors.orange500)
              else
                const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPet extends StatelessWidget {
  const _AddPet({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.line2),
        ),
        child: Row(children: [
          Container(
            width: 30, height: 30, alignment: Alignment.center,
            decoration: const BoxDecoration(color: AppColors.orangeWash, shape: BoxShape.circle),
            child: const Icon(Icons.add, size: 18, color: AppColors.orange600),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text('다른 아이 추가하기', style: AppText.bodyStrong.copyWith(fontSize: 14))),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
        ]),
      ),
    );
  }
}

class _HistRow extends StatelessWidget {
  const _HistRow({required this.icon, required this.color,
      required this.title, required this.sub, required this.onTap});
  final IconData icon;
  final Color color;
  final String title, sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(children: [
          Container(
            width: 38, height: 38, alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.bodyStrong.copyWith(fontSize: 14)),
              Text(sub, style: AppText.caption.copyWith(color: AppColors.faint)),
            ],
          )),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
        ]),
      ),
    );
  }
}

class _HelpGrid extends StatelessWidget {
  const _HelpGrid({required this.onHelp});
  final ValueChanged<String> onHelp;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.support_agent, '펫로스 상담', '전문 상담사와 대화하기'),
      (Icons.description_outlined, '사후 안내', '말소 신고, 필요 서류 등'),
      (Icons.menu_book_outlined, '자주 묻는 질문', '궁금한 점을 확인해보세요'),
      (Icons.chat_bubble_outline, '의견 보내기', '더 나은 서비스를 위해'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.5,
      children: [
        for (final (icon, title, desc) in items)
          InkWell(
            onTap: () => onHelp('$title · 준비 중이에요.'),
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: const [BoxShadow(
                  color: Color.fromRGBO(58, 30, 12, 0.05), offset: Offset(0, 1), blurRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(children: [
                    Icon(icon, size: 18, color: AppColors.orange500),
                    const SizedBox(width: 6),
                    Flexible(child: Text(title, style: AppText.bodyStrong.copyWith(fontSize: 13))),
                  ]),
                  const SizedBox(height: 4),
                  Text(desc, style: AppText.caption.copyWith(
                      color: AppColors.faint, fontSize: 11)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _QuoteBand extends StatelessWidget {
  const _QuoteBand();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.orangeWash,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          const Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('함께한 시간이\n언제나 따뜻한 기억으로 남기를.', style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w800, height: 1.4, color: AppColors.ink)),
              SizedBox(height: 6),
              Text('Diapet이 늘 곁에 있을게요.', style: TextStyle(
                  fontSize: 12.5, color: AppColors.soft)),
            ],
          )),
          Image.asset(AppAssets.myFlower, width: 64),
        ],
      ),
    );
  }
}

// ── 내 정보 ──────────────────────────────────────────────
class _InfoPane extends StatelessWidget {
  const _InfoPane({
    required this.kakao, required this.anniversary, required this.events,
    required this.onKakao, required this.onAnniversary, required this.onEvents,
    required this.onRow,
  });
  final bool kakao, anniversary, events;
  final ValueChanged<bool> onKakao, onAnniversary, onEvents;
  final ValueChanged<String> onRow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('내 정보'),
        _InfoCard(children: [
          _InfoRow('이름', '김다연', onTap: () => onRow('이름 수정')),
          _InfoRow('연락처', '010-1234-5678', onTap: () => onRow('연락처 수정')),
          _InfoRow('지역', '서울', onTap: () => onRow('지역 선택')),
          _InfoRow('이메일', 'dayeon@diapet.kr', onTap: () => onRow('이메일 수정')),
        ]),
        const SizedBox(height: AppSpacing.md),
        const _SectionTitle('알림'),
        _InfoCard(children: [
          _ToggleRow('카카오 알림톡', kakao, onKakao),
          _ToggleRow('기일 알림', anniversary, onAnniversary),
          _ToggleRow('이벤트·소식', events, onEvents),
        ]),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.k, this.v, {required this.onTap});
  final String k, v;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(children: [
          SizedBox(width: 64, child: Text(k, style: AppText.body.copyWith(color: AppColors.faint))),
          Expanded(child: Text(v, style: AppText.bodyStrong.copyWith(fontSize: 14))),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
        ]),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow(this.label, this.value, this.onChanged);
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Expanded(child: Text(label, style: AppText.body.copyWith(fontSize: 14))),
        Switch(
          value: value,
          activeThumbColor: AppColors.onOrange,
          activeTrackColor: AppColors.orange500,
          onChanged: onChanged,
        ),
      ]),
    );
  }
}

// ── 설정 ────────────────────────────────────────────────
class _SettingsPane extends StatelessWidget {
  const _SettingsPane({required this.onRow});
  final ValueChanged<String> onRow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('설정'),
        _InfoCard(children: [
          for (final label in const ['공지사항', '자주 묻는 질문', '서비스 이용약관', '개인정보 처리방침'])
            InkWell(
              onTap: () => onRow(label),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(children: [
                  Expanded(child: Text(label, style: AppText.body.copyWith(fontSize: 14))),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.faint),
                ]),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Row(children: [
              Expanded(child: Text('버전 정보', style: AppText.body.copyWith(fontSize: 14))),
              Text('v1.0.0', style: AppText.caption.copyWith(color: AppColors.faint)),
            ]),
          ),
          InkWell(
            onTap: () => onRow('로그아웃'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Text('로그아웃', style: AppText.body.copyWith(
                  fontSize: 14, color: AppColors.danger)),
            ),
          ),
        ]),
      ],
    );
  }
}

// ── 공통 ────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(title, style: AppText.h3.copyWith(fontSize: 15)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(
          color: Color.fromRGBO(58, 30, 12, 0.05), offset: Offset(0, 1), blurRadius: 2)],
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
      child: Column(children: children),
    );
  }
}
