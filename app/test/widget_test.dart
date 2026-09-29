import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diapet/main.dart';
import 'package:diapet/screens/preneed_screen.dart';
import 'package:diapet/screens/quote_screen.dart';

void main() {
  testWidgets('온보딩이 표시된다', (tester) async {
    await tester.pumpWidget(const DiapetApp());
    expect(find.text('Diapet'), findsOneWidget);
    expect(find.text('시작하기'), findsOneWidget);
  });

  testWidgets('시작하기 → 홈 대시보드로 진입한다', (tester) async {
    await tester.pumpWidget(const DiapetApp());

    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

    // 홈 허브의 핵심 요소가 트리에 존재하는지(그리드는 뷰포트 밖일 수 있어 offstage 포함).
    expect(find.text('아이를 보내주려 해요'), findsOneWidget);
    expect(find.text('바로가기'), findsOneWidget);
    expect(find.text('장례 예약', skipOffstage: false), findsOneWidget);
  });

  testWidgets('홈 → 긴급 진입 CTA → 긴급 타임라인이 열린다', (tester) async {
    await tester.pumpWidget(const DiapetApp());
    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(const DiapetApp());
    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

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
    await tester.pumpWidget(const DiapetApp());
    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();
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
  });

  testWidgets('추모 탭 → 촛불 켜기로 카운트가 오른다', (tester) async {
    await tester.pumpWidget(const DiapetApp());
    await tester.tap(find.text('시작하기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('추모'));
    await tester.pumpAndSettle();
    expect(find.text('보리를 기억하는 공간'), findsOneWidget);
    expect(find.textContaining('1,203명'), findsNothing); // 콤마 없는 포맷
    expect(find.textContaining('1203명이 함께'), findsOneWidget);

    await tester.tap(find.textContaining('촛불 켜기'));
    await tester.pump();
    expect(find.textContaining('촛불을 켰어요 · 1204명'), findsOneWidget);
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
}
