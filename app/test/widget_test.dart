import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diapet/main.dart';
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
}
