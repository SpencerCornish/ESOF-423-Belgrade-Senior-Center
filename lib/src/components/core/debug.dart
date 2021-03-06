import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../state/app.dart';

import '../../constants.dart';

class DebugNavigatorProps {
  AppActions actions;
}

class DebugNavigator extends PComponent<DebugNavigatorProps> {
  DebugNavigator(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..className = 'columns is-centered'
    ..id = 'debug-snapped'
    ..children = [
      new VDivElement()
        ..className = 'column is-half'
        ..children = [
          new VDivElement()
            ..className = 'box'
            ..children = [
              new VAnchorElement()
                ..className = 'button'
                ..text = 'Home'
                ..onClick = (_) => history.push(Routes.home),
              new VAnchorElement()
                ..className = 'button'
                ..text = 'Dashboard'
                ..onClick = (_) => history.push(Routes.dashboard),
              new VAnchorElement()
                ..className = 'button'
                ..text = 'Forms'
                ..onClick = (_) => history.push(Routes.createMember),
              new VAnchorElement()
                ..className = 'button'
                ..text = 'Stored Data'
                ..onClick = (_) => history.push(Routes.viewMembers),
            ]
        ],
    ];
}
