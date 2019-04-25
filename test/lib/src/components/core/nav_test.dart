import 'dart:html';

import 'package:test/test.dart';
import 'package:bsc/src/state/app.dart';
import 'package:bsc/src/components/core/nav.dart';
import 'package:wui_builder/wui_builder.dart';
import '../../test_data.dart';

void main() {
  group('Nav -', () {
    AppActions actions;
    Nav navComponent;

    setUp(() {
      actions = new AppActions();
      navComponent = new Nav(NavProps()
        ..actions = actions
        ..user = testUser);
    });

    test('Renders', () {
      document.body.appendHtml('<div class="connector"></div>');
      render(navComponent, querySelector('.connector'));
      expect(querySelector('.navbar'), isNotNull);
    });
  });
}
