import 'package:flutter_test/flutter_test.dart';
import 'package:aahar_app/main.dart';

void main() {
  testWidgets('Aahar app renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AaharApp());
    expect(find.text('Aahar'), findsOneWidget);
    expect(find.text('Focus on Growth'), findsOneWidget);
  });
}
