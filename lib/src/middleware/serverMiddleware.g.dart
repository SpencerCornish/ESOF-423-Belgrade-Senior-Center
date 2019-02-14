// GENERATED CODE - DO NOT MODIFY BY HAND

part of serverMiddleware;

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides

class _$ServerMiddlewareActions extends ServerMiddlewareActions {
  factory _$ServerMiddlewareActions() => new _$ServerMiddlewareActions._();
  _$ServerMiddlewareActions._() : super._();

  final ActionDispatcher<AdminSignInPayload> signInAdmin =
      new ActionDispatcher<AdminSignInPayload>(
          'ServerMiddlewareActions-signInAdmin');
  final ActionDispatcher<Null> logOut =
      new ActionDispatcher<Null>('ServerMiddlewareActions-logOut');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    signInAdmin.setDispatcher(dispatcher);
    logOut.setDispatcher(dispatcher);
  }
}

class ServerMiddlewareActionsNames {
  static final ActionName<AdminSignInPayload> signInAdmin =
      new ActionName<AdminSignInPayload>('ServerMiddlewareActions-signInAdmin');
  static final ActionName<Null> logOut =
      new ActionName<Null>('ServerMiddlewareActions-logOut');
}
