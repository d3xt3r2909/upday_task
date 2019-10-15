import 'package:flutter_test/flutter_test.dart';
import 'package:upday_task/initial.dart';
import 'package:upday_task/settings/app_settings.dart';

void main() {
  testWidgets('Golden test', (WidgetTester tester) async {
    await tester.pumpWidget(InitialSetup(
      environment: AppEnvironment.DEV,
    ));

    await expectLater(find.byType(InitialSetup), matchesGoldenFile('main.png'));
  });
}
