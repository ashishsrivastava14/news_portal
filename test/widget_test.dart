import 'package:flutter_test/flutter_test.dart';
import 'package:news_portal/main.dart';

void main() {
  testWidgets('App builds smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const NewsPortalApp());
    expect(find.byType(NewsPortalApp), findsOneWidget);
  });
}
