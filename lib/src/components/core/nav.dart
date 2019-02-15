import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../state/app.dart';
import '../../middleware/serverMiddleware.dart';

import '../../constants.dart';
import '../../model/user.dart';

class NavProps {
  AppActions actions;
  User user;
}

class Nav extends PComponent<NavProps> {
  Nav(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillUpdate(NavProps nextProps, Null nextState) {
    super.componentWillUpdate(nextProps, nextState);

    if (nextProps.user == null) history.push(Routes.home);
  }

  @override
  VNode render() => new Vnav()
    ..className = "navbar"
    ..children = [
      new VDivElement()
        ..className = "navbar-brand"
        ..children = [
          new VAnchorElement()
            ..className = "navbar-item"
            ..children = [
              new Vh1()
                ..className = 'subtitle'
                ..text = 'BSC'
            ],
          //TODO: Enable the burger menu for mobile responsiveness
          new VAnchorElement()
            ..className = "navbar-burger burger"
            ..children = [
              new Vspan(),
              new Vspan(),
              new Vspan(),
            ],
        ],
      new VDivElement()
        ..className = "navbar-menu"
        ..children = [
          new VDivElement()
            ..className = "navbar-start"
            ..children = [
              new Va()
                ..className = "navbar-item"
                ..text = 'Home',
              new Va()
                ..className = "navbar-item"
                ..text = 'Dashboard',
              new VDivElement()
                ..className = "navbar-item has-dropdown is-hoverable"
                ..children = [
                  new Va()
                    ..className = "navbar-link"
                    ..text = 'Forms',
                  new VDivElement()
                    ..className = "navbar-dropdown"
                    ..children = [
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'New Member',
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'Form B',
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'Long Form 2',
                      new Vhr()..className = "navbar-divider",
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'More...',
                    ],
                ],
            ],
          new VDivElement()
            ..className = "navbar-end"
            ..children = [
              new VDivElement()
                ..className = "navbar-item"
                ..children = [
                  new VDivElement()
                    ..className = "columns is-vcentered"
                    ..children = [
                      new VDivElement()
                        ..className = 'column'
                        ..children = [
                          new VParagraphElement()
                            ..className = 'has-text-grey'
                            ..text = props.user?.uid,
                        ],
                      new VDivElement()
                        ..className = 'column is-narrow'
                        ..children = [
                          new VAnchorElement()
                            ..className = 'button is-danger'
                            ..onClick = _onLogOutClick
                            ..text = 'Log Out',
                        ],
                    ],
                ],
            ],
        ],
    ];

  _onLogOutClick(_) async {
    props.actions.serverActions.logOut();
  }
}
