import 'dart:async';

// External Dependencies
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

// pages and components

// Basic Pages
import './pages/general/dashboard.dart';
import './pages/general/home.dart';
import './pages/general/loading.dart';

// Add pages
import './pages/new/activity.dart';
import './pages/new/meal.dart';
import './pages/new/member.dart';

// Edit pages
import './pages/edit/activity.dart';
import './pages/edit/meal.dart';
import './pages/edit/member.dart';

// View pages (list views)
import './pages/view/activities.dart';
import './pages/view/meals.dart';
import './pages/view/members.dart';
import './pages/view/shifts.dart';

// State and constants
import '../state/app.dart';
import '../constants.dart';
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
              new Route(
                path: Routes.home,
                componentFactory: (_) => _renderHome(),
                useAsDefault: true,
              ),
              // The dashboard is the logged-in homepage
              new Route(
                path: Routes.dashboard,
                componentFactory: (_) => _renderIfAuthenticated(_renderDashboard()),
              ),

              // Creation pages
              new Route(
                path: Routes.createMember,
                componentFactory: (params) => _renderIfAuthenticated(_renderCreateMember()),
              ),
              new Route(
                path: Routes.createAct,
                componentFactory: (_) => _renderNewActivity(),
              ),
              new Route(
                path: Routes.createMeal,
                componentFactory: (_) => _renderNewMeal(),
              ),

              // View Pages
              new Route(
                path: Routes.viewMembers,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewMembers()),
              ),
              new Route(
                path: Routes.viewActivity,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewActivity()),
              ),
              new Route(
                path: Routes.viewMeal,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewMeal()),
              ),
              new Route(
                path: Routes.viewShifts,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewShifts()),
              ),
              new Route(
                path: Routes.viewAllShifts,
                componentFactory: (_) => _renderIfAuthenticated(_renderViewAllShifts()),
              ),

              // Edit pages
              new Route(
                path: Routes.editMember,
                componentFactory: (params) => _renderIfAuthenticated(_renderEditMember(params)),
              ),
              new Route(
                path: Routes.editMeal,
                componentFactory: (params) => _renderIfAuthenticated(_renderEditMeal(params)),
              ),
              new Route(
                path: Routes.editActivity,
                componentFactory: (params) => _renderIfAuthenticated(_renderEditActivity(params)),
              ),

              // Misc pages
              new Route(
                path: Routes.activitySignUp,
                componentFactory: (params) => _renderIfAuthenticated(_renderSignUpActivity(params)),
              ),
              // resetContinue is for password reset continuation
              new Route(
                path: Routes.resetContinue,
                componentFactory: (params) => _renderResetContinue(params),
              ),
              // loginRedirect is for redirects to log in the user
              new Route(
                path: Routes.loginRedirect,
                componentFactory: (params) => _renderLoginRedirect(params),
              ),
            ],
          ),
        ],
      // new Footer(new FooterProps()..actions = props.storeContainer.store.actions),
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
    ..user = appState.user
    ..userShiftList = appState.userShiftList);

  _renderViewMembers() => new ViewMembers(new ViewMembersProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..activityMap = appState.activityMap
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
    ..userMap = appState.userMap
    ..activityMap = appState.activityMap
    ..selectedActivityUID = params['activity_uid']);

  _renderViewActivity() => new ViewActivity(new ViewActivityProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..activityMap = appState.activityMap
    ..selectedMemberUID = appState.user.docUID
    ..signUp = false);

  _renderSignUpActivity(Map<String, String> params) => new ViewActivity(new ViewActivityProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..activityMap = appState.activityMap
    ..selectedMemberUID = params['user_uid']
    ..signUp = true);

  _renderViewMeal() => new ViewMeal(new ViewMealProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..mealMap = appState.mealMap);

  _renderViewShifts() => new ViewShift(new ViewShiftProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..shiftList = appState.userShiftList
    ..allShifts = false
    ..userMap = appState.userMap);

  _renderViewAllShifts() => new ViewShift(new ViewShiftProps()
    ..actions = props.storeContainer.store.actions
    ..user = appState.user
    ..shiftList = appState.shiftList
    ..allShifts = true
    ..userMap = appState.userMap);
}
