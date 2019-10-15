import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Application flow - Integration tests', () {
    final floatingButton = find.byValueKey('gallery_top_floating_button');
    final gridView = find.byValueKey('gallery_grid_key');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    group(
        ('Basic flow of application scroll to elements, load images'
            'from external API source, on every 14th element load more'
            'images, when you rich some point on dy, press button to'
            'go on top of list, after user goes to top of list '
            'floating button should disappered'), () {
      test('Based on scroll show or hide bottom bar', () async {
        await driver.waitForAbsent(floatingButton);

        await driver.scroll(gridView, 0, -100, Duration(milliseconds: 500));

        await driver.waitFor(floatingButton);

        await driver.scroll(gridView, 0, 100, Duration(milliseconds: 500));

        await driver.waitForAbsent(floatingButton);
      });

      test(
          'Scroll grid view to some point on DY, after that click'
          'on floating button to move grid scroll to top'
          'also here is possible to see how images are loading and'
          'when new getting of data is triggered', () async {
        await driver.scroll(gridView, 0, -5000, Duration(seconds: 3));

        await driver.waitFor(floatingButton);

        await driver.tap(floatingButton);

        await driver.waitForAbsent(floatingButton);

        // This line can be removed, currently it is just delayed to see
        // feature of "top" button
        await Future.delayed(const Duration(seconds: 1), (){});

        // @TODO we can make screen shots here and stuffs like that
        // for CI / CD if we want to automate process for CD
      });
    });
  });
}
