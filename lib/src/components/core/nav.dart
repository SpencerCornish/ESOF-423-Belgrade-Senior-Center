import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../state/app.dart';

import '../../model/user.dart';
import '../../constants.dart';

class NavProps {
  AppActions actions;
  User user;
}

class NavState {
  bool navBurgerExpanded;
}

class Nav extends Component<NavProps, NavState> {
  Nav(props) : super(props);

  // getInitialState is overriden to set the initial component state
  @override
  NavState getInitialState() => NavState()..navBurgerExpanded = false;

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillUpdate(NavProps nextProps, NavState nextState) {
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
            ..onClick = _onHomeClick
            ..children = [
              new Vh1()
                ..className = 'subtitle'
                ..text = 'BSC Member Management'
            ],
          new VAnchorElement()
            ..className = "navbar-burger burger ${state.navBurgerExpanded ? 'is-active' : ''}"
            ..onClick = _onBurgerClick
            ..children = [
              new Vspan(),
              new Vspan(),
              new Vspan(),
            ],
        ],
      new VDivElement()
        ..className = "navbar-menu ${state.navBurgerExpanded ? 'is-active' : ''}"
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
                      props.user.role == "admin"
                          ? (new Va()
                            ..className = "navbar-item"
                            ..text = 'All Shifts'
                            ..onClick = _onViewAllShiftsClick)
                          : new VDivElement(),
                      props.user.role == "admin" || props.user.role == "volunteer"
                          ? (new Va()
                            ..className = "navbar-item"
                            ..text = 'My Shifts'
                            ..onClick = _onViewMyShiftsClick)
                          : new VDivElement(),
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
                            ..className = 'button is-rounded'
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
  _onHomeClick(_) => history.push(Routes.dashboard);

  _onBurgerClick(_) {
    setState((props, state) => state..navBurgerExpanded = !state.navBurgerExpanded);
  }

  _onNewMemberClick(_) => history.push(Routes.createMember);

  _onNewMealClick(_) => history.push(Routes.createMeal);

  _onNewActivityClick(_) => history.push(Routes.createAct);

  _onViewMembersClick(_) => history.push(Routes.viewMembers);

  _onViewMealsClick(_) => history.push(Routes.viewMeal);

  _onViewActivitiesClick(_) => history.push(Routes.viewActivity);

  _onViewAllShiftsClick(_) => history.push(Routes.viewAllShifts);

  _onViewMyShiftsClick(_) => history.push(Routes.viewShifts);

  _onLogOutClick(_) async {
    await props.actions.setAuthState(AuthState.LOADING);
    await history.push(Routes.home);
    props.actions.server.logOut();
  }
}
