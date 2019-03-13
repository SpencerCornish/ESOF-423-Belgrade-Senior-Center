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
import './containers/viewMember.dart';
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
    // Get all the users from the database
    actions.server.fetchAllMembers();

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
              new Route(
                path: Routes.viewMember,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewMember()),
              ),
            ],
          ),
        ],
      // new Footer(new FooterProps()..actions = props.storeContainer.store.actions),
      _renderDebug(),
    ];

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

  /// Method used to render the CreateMember page
  _renderCreateMember() => new NewMember(new NewMemberProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user);

  _renderViewMember() => new viewMember(new viewMemberProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..userMap = appState.userMap);

  _renderDebug() => (document.domain.contains("localhost"))
      ? new DebugNavigator(new DebugNavigatorProps()..actions = props.storeContainer.store.actions)
      : new Vspan();
}
