import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/booking.dart';
import '../models/booking_draft.dart';

/// 예약 생성·조회·취소 추상화.
///
/// 지금은 [MockBookingRepository] 가 예약을 로컬(shared_preferences)에 저장해
/// **백엔드 없이도** 예약이 실제로 생성·보관된다. 실제 출시 때는 결제 PG 승인 +
/// 서버 예약 생성 API 를 호출하는 `FirestoreBookingRepository` 로 교체한다.
/// (docs/BACKEND_SETUP.md)
abstract class BookingRepository {
  /// 결제를 거쳐 예약을 생성한다. 성공 시 확정된 [Booking] 을 돌려준다.
  Future<Booking> create(BookingDraft draft);

  /// 내 예약 목록(최근 순).
  Future<List<Booking>> myBookings();

  Future<void> cancel(String id);
}

class MockBookingRepository implements BookingRepository {
  static const _key = 'bookings_v1';

  @override
  Future<Booking> create(BookingDraft draft) async {
    // TODO(backend): 여기서 결제 PG 승인 → 서버 예약 생성 API 호출로 교체.
    final now = DateTime.now();
    final booking = Booking.fromDraft(
      draft,
      id: 'DP${now.millisecondsSinceEpoch}',
      createdAt: now,
      status: BookingStatus.confirmed,
    );
    final all = await myBookings();
    all.insert(0, booking);
    await _persist(all);
    return booking;
  }

  @override
  Future<List<Booking>> myBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getStringList(_key) ?? const [];
      return raw
          .map((s) => Booking.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> cancel(String id) async {
    final all = await myBookings();
    final i = all.indexWhere((b) => b.id == id);
    if (i != -1) {
      all[i] = all[i].copyWith(status: BookingStatus.cancelled);
      await _persist(all);
    }
  }

  Future<void> _persist(List<Booking> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          _key, list.map((b) => jsonEncode(b.toJson())).toList());
    } catch (_) {
      // 저장 실패해도 방금 만든 예약은 호출부로 반환돼 완료 화면이 뜬다.
    }
  }
}

/// 전역 접근점. 백엔드 붙일 때 이 한 줄만 교체.
final BookingRepository bookingRepository = MockBookingRepository();
