import 'dart:async';

// External Dependencies
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../constants.dart';

// Containers and components
import './containers/home.dart';
import './containers/dashboard.dart';
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
              // Default homepage route
              new Route(
                path: Routes.home,
                componentFactory: (params) => appState.user == null ? _renderHome() : _redirect(Routes.dashboard),
                useAsDefault: true, // if no route is matched this route will be used
              ),
              new Route(path: Routes.resetContinue, componentFactory: (params) => _renderResetContinue(params)),
              new Route(
                path: Routes.dashboard,
                componentFactory: (params) => _renderDashboard(),
              ),
            ],
          ),
        ],
      // new Footer(new FooterProps()..actions = props.storeContainer.store.actions),
      new DebugNavigator(new DebugNavigatorProps()..actions = props.storeContainer.store.actions),
    ];

  _redirect(String newRoute) {
    new Future.delayed(Duration(milliseconds: 100), (() => history.push(newRoute)));
    return new VDivElement();
  }

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
}
