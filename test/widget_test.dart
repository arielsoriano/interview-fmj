import 'package:city_events_explorer/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App initializes', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('City Events Explorer'), findsOneWidget);
  });
}
