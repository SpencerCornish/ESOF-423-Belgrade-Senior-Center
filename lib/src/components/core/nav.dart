import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../state/app.dart';

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
                ..text = 'BSC Member Management'
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
              new VDivElement()
                ..className = "navbar-item has-dropdown is-hoverable"
                ..children = [
                  new Va()
                    ..className = "navbar-link"
                    ..children = [
                      new VSpanElement()
                        ..className = 'icon has-text-link'
                        ..children = [
                          new Vi()..className = 'fas fa-plus',
                        ],
                      new VSpanElement()..text = 'New',
                    ],
                  new VDivElement()
                    ..className = "navbar-dropdown"
                    ..children = [
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'New Member'
                        ..onClick = _onNewMemberClick,
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'New Meal'
                        ..onClick = _onNewMealClick,
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'New Activity'
                        ..onClick = _onNewActivityClick,
                    ],
                ],
              new VDivElement()
                ..className = "navbar-item has-dropdown is-hoverable"
                ..children = [
                  new Va()
                    ..className = "navbar-link"
                    ..children = [
                      new VSpanElement()
                        ..className = 'icon has-text-link'
                        ..children = [
                          new Vi()..className = 'fas fa-eye',
                        ],
                      new VSpanElement()..text = 'View',
                    ],
                  new VDivElement()
                    ..className = "navbar-dropdown"
                    ..children = [
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'Members'
                        ..onClick = _onViewMembersClick,
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'Meals'
                        ..onClick = _onViewMealsClick,
                      new Va()
                        ..className = "navbar-item"
                        ..text = 'Activities'
                        ..onClick = _onViewActivitiesClick,
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
                            ..id = 'nav-username'
                            ..text = "Welcome, ${props.user?.firstName} ${props.user?.lastName}!",
                        ],
                      new VDivElement()
                        ..className = 'column is-narrow'
                        ..children = [
                          new VAnchorElement()
                            ..className = 'button'
                            ..id = 'log-out-button'
                            ..onClick = _onLogOutClick
                            ..children = [
                              new VSpanElement()
                                ..className = 'icon'
                                ..children = [
                                  new Vi()..className = 'fas fa-sign-out-alt',
                                ],
                              new VSpanElement()..text = 'Log Out',
                            ],
                        ],
                    ],
                ],
            ],
        ],
    ];

  _onNewMemberClick(_) => print('Navigate to new member form');

  _onNewMealClick(_) => print('Navigate to new meal form');

  _onNewActivityClick(_) => print('Navigate to new activity form');

  _onViewMembersClick(_) => print('Navigate to view member list');

  _onViewMealsClick(_) => print('Navigate to view meals list');

  _onViewActivitiesClick(_) => print('Navigate to view activities list');

  _onLogOutClick(_) async {
    props.actions.server.logOut();
  }
}
