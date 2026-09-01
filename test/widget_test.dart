import 'package:flutter_test/flutter_test.dart';
import 'package:rejoice_in_the_lord/main.dart';

void main() {
  testWidgets('Rejoice in the Lord app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RejoiceInTheLordApp());
    expect(find.byType(RejoiceInTheLordApp), findsOneWidget);
  });
}
