import 'dart:async';

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../constants.dart';

import '../../state/app.dart';
import '../../store.dart';

class HomeProps {
  AppActions actions;
}

class Home extends PComponent<HomeProps> {
  Home(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..className = 'container'
    ..children = [
      new VDivElement()
        ..className = 'columns is-centered'
        ..children = [
          new VDivElement()
            ..className = 'column has-text-centered'
            ..children = [
              new Vh1()
                ..className = 'title'
                ..text = "Belgrade Senior Center",
            ],
        ],
      new VDivElement()
        ..className = 'columns is-centered'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow has-text-centered'
            ..children = [
              new VButtonElement()
                ..className = 'button is-info'
                ..text = "Development Documentation",
            ],
          new VDivElement()
            ..className = 'column is-narrow has-text-centered'
            ..children = [
              new VButtonElement()
                ..className = 'button is-info'
                ..text = "User Documentation",
            ],
        ],
    ];
}
