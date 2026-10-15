import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:diapet/main.dart';
import 'package:diapet/models/booking.dart';
import 'package:diapet/screens/preneed_screen.dart';
import 'package:diapet/screens/quote_screen.dart';
import 'package:diapet/services/auth_service.dart';
import 'package:diapet/services/booking_repository.dart';

/// 온보딩 → 로그인(둘러보기) → 약관 전체동의 → 홈 대시보드로 진입시키는 공통 헬퍼.
Future<void> enterHome(WidgetTester tester) async {
  await tester.pumpWidget(const DiapetApp());
  await tester.tap(find.byKey(const Key('onboarding-enter')));
  await tester.pumpAndSettle();
  // 로그인 게이트: 둘러보기(게스트)로 빠르게 통과.
  await tester.tap(find.byKey(const Key('login-guest')));
  await tester.pumpAndSettle();
  // 약관 동의: 전체 동의 후 계속.
  await tester.tap(find.byKey(const Key('consent-agree-all')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('consent-continue')));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences 를 테스트용 인메모리로 mock → prefs 호출이 즉시 응답(행 방지).
  // authService 는 전역 싱글턴이라 세션도 매번 비운다.
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await authService.signOut();
  });

  testWidgets('온보딩이 표시된다', (tester) async {
    await tester.pumpWidget(const DiapetApp());
    expect(find.byKey(const Key('onboarding-enter')), findsOneWidget);
  });

  testWidgets('온보딩 → 홈 대시보드로 진입한다', (tester) async {
    await enterHome(tester);

    // 홈 허브의 핵심 요소(홈 탭에 유일).
    expect(find.text('아이를 보내주려 해요'), findsOneWidget);
    expect(find.text('바로가기'), findsOneWidget);
    // 바로가기 타일은 뷰포트 밖일 수 있어 offstage 포함해 존재만 확인.
    expect(find.text('장례 예약', skipOffstage: false), findsWidgets);
  });

  testWidgets('홈 → 긴급 진입 CTA → 긴급 타임라인이 열린다', (tester) async {
    await enterHome(tester);

    await tester.tap(find.text('아이를 보내주려 해요'));
    await tester.pumpAndSettle();

    expect(find.text('지금 이대로 따라 하세요'), findsOneWidget);
    expect(find.text('편안하게 눕혀 주세요', skipOffstage: false), findsOneWidget);
    expect(find.text('이제 장례식장 찾기', skipOffstage: false), findsOneWidget);
  });

  testWidgets('견적: 몸무게·추모식 선택에 따라 확정가가 갱신된다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: QuoteScreen()));

    // 기본: 소형(20만) + 기본 화장(0) = 20.0
    expect(find.textContaining('20.0'), findsOneWidget);

    // 중형(32만) 선택 → 32.0
    await tester.tap(find.text('5~15kg'));
    await tester.pump();
    expect(find.textContaining('32.0'), findsOneWidget);

    // 추모식 포함(+5만) → 37.0
    await tester.tap(find.text('추모식 포함'));
    await tester.pump();
    expect(find.textContaining('37.0'), findsOneWidget);
  });

  testWidgets('장례 탭 → 업체 목록 → 상세 패키지', (tester) async {
    await enterHome(tester);

    // 하단 '장례' 탭 진입
    await tester.tap(find.text('장례'));
    await tester.pumpAndSettle();
    expect(find.text('가까운 장례식장'), findsOneWidget);
    expect(find.text('포레스트 추모원'), findsOneWidget);

    // 업체 카드 → 상세
    await tester.tap(find.text('포레스트 추모원'));
    await tester.pumpAndSettle();
    expect(find.text('패키지 선택'), findsOneWidget);
    expect(find.text('가장 많이 선택', skipOffstage: false), findsOneWidget);
    expect(find.text('예약하기', skipOffstage: false), findsOneWidget);
  });

  testWidgets('예약 → 결제 동의 → 확정 완료 플로우', (tester) async {
    await enterHome(tester);
    await tester.tap(find.text('장례'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('포레스트 추모원'));
    await tester.pumpAndSettle();

    // 상세 → 예약 설정
    await tester.tap(find.text('예약하기'));
    await tester.pumpAndSettle();
    expect(find.text('예약 설정'), findsOneWidget);

    // 예약 설정 → 결제
    await tester.tap(find.text('결제 단계로'));
    await tester.pumpAndSettle();
    expect(find.text('예약 확인 · 결제'), findsOneWidget);

    // 동의 후 확정. (동의 행은 뷰포트 밖일 수 있어 스크롤로 노출)
    final agree = find.textContaining('동의합니다');
    await tester.scrollUntilVisible(agree, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(agree);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('예약 확정'));
    await tester.pumpAndSettle();

    expect(find.text('예약이 확정되었어요'), findsOneWidget);
    expect(find.text('장례 이후, 저희가 챙겨드릴게요', skipOffstage: false), findsOneWidget);

    // 예약이 실제 레코드로 생성(예약번호 노출)되고 로컬에 저장됐는지 검증.
    expect(find.text('예약번호'), findsOneWidget);
    final saved = await tester.runAsync(() => bookingRepository.myBookings());
    expect(saved!.length, 1);
    expect(saved.first.vendorName, '포레스트 추모원');
    expect(saved.first.status, BookingStatus.confirmed);
  });

  testWidgets('추모 탭 → 촛불 켜기로 카운트가 오른다', (tester) async {
    await enterHome(tester);

    await tester.tap(find.text('추모'));
    await tester.pumpAndSettle();
    expect(find.text('보리를 기억하는 공간'), findsOneWidget);

    // 촛불 카드가 커진 폴라로이드 캐러셀에 밀려 뷰포트 밖일 수 있어 스크롤로 노출.
    final candle = find.textContaining('촛불 켜기');
    await tester.scrollUntilVisible(candle, 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.textContaining('1,203명이 함께'), findsOneWidget);

    await tester.tap(candle);
    await tester.pump();
    expect(find.textContaining('촛불을 켰어요 · 1,204명'), findsOneWidget);
  });

  testWidgets('사전 준비: 체크리스트와 사전 견적이 보인다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PreneedScreen()));

    expect(find.text('준비 체크리스트'), findsOneWidget);
    expect(find.text('아이 정보 등록 (종·나이·건강 상태)'), findsOneWidget);
    expect(find.textContaining('35.2만원~', skipOffstage: false), findsOneWidget);

    // 체크 항목 토글이 예외 없이 동작한다.
    await tester.tap(find.text('믿을 수 있는 장례식장 미리 찜하기'));
    await tester.pump();
  });

  testWidgets('마이 탭 → 서브탭(설정) 전환', (tester) async {
    await enterHome(tester);

    await tester.tap(find.text('마이'));
    await tester.pumpAndSettle();
    expect(find.text('내 아이'), findsOneWidget);
    expect(find.text('보리', skipOffstage: false), findsWidgets);

    // 설정 서브탭으로 전환
    await tester.tap(find.text('설정'));
    await tester.pumpAndSettle();
    expect(find.text('로그아웃', skipOffstage: false), findsOneWidget);
    expect(find.text('v1.0.0', skipOffstage: false), findsOneWidget);
  });

  testWidgets('온보딩 → 로그인 게이트가 열린다', (tester) async {
    await tester.pumpWidget(const DiapetApp());
    await tester.tap(find.byKey(const Key('onboarding-enter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login-kakao')), findsOneWidget);
    expect(find.text('카카오로 시작하기'), findsOneWidget);
    expect(find.byKey(const Key('login-guest')), findsOneWidget);
  });

  testWidgets('약관 필수 동의 전에는 홈으로 진입하지 않는다', (tester) async {
    await tester.pumpWidget(const DiapetApp());
    await tester.tap(find.byKey(const Key('onboarding-enter')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('login-guest')));
    await tester.pumpAndSettle();

    // 아무 동의 없이 바로 계속 시도 → 여전히 동의 화면.
    await tester.tap(find.byKey(const Key('consent-continue')));
    await tester.pumpAndSettle();
    expect(find.text('동의하고 시작하기'), findsOneWidget);
    expect(find.text('아이를 보내주려 해요'), findsNothing);

    // 전체 동의 후에는 홈으로 진입.
    await tester.tap(find.byKey(const Key('consent-agree-all')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('consent-continue')));
    await tester.pumpAndSettle();
    expect(find.text('아이를 보내주려 해요'), findsOneWidget);
  });
}
