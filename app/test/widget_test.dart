import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diapet/main.dart';

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
}
