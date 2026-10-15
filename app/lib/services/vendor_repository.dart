import '../models/vendor.dart';

/// 장례식장 데이터 소스 추상화.
///
/// 지금은 [MockVendorRepository] 가 로컬 시드([Vendor.seed])를 돌려준다. 실제 출시 때는
/// Firestore `vendors` 컬렉션을 읽는 `FirestoreVendorRepository` 로 [vendorRepository]
/// 한 줄만 교체하면 된다. (docs/BACKEND_SETUP.md)
abstract class VendorRepository {
  /// 검증된 장례식장 목록. 실제 구현에서는 허가번호 대조·지역 필터가 서버에서 처리된다.
  Future<List<Vendor>> list();
}

class MockVendorRepository implements VendorRepository {
  @override
  Future<List<Vendor>> list() async {
    // TODO(backend): Firestore 쿼리로 교체(가동 중·정부등록 검증된 업체만).
    return Vendor.seed;
  }
}

/// 전역 접근점. 백엔드 붙일 때 이 한 줄만 교체.
final VendorRepository vendorRepository = MockVendorRepository();
