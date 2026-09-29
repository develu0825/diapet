import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../models/booking_draft.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/screen_bar.dart';
import '../widgets/sticky_cta.dart';

/// 천 단위 콤마 포맷(예: 220000 → "220,000").
String won(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return buf.toString();
}

/// 예약 확인·결제 (s-confirm) — 요약·금액·결제수단·동의 후 확정.
class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  int _pay = 0;
  bool _agreed = false;

  static const _payMethods = ['카카오페이', '신용·체크카드', '현장 결제'];

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenBar(title: '예약 확인 · 결제'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                children: [
                  _Card(child: Column(children: [
                    _SummaryRow('장례식장', d.vendor.name),
                    _SummaryRow('일시', '${d.date} ${d.time}'),
                    _SummaryRow('참관', '${d.viewers}명'),
                    _SummaryRow('운구', d.transport ? '신청 (방문 픽업)' : '신청 안 함'),
                  ])),
                  _Card(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('결제 금액', style: AppText.eyebrow),
                      const SizedBox(height: AppSpacing.xs),
                      _QLine('${d.packageName} 패키지', won(d.base)),
                      if (d.transport) _QLine('운구(픽업)', won(BookingDraft.transportFee)),
                      const Divider(height: 20, color: AppColors.line),
                      _QLine('총액', '${won(d.total)}원', total: true),
                      const SizedBox(height: AppSpacing.sm),
                      Row(children: [
                        const Icon(Icons.check, size: 17, color: AppColors.ok),
                        const SizedBox(width: 6),
                        Expanded(child: Text('표시 금액 그대로 청구돼요. 현장 추가금 없음.',
                            style: AppText.caption.copyWith(color: AppColors.ok, fontWeight: FontWeight.w600))),
                      ]),
                    ],
                  )),
                  _Card(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('결제 수단', style: AppText.eyebrow),
                      const SizedBox(height: AppSpacing.xs),
                      for (int i = 0; i < _payMethods.length; i++)
                        _PayOption(
                          label: _payMethods[i],
                          selected: i == _pay,
                          onTap: () => setState(() => _pay = i),
                        ),
                    ],
                  )),
                  const SizedBox(height: AppSpacing.xs),
                  _AgreeRow(
                    checked: _agreed,
                    onTap: () => setState(() => _agreed = !_agreed),
                  ),
                ],
              ),
            ),
            StickyCta(
              child: AppButton(
                label: '예약 확정 · ${won(d.total)}원',
                onPressed: _agreed
                    ? () => Navigator.of(context).pushNamed(Routes.done, arguments: d)
                    : null,
              ),
            ),
          ],
        ),
      ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.k, this.v);
  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: AppText.body.copyWith(color: AppColors.soft)),
          Text(v, style: AppText.bodyStrong),
        ],
      ),
    );
  }
}

class _QLine extends StatelessWidget {
  const _QLine(this.label, this.amount, {this.total = false});
  final String label;
  final String amount;
  final bool total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: total
              ? AppText.bodyStrong
              : AppText.body.copyWith(color: AppColors.soft)),
          Text(amount, style: total
              ? AppText.monoNum.copyWith(fontSize: 17, color: AppColors.orange600)
              : AppText.body.copyWith(fontFamily: AppText.monoFamily)),
        ],
      ),
    );
  }
}

class _PayOption extends StatelessWidget {
  const _PayOption({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 20, color: selected ? AppColors.orange500 : AppColors.line2),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: AppText.body),
          ],
        ),
      ),
    );
  }
}

class _AgreeRow extends StatelessWidget {
  const _AgreeRow({required this.checked, required this.onTap});
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: checked ? AppColors.orange500 : AppColors.card,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: checked ? AppColors.orange500 : AppColors.line2, width: 1.5),
              ),
              child: checked
                  ? const Icon(Icons.check, size: 15, color: AppColors.onOrange)
                  : null,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text('결제 진행 및 개인정보 수집·이용에 동의합니다.',
                style: AppText.caption.copyWith(color: AppColors.soft))),
          ],
        ),
      ),
    );
  }
}
