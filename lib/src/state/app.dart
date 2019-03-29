library app;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_redux/built_redux.dart';

import '../middleware/serverMiddleware.dart';

import '../model/activity.dart';
import '../model/meal.dart';
import '../model/user.dart';
import '../model/shift.dart';

import '../constants.dart';

part 'app.g.dart';

abstract class AppActions extends ReduxActions {
  /// [setUser] sets the current user
  ActionDispatcher<User> get setUser;

  /// [setLoading] sets the UI to a loading state
  ActionDispatcher<bool> get setLoading;

  /// [setAuthState] sets the authentication to the correct state
  ActionDispatcher<AuthState> get setAuthState;

  /// [setUserMap] sets the Map of filtered users on the client
  ActionDispatcher<BuiltMap<String, User>> get setUserMap;

  /// [setActivityMap] sets the Map of filtered Activities on the client
  ActionDispatcher<BuiltMap<String, Activity>> get setActivityMap;

  /// [setMealMap] sets the Map of filtered Meals on the client
  ActionDispatcher<BuiltMap<String, Meal>> get setMealMap;

  /// [setShiftList] sets the list of all shifts. Empty unless an admin.
  ActionDispatcher<BuiltList<Shift>> get setShiftList;

  /// [setShiftList] sets the list of all shifts of the user. Empty unless an admin or volunteer.
  ActionDispatcher<BuiltList<Shift>> get setUserShiftList;

  /// [server] is a reference to the actions specifically created
  /// for the server middleware
  ServerMiddlewareActions server;

  // factory to create on instance of the generated implementation of AppActions
  AppActions._();
  factory AppActions() => new _$AppActions();
}

/// All app state is stored within this immutable object.
/// When this object is regenerated on a state change, the UI updates.
abstract class App implements Built<App, AppBuilder> {
  /// [user] is the currently signed-in user
  @nullable
  User get user;

  /// [isLoading] is whether or not the UI should be in a loading state
  bool get isLoading;

  /// [authState] is the current state of user authentication flow.
  /// This primarily controls the UI for authentication
  AuthState get authState;

  ///////////////////
  ///Collections
  ///////////////////

  /// [userMap] is arbitrary Map of unique ID to user, based on applied filters
  BuiltMap<String, User> get userMap;

  /// [activityMap] is an arbitrary Map of unique ID to activities, based on applied filters
  BuiltMap<String, Activity> get activityMap;

  /// [mealMap] is an arbitrary Map of unique ID to meals, based on applied filters
  BuiltMap<String, Meal> get mealMap;

  /// [shiftList] is an arbitrary list of all shifts.
  BuiltList<Shift> get shiftList;

  /// [userShiftList] is a list of the user's shifts
  BuiltList<Shift> get userShiftList;

  // Built value constructor. The factory is returning the default state
  App._();
  factory App() => new _$App._(
        user: null,
        isLoading: false,
        authState: AuthState.LOADING,
        userMap: new BuiltMap<String, User>(),
        activityMap: new BuiltMap<String, Activity>(),
        mealMap: new BuiltMap<String, Meal>(),
        shiftList: new BuiltList<Shift>(),
        userShiftList: new BuiltList<Shift>(),
      );
}

// Where we map handler functions to their internal functions
final reducerBuilder = new ReducerBuilder<App, AppBuilder>()
  ..add<User>(AppActionsNames.setUser, _setUser)
  ..add<bool>(AppActionsNames.setLoading, _setLoading)
  ..add<AuthState>(AppActionsNames.setAuthState, _setAuthState)
  ..add<BuiltMap<String, User>>(AppActionsNames.setUserMap, _setUserMap)
  ..add<BuiltMap<String, Activity>>(AppActionsNames.setActivityMap, _setActivityMap)
  ..add<BuiltMap<String, Meal>>(AppActionsNames.setMealMap, _setMealMap)
  ..add<BuiltList<Shift>>(AppActionsNames.setShiftList, _setShiftList)
  ..add<BuiltList<Shift>>(AppActionsNames.setUserShiftList, _setUserShiftList);

_setUser(App state, Action<User> action, AppBuilder builder) => builder..user = action.payload?.toBuilder();

_setLoading(App state, Action<bool> action, AppBuilder builder) => builder.isLoading = action.payload;

_setAuthState(App state, Action<AuthState> action, AppBuilder builder) => builder.authState = action.payload;

_setUserMap(App state, Action<BuiltMap<String, User>> action, AppBuilder builder) =>
    builder.userMap = action.payload.toBuilder();

_setActivityMap(App state, Action<BuiltMap<String, Activity>> action, AppBuilder builder) =>
    builder.activityMap = action.payload.toBuilder();

_setMealMap(App state, Action<BuiltMap<String, Meal>> action, AppBuilder builder) =>
    builder.mealMap = action.payload.toBuilder();

_setShiftList(App state, Action<BuiltList<Shift>> action, AppBuilder builder) => 
    builder.shiftList = action.payload.toBuilder();

_setUserShiftList(App state, Action<BuiltList<Shift>> action, AppBuilder builder) => 
    builder.userShiftList = action.payload.toBuilder();
