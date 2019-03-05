import 'dart:async';
import 'dart:html' hide History;

// External Dependencies
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../constants.dart';

// Containers and components
import './containers/home.dart';
import './containers/newMember.dart';
import './containers/dashboard.dart';
import './containers/viewMember.dart';
import './containers/viewActivity.dart';
import './containers/viewMeal.dart';
import './core/debug.dart';

// State
import '../state/app.dart';
import '../store.dart';

class ContainerProps {
  StoreContainer storeContainer;
}

class Container extends PComponent<ContainerProps> {
  StreamSubscription storeContainerSub;

  /// Ease of use getter for appState
  App get appState => props.storeContainer.store.state;

  /// Ease of use getter for actions
  AppActions get actions => props.storeContainer.store.actions;

  Container(props) : super(props);

  /// Browser history entrypoint, to control page navigation
  History _history;
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillMount() {
    storeContainerSub = props.storeContainer.store.stream.listen((_) => updateOnAnimationFrame());
    // Get all the users from the database
    actions.server.fetchAllMembers();
    actions.server.fetchAllActivities();
    actions.server.fetchAllMeals();

    storeContainerSub = props.storeContainer.store.stream.listen((_) => updateOnAnimationFrame());
  }

  @override
  void componentWillUnmount() {
    storeContainerSub.cancel();
  }

  @override
  VNode render() => _routes();

  // Define all routes for the application
  VNode _routes() => new VDivElement()
    ..className = "full-view"
    ..children = [
      new VDivElement()
        ..className = 'document-body'
        ..children = [
          new Router(
            routes: [
              // Default homepage route. Redirect to the dashboard if the user is authenticated
              new Route(
                path: Routes.home,
                componentFactory: (_) => _renderHome(),
                useAsDefault: true,
              ),
              new Route(
                path: Routes.createMember,
                componentFactory: (params) => _renderCreateMember(),
              ),
              new Route(path: Routes.resetContinue, componentFactory: (params) => _renderResetContinue(params)),
              new Route(path: Routes.dashboard, componentFactory: (_) => _renderIfAuthenticated(_renderDashboard())),
              new Route(path: Routes.viewMember, componentFactory: (_) => _renderIfAuthenticated(_renderViewMember())),
              new Route(
                  path: Routes.viewActivity, componentFactory: (_) => _renderIfAuthenticated(_renderViewActivity())),
              new Route(path: Routes.viewMeal, componentFactory: (_) => _renderIfAuthenticated(_renderViewMeal())),
            ],
          ),
        ],
      // new Footer(new FooterProps()..actions = props.storeContainer.store.actions),
      _renderDebug(),
    ];

  ///Method used to render the CreateMember page
  _renderCreateMember() => new NewMember(new NewMemberProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  // Only renders if the user is properly authenticated. Otherwise, bail to the homepage
  _renderIfAuthenticated(VNode page) => appState.authState == AuthState.SUCCESS ? page : _redirect(Routes.home);

  // Helper for performing quick redirects, typically in the case of fresh authentication
  _redirect(String newRoute) {
    new Future.delayed(Duration(milliseconds: 10), (() => history.push(newRoute)));
    return new VDivElement();
  }

  // A redirect to the homepage, used for passing custom messages into the homepage
  _renderResetContinue(Map<String, String> params) => _renderHome(
      redirectCode: 'Password reset successful. Please enter your new password below.',
      emailPrefill: baseToString(params['email_hash']));

  _renderHome({String redirectCode, String emailPrefill}) => new Home(new HomeProps()
    ..actions = props.storeContainer.store.actions
    ..authState = appState.authState
    ..redirectCode = redirectCode ?? ''
    ..emailPrefill = emailPrefill ?? '');

  _renderDashboard() => new Dashboard(new DashboardProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  _renderViewMember() => new viewMember(new viewMemberProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..userMap = appState.userMap);

  _renderViewActivity() => new viewActivity(new viewActivityProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..activityMap = appState.activityMap);

  _renderViewMeal() => new viewMeal(new viewMealProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..mealMap = appState.mealMap);

  _renderDebug() => (document.domain.contains("localhost"))
      ? new DebugNavigator(new DebugNavigatorProps()..actions = props.storeContainer.store.actions)
      : new Vspan();
}
