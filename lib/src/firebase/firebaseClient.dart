import 'dart:async';
import 'package:firebase/firestore.dart' as fs;
import 'package:firebase/firebase.dart' as fb;

import 'package:built_collection/built_collection.dart';

import '../state/app.dart';
import './firebaseSubscriber.dart';
import './dbRefs.dart';
import '../constants.dart';

import '../model/user.dart';
import '../model/meal.dart';
import '../model/activity.dart';
import '../model/emergencyContact.dart';

class FirebaseClient {
  final DbRefs _refs;
  final AppActions _actions;
  final FirebaseSubscriber _firebaseSubscriber;
  final fb.Auth _auth;

  FirebaseClient(this._refs, this._auth, this._actions, this._firebaseSubscriber) {
    // This will eventually listen to changes for the user/class/text listener

    _auth.onAuthStateChanged.listen(_onAuthChanged);
  }

  Future _onAuthChanged(fb.User fbUser) async {
    User newUser = fbUser != null ? await _userLoginEvent(fbUser) : null;

    _actions.setUser(newUser);
    _actions.setAuthState(newUser == null ? AuthState.INAUTHENTIC : AuthState.SUCCESS);
  }

  Future _userLoginEvent(fb.User userPayload) async {
    //TODO: Set up emergency contacts
    User newUser;

    fs.QuerySnapshot queryData = await _refs.userFromLoginUID(userPayload.uid).get();
    List<fs.DocumentSnapshot> userDocs = queryData.docs;
    if (userDocs.length > 1) {
      print("WARNING: login UID conflict!");
    }
    fs.DocumentSnapshot userDbData;
    if (userDocs.length != 0) {
      userDbData = userDocs.first;
    }

    if (userDbData == null) {
      // The user is not in our datastore, but has a login, so create a new datastorage document for them
      newUser = (new UserBuilder()
            ..loginUID = userPayload.uid
            ..firstName = ''
            ..lastName = ''
            ..email = userPayload.email
            ..phoneNumber = ''
            ..mobileNumber = ''
            ..address = ''
            ..role = ''
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

      addOrUpdateUser(newUser.toFirestore());
    } else {
      // The user exists in the database, so hydrate a data model for them
      newUser = new User.fromFirebase(
        userDbData.data(),
        new BuiltList<EmergencyContact>(),
        docUID: userDbData.id,
        loginUID: userPayload.uid,
        email: userPayload.email,
      );
    }
    return newUser;
  }

  Future logOut() async => _auth.signOut();

  Future signInAdmin(String email, String password) async {
    await _actions.setAuthState(AuthState.LOADING);
    try {
      await _auth.signInWithEmailAndPassword(email, password);
    } on fb.FirebaseError catch (e) {
      if (e.code == "auth/user-not-found") {
        _actions.setAuthState(AuthState.ERR_NOT_FOUND);
      } else if (e.code == "auth/wrong-password") {
        _actions.setAuthState(AuthState.ERR_PASSWORD);
      } else {
        _actions.setAuthState(AuthState.ERR_OTHER);
      }
    } catch (e) {
      _actions.setAuthState(AuthState.ERR_OTHER);
    }
  }

  void resetPassword(String email) {
    _auth.sendPasswordResetEmail(email,
        new fb.ActionCodeSettings(url: "https://bsc-development.firebaseapp.com/pw_reset/${stringToBase(email)}"));
    _actions.setAuthState(AuthState.PASS_RESET_SENT);
  }

  // getMembers (TODO: with role or all?)

  /// [getAllMembers] get all member documents
  Future<BuiltMap<String, User>> getAllMembers() async {
    Map<String, User> dataSet = <String, User>{};
    fs.QuerySnapshot result = await _refs.allUsers().get();
    for (fs.DocumentSnapshot doc in result.docs) {
      dataSet[doc.id] = new User.fromFirebase(
        doc.data(),
        new BuiltList<EmergencyContact>(),
        docUID: doc.id,
      );
    }
    return new BuiltMap<String, User>.from(dataSet);
  }

  // getMeals (TODO: by date/date range?)

  /// [getAllMeals] get all meal documents
  Future<BuiltMap<String, Meal>> getAllMeals() async {
    Map<String, Meal> dataSet = <String, Meal>{};
    fs.QuerySnapshot result = await _refs.allMeals().get();
    for (fs.DocumentSnapshot doc in result.docs) {
      dataSet[doc.id] = new Meal.fromFirebase(
        doc.data(),
        uid: doc.id,
      );
    }
    return new BuiltMap<String, Meal>.from(dataSet);
  }

  /// [getMeal] get just one meal document by unique identifier
  getMeal(String uid) => _refs.meal(uid).get();

  /// [getAllActivities] this will get all class documents
  Future<BuiltMap<String, Activity>> getAllActivities() async {
    Map<String, Activity> dataSet = <String, Activity>{};
    fs.QuerySnapshot result = await _refs.allActivities().get();
    for (fs.DocumentSnapshot doc in result.docs) {
      print(doc.data());
      dataSet[doc.id] = new Activity.fromFirebase(
        doc.data(),
        uid: doc.id,
      );
    }
    return new BuiltMap<String, Activity>.from(dataSet);
  }

  /// [getClassByStartDate] return a group of documents by start date
  getClassByStartDate(DateTime date) {
    final start = new DateTime(date.year, date.month, date.day);
    final end = new DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _refs
        .allActivities()
        .where("start_time", "=>", start.toIso8601String())
        .where("start_time", "<=", end.toIso8601String());
  }

  /// [getClassTaughtBy] return a group of documents by instructor
  getClassTaughtBy(String instructor) => _refs.allActivities().where("instructor", "==", instructor);

  /// [getClass] get a single class document by unique identifier
  // getClass(String uid) => _refs.singleClass(uid).get();

  /// [updateUser] update existing user by unique identifier. key is any user field and value is the new value
  String addOrUpdateUser(Map<String, dynamic> userData, {String documentID}) {
    fs.DocumentReference ref = _refs.userFromDocumentUID(documentID);
    ref.set(userData, fs.SetOptions(merge: true));
    return ref.id;
  }

  /// [updateActivity]
  String addOrUpdateActivity(Map<String, dynamic> activityData, {String documentID}) {
    fs.DocumentReference ref = _refs.singleClass(documentID);
    ref.set(activityData, fs.SetOptions(merge: true));
    return ref.id;
  }

  ///[updateMeal]
  String addOrUpdateMeal(Map<String, dynamic> mealData, {String documentID}) {
    fs.DocumentReference ref = _refs.meal(documentID);
    ref.set(mealData, fs.SetOptions(merge: true));
    return ref.id;
  }

  /// [updateClass] update existing class by unique identifier. key is any class field and value is the new value
  void updateClass(String documentID, Map<String, dynamic> value) {
    _refs.singleClass(documentID).set(value, fs.SetOptions(merge: true));
  }

  /// [updateMeal] update existing meal by unique identifier. key is any meal field and value is the new value
  void updateMeal(String documentID, Map<String, dynamic> value) {
    _refs.meal(documentID).set(value, fs.SetOptions(merge: true));
  }

  /// [deleteUser] delete existing user by unique identifier
  void deleteUser(String documentID) {
    _refs.userFromDocumentUID(documentID).delete();
  }

  /// [deleteClass] delete existing class by unique identifier
  void deleteClass(String documentID) {
    _refs.singleClass(documentID).delete();
  }

  /// [deleteMeal] delete existing meal by unique identifier
  void deleteMeal(String documentID) {
    _refs.meal(documentID).delete();
  }
}
