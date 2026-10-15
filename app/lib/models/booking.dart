import 'booking_draft.dart';

/// 예약 상태. 목(mock)에서는 결제 성공으로 바로 confirmed, 실제 백엔드에서는
/// requested(요청) → confirmed(결제·확정) → cancelled(취소) 로 흐른다.
enum BookingStatus { requested, confirmed, cancelled }

/// 확정된 예약 레코드. [BookingDraft] 가 결제를 거쳐 서버에 생성되면 이 형태가 된다.
class Booking {
  const Booking({
    required this.id,
    required this.vendorName,
    required this.packageName,
    required this.base,
    required this.total,
    required this.date,
    required this.time,
    required this.transport,
    required this.viewers,
    required this.status,
    required this.createdAt,
    this.licenseNo,
    this.phone,
  });

  final String id;
  final String vendorName;
  final String packageName;
  final int base;
  final int total;
  final String date;
  final String time;
  final bool transport;
  final int viewers;
  final BookingStatus status;
  final DateTime createdAt;
  final String? licenseNo;
  final String? phone;

  factory Booking.fromDraft(
    BookingDraft d, {
    required String id,
    required DateTime createdAt,
    BookingStatus status = BookingStatus.confirmed,
  }) {
    return Booking(
      id: id,
      vendorName: d.vendor.name,
      packageName: d.packageName,
      base: d.base,
      total: d.total,
      date: d.date,
      time: d.time,
      transport: d.transport,
      viewers: d.viewers,
      status: status,
      createdAt: createdAt,
      licenseNo: d.vendor.licenseNo,
      phone: d.vendor.phone,
    );
  }

  Booking copyWith({BookingStatus? status}) => Booking(
        id: id,
        vendorName: vendorName,
        packageName: packageName,
        base: base,
        total: total,
        date: date,
        time: time,
        transport: transport,
        viewers: viewers,
        status: status ?? this.status,
        createdAt: createdAt,
        licenseNo: licenseNo,
        phone: phone,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorName': vendorName,
        'packageName': packageName,
        'base': base,
        'total': total,
        'date': date,
        'time': time,
        'transport': transport,
        'viewers': viewers,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'licenseNo': licenseNo,
        'phone': phone,
      };

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
        id: j['id'] as String,
        vendorName: j['vendorName'] as String,
        packageName: j['packageName'] as String,
        base: (j['base'] as num).toInt(),
        total: (j['total'] as num).toInt(),
        date: j['date'] as String,
        time: j['time'] as String,
        transport: j['transport'] as bool? ?? false,
        viewers: (j['viewers'] as num?)?.toInt() ?? 1,
        status: BookingStatus.values.firstWhere(
          (s) => s.name == j['status'],
          orElse: () => BookingStatus.confirmed,
        ),
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
        licenseNo: j['licenseNo'] as String?,
        phone: j['phone'] as String?,
      );
}
