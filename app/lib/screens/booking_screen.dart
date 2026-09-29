import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../models/booking_draft.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/screen_bar.dart';
import '../widgets/sticky_cta.dart';
import '../widgets/time_slots.dart';

/// 예약 설정 (s-booking) — 날짜·시간·운구·참관 인원.
class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late String _date = widget.draft.date;
  late String _time = widget.draft.time;
  late bool _transport = widget.draft.transport;
  late int _viewers = widget.draft.viewers;

  static const _dates = ['오늘 8/30', '내일 8/31', '9/1(월)', '9/2(화)', '9/3(수)'];
  static const _slots = [
    TimeSlot('10:00', taken: true),
    TimeSlot('13:00'),
    TimeSlot('15:00'),
    TimeSlot('17:00'),
    TimeSlot('19:00'),
    TimeSlot('20:30'),
  ];

  void _toConfirm() {
    widget.draft
      ..date = _date
      ..time = _time
      ..transport = _transport
      ..viewers = _viewers;
    Navigator.of(context).pushNamed(Routes.confirm, arguments: widget.draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenBar(title: '예약 설정'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                children: [
                  _SectionCard(
                    eyebrow: '날짜',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (final d in _dates) ...[
                                _DateChip(
                                  label: d,
                                  selected: d == _date,
                                  onTap: () => setState(() => _date = d),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text.rich(
                          TextSpan(
                            style: AppText.caption.copyWith(color: AppColors.soft),
                            children: const [
                              TextSpan(text: '24~48시간 내', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink)),
                              TextSpan(text: ' 예약을 권장해요 · 서늘한 곳 안치 시 최대 3~5일'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _SectionCard(
                    eyebrow: '시간',
                    child: TimeSlots(
                      slots: _slots,
                      selected: _time,
                      onSelect: (t) => setState(() => _time = t),
                    ),
                  ),
                  _SectionCard(
                    eyebrow: '운구(픽업)',
                    child: _OptionRow(
                      title: '방문 픽업 요청',
                      subtitle: '지역별 요금 · 예약 후 안내',
                      trailing: Switch(
                        value: _transport,
                        activeThumbColor: AppColors.onOrange,
                        activeTrackColor: AppColors.orange500,
                        onChanged: (v) => setState(() => _transport = v),
                      ),
                    ),
                  ),
                  _SectionCard(
                    eyebrow: '참관 인원',
                    child: _OptionRow(
                      title: '참관하실 인원',
                      subtitle: '전 과정 참관 가능',
                      trailing: _Stepper(
                        value: _viewers,
                        onChanged: (v) => setState(() => _viewers = v),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '결제 단계로',
                trailingIcon: Icons.arrow_forward,
                onPressed: _toConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.eyebrow, required this.child});
  final String eyebrow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(
          color: Color.fromRGBO(58, 30, 12, 0.05),
          offset: Offset(0, 1), blurRadius: 2)],
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(eyebrow, style: AppText.eyebrow),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.orangeWash : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: selected ? AppColors.orange500 : AppColors.line2,
            width: 1.5,
          ),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: selected ? AppColors.orange600 : AppColors.soft)),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.title, required this.subtitle, required this.trailing});
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.bodyStrong.copyWith(fontSize: 14)),
              Text(subtitle, style: AppText.caption.copyWith(color: AppColors.faint)),
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepBtn(icon: Icons.remove, onTap: () => onChanged((value - 1).clamp(1, 9))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('$value', style: AppText.h3),
        ),
        _StepBtn(icon: Icons.add, onTap: () => onChanged((value + 1).clamp(1, 9))),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.orangeWash,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 18, color: AppColors.orange600),
      ),
    );
  }
}
