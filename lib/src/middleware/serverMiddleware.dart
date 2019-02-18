library serverMiddleware;

import 'package:built_redux/built_redux.dart';
import 'package:built_collection/built_collection.dart';
import 'package:firebase/firebase.dart' as fb;

import '../constants.dart';
import '../firebase/firebaseClient.dart';
import '../state/app.dart';

import '../model/user.dart';

part 'serverMiddleware.g.dart';

class AdminSignInPayload {
  String email;
  String password;

  AdminSignInPayload(this.email, this.password);
}

// Actions to be handled ONLY by this middleware
abstract class ServerMiddlewareActions extends ReduxActions {
  ActionDispatcher<AdminSignInPayload> signInAdmin;
  ActionDispatcher<Null> logOut;
  ActionDispatcher<String> resetPassword;
  ServerMiddlewareActions._();
  factory ServerMiddlewareActions() => new _$ServerMiddlewareActions();
}

createServerMiddleware(FirebaseClient client) => (new MiddlewareBuilder<App, AppBuilder, AppActions>()
      ..add<AdminSignInPayload>(ServerMiddlewareActionsNames.signInAdmin, _signInAdmin(client))
      ..add<Null>(ServerMiddlewareActionsNames.logOut, _logOut(client))
      ..add<String>(ServerMiddlewareActionsNames.resetPassword, _resetPassword(client)))
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
