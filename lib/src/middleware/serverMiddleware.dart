library serverMiddleware;

import 'package:built_redux/built_redux.dart';

import '../firebase/firebaseClient.dart';
import '../state/app.dart';

import '../model/user.dart';
import '../model/activity.dart';
import '../model/meal.dart';
import '../constants.dart';

part 'serverMiddleware.g.dart';

class AdminSignInPayload {
  String email;
  String password;

  AdminSignInPayload(this.email, this.password);
}

// Actions to be handled ONLY by this middleware
abstract class ServerMiddlewareActions extends ReduxActions {
  /// [signInAdmin] starts the sign in process for administrators
  ActionDispatcher<AdminSignInPayload> signInAdmin;

  /// [logOut] deauths the current user
  ActionDispatcher<Null> logOut;

  /// [resetPassword] attempts to send a reset email to the provided email
  ActionDispatcher<String> resetPassword;

  /// [updateOrCreateUser] attempts to update a user record. If it is unsuccessful, it creates a new one.
  ActionDispatcher<User> updateOrCreateUser;

  /// [addOrCreateActivity] attempts to update an activity. If it is unsuccessful, it creates a new one.
  ActionDispatcher<Activity> updateOrCreateActivity;

  /// [updateOrCreateMeal] attempts to update a meal. If it is unsuccessful, it creates a new one.
  ActionDispatcher<Meal> updateOrCreateMeal;

  // TODO: Authenticate this call
  /// [fetchAllMembers] fetches the list of all Members in the database.
  ActionDispatcher<Null> fetchAllMembers;

  // TODO: Authenticate this call
  /// [fetchAllActivities] fetches the list of all Activities in the database.
  ActionDispatcher<Null> fetchAllActivities;

  // TODO: Authenticate this call
  /// [fetchAllMeals] fetches the list of all meals in the database.
  ActionDispatcher<Null> fetchAllMeals;

  ServerMiddlewareActions._();
  factory ServerMiddlewareActions() => new _$ServerMiddlewareActions();
}

createServerMiddleware(FirebaseClient client) => (new MiddlewareBuilder<App, AppBuilder, AppActions>()
      ..add<AdminSignInPayload>(ServerMiddlewareActionsNames.signInAdmin, _signInAdmin(client))
      ..add<Null>(ServerMiddlewareActionsNames.logOut, _logOut(client))
      ..add<String>(ServerMiddlewareActionsNames.resetPassword, _resetPassword(client))
      ..add<User>(ServerMiddlewareActionsNames.updateOrCreateUser, _addOrUpdateUser(client))
      ..add<Activity>(ServerMiddlewareActionsNames.updateOrCreateActivity, _addOrUpdateActivity(client))
      ..add<Meal>(ServerMiddlewareActionsNames.updateOrCreateMeal, _addOrUpdateMeal(client))
      ..add<Null>(ServerMiddlewareActionsNames.fetchAllMembers, _fetchAllMembers(client))
      ..add<Null>(ServerMiddlewareActionsNames.fetchAllActivities, _fetchAllActivities(client))
      ..add<Null>(ServerMiddlewareActionsNames.fetchAllMeals, _fetchAllMeals(client)))
    .build();

_signInAdmin(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<AdminSignInPayload> action,
    ) async =>
        client.signInAdmin(action.payload.email, action.payload.password);

_logOut(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<Null> action,
    ) async =>
        client.logOut();

_resetPassword(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<String> action,
    ) async =>
        client.resetPassword(action.payload);

_addOrUpdateUser(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<User> action,
    ) async {
      client.addOrUpdateUser(
        action.payload.toFirestore(),
        documentID: action.payload.docUID,
      );
    };

_addOrUpdateActivity(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<Activity> action,
    ) async {
      client.addOrUpdateActivity(
        action.payload.toFirestore(),
        documentID: action.payload.uid,
      );
    };

_addOrUpdateMeal(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<Meal> action,
    ) async {
      client.addOrUpdateMeal(
        action.payload.toFirestore(),
        documentID: action.payload.uid,
      );
    };

_fetchAllMembers(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<Null> action,
    ) async {
      final memberMap = await client.getAllMembers();
      api.actions.setUserMap(memberMap);
    };

_fetchAllActivities(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<Null> action,
    ) async {
      final activityMap = await client.getAllActivities();
      api.actions.setActivityMap(activityMap);
    };

_fetchAllMeals(FirebaseClient client) => (
      MiddlewareApi<App, AppBuilder, AppActions> api,
      ActionHandler next,
      Action<Null> action,
    ) async {
      final meals = await client.getAllMeals();
      api.actions.setMealMap(meals);
    };
