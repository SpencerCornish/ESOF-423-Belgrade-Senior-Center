import 'package:bsc/src/constants.dart';
import 'package:bsc/src/model/activity.dart';
import 'package:bsc/src/model/emergencyContact.dart';
import 'package:bsc/src/model/meal.dart';
import 'package:built_redux/built_redux.dart';
import 'package:test/test.dart';
import 'package:bsc/src/state/app.dart';
import 'package:bsc/src/model/user.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  //Vars for testing
  group('App -', () {
    Store<App, AppBuilder, AppActions> store;
    User newUser;
    Activity newActivity;
    Meal newMeal;

    //Creates a new store based on the template in store.dart
    setUp(() {
      var actions = new AppActions();
      var defaultValue = new App();
      store = new Store<App, AppBuilder, AppActions>(reducerBuilder.build(), defaultValue, actions);

      newUser = (new UserBuilder()
            ..firstName = ''
            ..lastName = ''
            ..email = "test@test.com"
            ..phoneNumber = ''
            ..mobileNumber = ''
            ..address = ''
            ..role = ''
            ..homeDeliver = false
            ..medRelease = false
            ..waiverRelease = false
            ..intakeForm = false
            ..dietaryRestrictions = ''
            ..emergencyContacts = new ListBuilder<EmergencyContact>()
            ..membershipStart = new DateTime.fromMillisecondsSinceEpoch(0)
            ..membershipRenewal = new DateTime.fromMillisecondsSinceEpoch(0)
            ..disabilities = ''
            ..forms = new ListBuilder<String>()
            ..medicalIssues = ''
            ..position = ''
            ..services = new ListBuilder<String>())
          .build();

      newActivity = (new ActivityBuilder()
            ..capacity = 0
            ..endTime = new DateTime.fromMicrosecondsSinceEpoch(0)
            ..startTime = new DateTime.fromMicrosecondsSinceEpoch(0)
            ..instructor = ""
            ..location = ""
            ..name = "")
          .build();

      newMeal = (new MealBuilder()
            ..startTime = new DateTime.fromMicrosecondsSinceEpoch(0)
            ..endTime = new DateTime.fromMicrosecondsSinceEpoch(0)
            ..menu = new BuiltList<String>(["", ""]).toBuilder())
          .build();
    });

    //Clean store object from memory after testing
    tearDown(() {
      store.dispose();
    });
    test('Test setUser reducer', () async {
      //Tests setUser
      expect(store.state.user, null);
      store.actions.setUser(newUser);
      expect(store.state.user, newUser);
    });
    test('Test setLoading reducer', () async {
      //Tests setLoading
      expect(store.state.isLoading, false);
      store.actions.setLoading(true);
      expect(store.state.isLoading, true);
    });
    test('Test setAuthState reducer', () async {
      //Tests setAuthState
      expect(store.state.authState, AuthState.LOADING);
      store.actions.setAuthState(AuthState.SUCCESS);
      expect(store.state.authState, AuthState.SUCCESS);
    });
    test('Test setUserMap reducer', () async {
      //Tests setUserMap
      BuiltMap testUserMap = new BuiltMap<String, User>({"bla": newUser});
      BuiltMap temp = new BuiltMap<String, User>();
      expect(store.state.userMap, temp);
      store.actions.setUserMap(testUserMap);
      expect(store.state.userMap, testUserMap);
    });
    test('Test setActivityMap reducer', () async {
      //Tests setActivityMap
      BuiltMap temp = new BuiltMap<String, Activity>();
      BuiltMap testActMap = new BuiltMap<String, Activity>({"bla": newActivity});
      expect(store.state.activityMap, temp);
      store.actions.setActivityMap(testActMap);
      expect(store.state.activityMap, testActMap);
    });
    test('Test setMealMap reducer', () async {
      //Tests setMealMap
      BuiltMap temp = new BuiltMap<String, Meal>();
      BuiltMap testMealMap = new BuiltMap<String, Meal>({"bla": newMeal});
      expect(store.state.mealMap, temp);
      store.actions.setMealMap(testMealMap);
      expect(store.state.mealMap, testMealMap);
    });
  });
}
