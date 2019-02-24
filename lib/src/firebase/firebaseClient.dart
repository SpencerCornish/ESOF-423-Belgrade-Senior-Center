import 'dart:async';
import 'dart:convert';
import 'package:firebase/firestore.dart' as fs;
import 'package:firebase/firebase.dart' as fb;

import 'package:built_collection/built_collection.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';

import '../state/app.dart';
import './firebaseSubscriber.dart';
import './dbRefs.dart';
import '../constants.dart';

import '../model/user.dart';
import '../model/emergencyContact.dart';

class FirebaseClient {
  final DbRefs _refs;
  final AppActions _actions;
  final BrowserClient _httpClient;
  final FirebaseSubscriber _firebaseSubscriber;
  final fb.Auth _auth;
  final fb.GoogleAuthProvider _googleAuthProvider;

  FirebaseClient(this._refs, this._auth, this._actions, this._firebaseSubscriber)
      : _httpClient = new BrowserClient(),
        _googleAuthProvider = new fb.GoogleAuthProvider() {
    // This will eventually listen to changes for the user/class/text listener

    _auth.onAuthStateChanged.listen(_onAuthChanged);
  }

  Future _onAuthChanged(fb.User fbUser) async {
    User newUser;
    // Log in event
    fbUser != null ? await _userLoginEvent(fbUser) : await _userLogoutEvent(fbUser);

    _actions.setUser(newUser);
    _actions.setAuthState(fbUser == null ? AuthState.INAUTHENTIC : AuthState.SUCCESS);
  }

  Future _userLoginEvent(fb.User userPayload) async {
    fs.DocumentSnapshot userDbData = await _refs.user(userPayload.uid).get();
    if (!userDbData.exists) {
      // Create a new user here
    }
    // Retrieved data
    print(userDbData.data());
    // User cacheUser = new User.fromFirebase(userPayload, null, userDbData.data());

  }

  Future _userLogoutEvent(fb.User userPayload) async {}

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
    // TODO: Adjust this redurect url as needed.
    _auth.sendPasswordResetEmail(email,
        new fb.ActionCodeSettings(url: "https://bsc-development.firebaseapp.com/pw_reset/${stringToBase(email)}"));
    _actions.setAuthState(AuthState.PASS_RESET_SENT);
  }

  // getMembers (TODO: with role or all?)

  /// [getAllMembers] get all member documents
  getAllMembers() => _refs.allUsers().get();

  /// [getMember] get just one member document by unique identifier
  getMember(String uid) => _refs.user(uid).get();

  // getMeals (TODO: by date/date range?)

  /// [getAllMeals] get all meal documents
  getAllMeals() => _refs.allMeals().get();

  /// [getMeal] get just one meal document by unique identifier
  getMeal(String uid) => _refs.meal(uid).get();

  // getClasses (TODO: by range, by capacity?)

  /// [getAllClasses] this will get all class documents
  getAllClasses() => _refs.allClasses().get();

  /// [getClassByStartDate] return a group of documents by start date
  getClassByStartDate(DateTime date) {
    final start = new DateTime(date.year, date.month, date.day);
    final end = new DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _refs
        .allClasses()
        .where("start_time", "=>", start.toIso8601String())
        .where("start_time", "<=", end.toIso8601String());
  }

  /// [getClassTaughtBy] return a group of documents by instructor
  getClassTaughtBy(String instructor) => _refs.allClasses().where("instructor", "==", instructor);

  /// [getClass] get a single class document by unique identifier
  getClass(String uid) => _refs.singleClass(uid).get();

  /// [createUser] create new user document
  createUser(String name, String email, String phone, String password, String role, List classes) {
    _refs.allUsers().add({
      "name": name,
      "email": email,
      "phone_number": phone,
      "password": password,
      "role": role,
    });
  }

  /// [createClass] create new class document
  createClass(String name, DateTime start, DateTime end, String instructor, String location, int capacity) {
    _refs.allClasses().add({
      "name": name,
      "start_time": start.toIso8601String(),
      "end_time": end.toIso8601String(),
      "instructor": instructor,
      "location": location,
      "capacity": capacity,
    });
  }

  /// [createMeal] create new meal document
  createMeal(DateTime start, DateTime end, List menu) {
    _refs.allMeals().add({
      "start_time": start.toIso8601String(),
      "end_time": end.toIso8601String(),
      "menu": menu,
    });
  }

  /// [updateUser] update existing user by unique identifier. key is any user field and value is the new value
  updateUser(String documentID, Map<String, dynamic> value) {
    _refs.user(documentID).set(value, fs.SetOptions(merge: true));
  }

  /// [updateClass] update existing class by unique identifier. key is any class field and value is the new value
  updateClass(String documentID, Map<String, dynamic> value) {
    _refs.singleClass(documentID).set(value, fs.SetOptions(merge: true));
  }

  /// [updateMeal] update existing meal by unique identifier. key is any meal field and value is the new value
  updateMeal(String documentID, Map<String, dynamic> value) {
    _refs.meal(documentID).set(value, fs.SetOptions(merge: true));
  }

  /// [deleteUser] delete existing user by unique identifier
  deleteUser(String documentID) {
    _refs.user(documentID).delete();
  }

  /// [deleteClass] delete existing class by unique identifier
  deleteClass(String documentID) {
    _refs.singleClass(documentID).delete();
  }

  /// [deleteMeal] delete existing meal by unique identifier
  deleteMeal(String documentID) {
    _refs.meal(documentID).delete();
  }
}
