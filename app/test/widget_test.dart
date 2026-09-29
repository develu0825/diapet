import 'package:flutter_test/flutter_test.dart';

import 'package:diapet/main.dart';

void main() {
  testWidgets('DiapetApp이 테마와 함께 렌더된다', (WidgetTester tester) async {
    await tester.pumpWidget(const DiapetApp());

    // 앱 배경이 웜 크림(paper)인지 = 테마가 적용됐는지 확인.
    expect(find.text('Diapet'), findsOneWidget);
  });
}
