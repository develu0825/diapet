/// 장례식장(업체) 데이터. 프로토타입의 3개 검증 업체를 시드로 사용.
class Vendor {
  const Vendor({
    required this.name,
    required this.location,
    required this.priceLabel,
    required this.rating,
    required this.reviews,
    required this.availability,
    this.observation = true,
    this.noPushSelling = false,
    this.licenseNo,
    this.phone,
  });

  final String name;
  final String location; // 예: "경기 광주 · 12km"
  final String priceLabel; // 예: "22.0만"
  final double rating; // 예: 4.9
  final int reviews;
  final String availability; // 예: "오늘 예약 가능"
  final bool observation; // 참관 보장
  final bool noPushSelling; // 강매 없음
  final String? licenseNo; // 허가번호
  final String? phone;

  static const seed = <Vendor>[
    Vendor(
      name: '포레스트 추모원',
      location: '경기 광주 · 12km',
      priceLabel: '22.0만',
      rating: 4.9,
      reviews: 312,
      availability: '오늘 예약 가능',
      noPushSelling: true,
      licenseNo: '제3941000-038호',
      phone: '031-000-0038',
    ),
    Vendor(
      name: '무지개뜰 장례식장',
      location: '경기 남양주 · 18km',
      priceLabel: '24.5만',
      rating: 4.8,
      reviews: 204,
      availability: '오늘 예약 가능',
      phone: '031-000-0204',
    ),
    Vendor(
      name: '봄날 펫 세리머니',
      location: '인천 서구 · 26km',
      priceLabel: '21.0만',
      rating: 4.7,
      reviews: 156,
      availability: '내일 예약 가능',
      noPushSelling: true,
      phone: '032-000-0156',
    ),
  ];
}
