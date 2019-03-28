import 'dart:async';
import 'dart:html' hide History;

// External Dependencies
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../constants.dart';

// Containers and components
import './containers/home.dart';
import './containers/loading.dart';
import './containers/newMember.dart';
import './containers/dashboard.dart';
import './containers/newActivity.dart';
import './containers/newMeal.dart';
import './containers/editMeal.dart';
import './containers/editActivity.dart';
import './containers/viewMembers.dart';
import './containers/editMember.dart';
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
              // Default homepage route. Redirects to the dashboard if the user is authenticated
              new Route(
                path: Routes.home,
                componentFactory: (_) => _renderHome(),
                useAsDefault: true,
              ),
              // resetContinue is for password reset continuation
              new Route(path: Routes.resetContinue, componentFactory: (params) => _renderResetContinue(params)),

              // loginRedirect is for redirects to log in the user
              new Route(path: Routes.loginRedirect, componentFactory: (params) => _renderLoginRedirect(params)),
              new Route(
                path: Routes.dashboard,
                componentFactory: (_) => _renderIfAuthenticated(_renderDashboard()),
              ),
              new Route(
                path: Routes.createMember,
                componentFactory: (params) => _renderIfAuthenticated(_renderCreateMember()),
              ),
              new Route(path: Routes.resetContinue, componentFactory: (params) => _renderResetContinue(params)),
              new Route(path: Routes.dashboard, componentFactory: (_) => _renderIfAuthenticated(_renderDashboard())),
              new Route(
                path: Routes.viewMembers,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewMembers()),
              ),
              new Route(
                path: Routes.createAct,
                componentFactory: (_) => _renderNewActivity(),
              ),
              new Route(
                path: Routes.createMeal,
                componentFactory: (_) => _renderNewMeal(),
              ),
              new Route(
                  path: Routes.editMember,
                  componentFactory: (params) => _renderIfAuthenticated(_renderEditMember(params))),
              new Route(
                  path: Routes.editMeal, componentFactory: (params) => _renderIfAuthenticated(_renderEditMeal(params))),
              new Route(
                  path: Routes.editActivity,
                  componentFactory: (params) => _renderIfAuthenticated(_renderEditActivity(params))),
              new Route(
                  path: Routes.viewActivity, componentFactory: (_) => _renderIfAuthenticated(_renderViewActivity())),
              new Route(path: Routes.viewMeal, componentFactory: (_) => _renderIfAuthenticated(_renderViewMeal())),
            ],
          ),
        ],
      // new Footer(new FooterProps()..actions = props.storeContainer.store.actions),
      _renderDebug(),
    ];

  //Method used to render the newMeal page
  _renderNewMeal() => new NewMeal(new NewMealProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  //Method used to render the newActivity page
  _renderNewActivity() => new NewActivity(new NewActivityProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  ///Method used to render the CreateMember page
  _renderCreateMember() => new NewMember(new NewMemberProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  // Only renders if the user is properly authenticated. Otherwise, bail to the homepage
  _renderIfAuthenticated(VNode page) {
    if (appState.authState == AuthState.LOADING) return _renderLoading();
    return appState.authState == AuthState.SUCCESS ? page : _redirectForAuthentication(history.path);
  }

  // Helper for performing quick redirects, typically in the case of fresh authentication
  _redirectForAuthentication(String nextRoute) {
    new Future.delayed(Duration(milliseconds: 10), (() => history.push(Routes.generateLoginRedirect(nextRoute))));
    return new VDivElement();
  }

  // A redirect to the homepage, used for passing custom messages into the homepage
  _renderResetContinue(Map<String, String> params) => _renderHome(
      redirectCode: 'Password reset successful. Please enter your new password below.',
      emailPrefill: baseToString(params['email_hash']));

  _renderLoading() => new Loading(new LoadingProps()..actions = actions);

  _renderLoginRedirect(Map<String, String> params) =>
      _renderHome(redirectCode: 'Please log in to continue.', nextUrl: baseToString(params['next_url']));

  _renderHome({String redirectCode, String emailPrefill, String nextUrl}) => new Home(new HomeProps()
    ..actions = props.storeContainer.store.actions
    ..authState = appState.authState
    ..redirectCode = redirectCode ?? ''
    ..emailPrefill = emailPrefill ?? ''
    ..nextUrl = nextUrl ?? Routes.dashboard);

  _renderDashboard() => new Dashboard(new DashboardProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  _renderViewMembers() => new ViewMembers(new ViewMembersProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..userMap = appState.userMap);

  _renderEditMember(Map<String, String> params) => new EditMember(new EditMemberProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..userMap = appState.userMap
    ..selectedMemberUID = params['user_uid']);

  _renderEditMeal(Map<String, String> params) => new EditMeal(new EditMealProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..mealMap = appState.mealMap
    ..selectedMealUID = params['meal_uid']);

  _renderEditActivity(Map<String, String> params) => new EditActivity(new EditActivityProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..activityMap = appState.activityMap
    ..selectedActivityUID = params['activity_uid']);

  _renderViewActivity() => new ViewActivity(new ViewActivityProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..activityMap = appState.activityMap);

  _renderViewMeal() => new ViewMeal(new ViewMealProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..mealMap = appState.mealMap);

  _renderDebug() => (document.domain.contains("localhost"))
      ? new DebugNavigator(new DebugNavigatorProps()..actions = props.storeContainer.store.actions)
      : new Vspan();
}
