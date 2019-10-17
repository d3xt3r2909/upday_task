import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shutterstock_flutter/pages/gallery/widgets/visibility_widget.dart';

void main() {
  group(('Test visibility of visibility widget'), () {
    testWidgets('Hide widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          child: VisibilityWidget(
            child: Text('Something'),
            isVisible: false,
          ),
          textDirection: TextDirection.ltr,
        )
      );

      expect(find.text('Something'), findsNothing);
    });

    testWidgets('Show widget', (WidgetTester tester) async {
      await tester.pumpWidget(
          Directionality(
            child: VisibilityWidget(
              child: Text('Something'),
              isVisible: true,
            ),
            textDirection: TextDirection.ltr,
          )
      );

      expect(find.text('Something'), findsOneWidget);
    });
  });
}
