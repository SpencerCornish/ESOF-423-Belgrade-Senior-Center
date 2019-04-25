import 'package:bsc/src/constants.dart';
import 'package:bsc/src/model/activity.dart';
import 'package:bsc/src/model/meal.dart';
import 'package:bsc/src/model/user.dart';
import 'package:built_redux/built_redux.dart';
import 'package:test/test.dart';
import 'package:bsc/src/state/app.dart';
import 'package:built_collection/built_collection.dart';

import '../test_data.dart';

void main() {
  group('App -', () {
    Store<App, AppBuilder, AppActions> store;
    // Creates a new store based on the template in store.dart
    setUp(() {
      var actions = new AppActions();
      var defaultValue = new App();
      store = new Store<App, AppBuilder, AppActions>(reducerBuilder.build(), defaultValue, actions);
    });

    tearDown(() {
      store.dispose();
    });
    test('Test setUser reducer', () async {
      expect(store.state.user, null);
      store.actions.setUser(testUser);
      expect(store.state.user, testUser);
    });
    test('Test setLoading reducer', () async {
      expect(store.state.isLoading, false);
      store.actions.setLoading(true);
      expect(store.state.isLoading, true);
    });
    test('Test setAuthState reducer', () async {
      expect(store.state.authState, AuthState.LOADING);
      store.actions.setAuthState(AuthState.SUCCESS);
      expect(store.state.authState, AuthState.SUCCESS);
    });
    test('Test setUserMap reducer', () async {
      BuiltMap testUserMap = new BuiltMap<String, User>({"bla": testUser});
      BuiltMap temp = new BuiltMap<String, User>();
      expect(store.state.userMap, temp);
      store.actions.setUserMap(testUserMap);
      expect(store.state.userMap, testUserMap);
    });
    test('Test setActivityMap reducer', () async {
      BuiltMap temp = new BuiltMap<String, Activity>();
      BuiltMap testActMap = new BuiltMap<String, Activity>({"bla": testActivity});
      expect(store.state.activityMap, temp);
      store.actions.setActivityMap(testActMap);
      expect(store.state.activityMap, testActMap);
    });
    test('Test setMealMap reducer', () async {
      BuiltMap temp = new BuiltMap<String, Meal>();
      BuiltMap testMealMap = new BuiltMap<String, Meal>({"bla": testMeal});
      expect(store.state.mealMap, temp);
      store.actions.setMealMap(testMealMap);
      expect(store.state.mealMap, testMealMap);
    });
  });
}
