import 'vendor.dart';

/// 예약 진행 중 상태 — 상세→예약설정→결제→완료로 참조 전달된다.
///
/// 프로토타입의 `booking` 객체에 대응. 운구(transport)는 +30,000원.
class BookingDraft {
  BookingDraft({
    required this.vendor,
    required this.packageName,
    required this.base,
    this.date = '오늘',
    this.time = '15:00',
    this.transport = false,
    this.viewers = 2,
  });

  final Vendor vendor;
  String packageName;
  int base;
  String date;
  String time;
  bool transport;
  int viewers;

  static const transportFee = 30000;

  int get total => base + (transport ? transportFee : 0);
}
