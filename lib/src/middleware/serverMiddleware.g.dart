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
  final ActionDispatcher<String> resetPassword =
      new ActionDispatcher<String>('ServerMiddlewareActions-resetPassword');
  final ActionDispatcher<User> updateOrCreateUser =
      new ActionDispatcher<User>('ServerMiddlewareActions-updateOrCreateUser');
  final ActionDispatcher<Activity> updateOrCreateActivity =
      new ActionDispatcher<Activity>(
          'ServerMiddlewareActions-updateOrCreateActivity');
  final ActionDispatcher<Meal> updateOrCreateMeal =
      new ActionDispatcher<Meal>('ServerMiddlewareActions-updateOrCreateMeal');
  final ActionDispatcher<Null> fetchAllMembers =
      new ActionDispatcher<Null>('ServerMiddlewareActions-fetchAllMembers');
  final ActionDispatcher<Null> fetchAllActivities =
      new ActionDispatcher<Null>('ServerMiddlewareActions-fetchAllActivities');
  final ActionDispatcher<Null> fetchAllMeals =
      new ActionDispatcher<Null>('ServerMiddlewareActions-fetchAllMeals');
  final ActionDispatcher<Null> fetchAllShifts =
      new ActionDispatcher<Null>('ServerMiddlewareActions-fetchAllShifts');
  final ActionDispatcher<int> fetchShiftsForUser =
      new ActionDispatcher<int>('ServerMiddlewareActions-fetchShiftsForUser');
  final ActionDispatcher<bool> registerClockEvent =
      new ActionDispatcher<bool>('ServerMiddlewareActions-registerClockEvent');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    signInAdmin.setDispatcher(dispatcher);
    logOut.setDispatcher(dispatcher);
    resetPassword.setDispatcher(dispatcher);
    updateOrCreateUser.setDispatcher(dispatcher);
    updateOrCreateActivity.setDispatcher(dispatcher);
    updateOrCreateMeal.setDispatcher(dispatcher);
    fetchAllMembers.setDispatcher(dispatcher);
    fetchAllActivities.setDispatcher(dispatcher);
    fetchAllMeals.setDispatcher(dispatcher);
    fetchAllShifts.setDispatcher(dispatcher);
    fetchShiftsForUser.setDispatcher(dispatcher);
    registerClockEvent.setDispatcher(dispatcher);
  }
}

class ServerMiddlewareActionsNames {
  static final ActionName<AdminSignInPayload> signInAdmin =
      new ActionName<AdminSignInPayload>('ServerMiddlewareActions-signInAdmin');
  static final ActionName<Null> logOut =
      new ActionName<Null>('ServerMiddlewareActions-logOut');
  static final ActionName<String> resetPassword =
      new ActionName<String>('ServerMiddlewareActions-resetPassword');
  static final ActionName<User> updateOrCreateUser =
      new ActionName<User>('ServerMiddlewareActions-updateOrCreateUser');
  static final ActionName<Activity> updateOrCreateActivity =
      new ActionName<Activity>(
          'ServerMiddlewareActions-updateOrCreateActivity');
  static final ActionName<Meal> updateOrCreateMeal =
      new ActionName<Meal>('ServerMiddlewareActions-updateOrCreateMeal');
  static final ActionName<Null> fetchAllMembers =
      new ActionName<Null>('ServerMiddlewareActions-fetchAllMembers');
  static final ActionName<Null> fetchAllActivities =
      new ActionName<Null>('ServerMiddlewareActions-fetchAllActivities');
  static final ActionName<Null> fetchAllMeals =
      new ActionName<Null>('ServerMiddlewareActions-fetchAllMeals');
  static final ActionName<Null> fetchAllShifts =
      new ActionName<Null>('ServerMiddlewareActions-fetchAllShifts');
  static final ActionName<int> fetchShiftsForUser =
      new ActionName<int>('ServerMiddlewareActions-fetchShiftsForUser');
  static final ActionName<bool> registerClockEvent =
      new ActionName<bool>('ServerMiddlewareActions-registerClockEvent');
}
