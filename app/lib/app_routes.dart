/// 앱 라우트 이름 — 프로토타입의 12개 화면(s-*)에 대응.
///
/// 메인 탭(홈·장례·추모·마이)은 [homeShell] 안에서 전환되고,
/// 나머지 플로우(긴급·견적·상세·예약·결제·완료·사전준비)는 push로 쌓인다.
abstract final class Routes {
  static const onboarding = '/'; // s-onboard
  static const homeShell = '/home'; // s-home + 탭(장례/추모/마이)
  static const crisis = '/crisis'; // s-crisis (긴급 코드 타임라인)
  static const quote = '/quote'; // s-quote (견적)
  static const vendorDetail = '/vendor'; // s-detail (업체 상세)
  static const booking = '/booking'; // s-booking (예약 설정)
  static const confirm = '/confirm'; // s-confirm (결제)
  static const done = '/done'; // s-done (완료)
  static const preneed = '/preneed'; // s-preneed (사전 준비)
}
