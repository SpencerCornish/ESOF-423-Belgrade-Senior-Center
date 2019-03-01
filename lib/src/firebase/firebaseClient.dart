import 'dart:async';
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
    User newUser = fbUser != null ? await _userLoginEvent(fbUser) : null;

    _actions.setUser(newUser);
    _actions.setAuthState(newUser == null ? AuthState.INAUTHENTIC : AuthState.SUCCESS);
  }

  Future _userLoginEvent(fb.User userPayload) async {
    //TODO: Set up emergency contacts
    User newUser;
    fs.DocumentSnapshot userDbData = await _refs.user(userPayload.uid).get();
    if (!userDbData.exists) {
      newUser = (new UserBuilder()
            ..uid = userPayload.uid
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

      addOrUpdateUser(newUser.toFirestore(), documentID: userPayload.uid);
    } else {
      newUser = new User.fromFirebase(
        userDbData.data(),
        new BuiltList<EmergencyContact>(),
        id: userPayload.uid,
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
        id: doc.id,
      );
    }
    return new BuiltMap<String, User>.from(dataSet);
  }

  /// [getMember] get just one member document by unique identifier
  getMember(String uid) => _refs.user(uid).get();

  // getMeals (TODO: by date/date range?)

  /// [getAllMeals] get all meal documents
  getAllMeals() => _refs.allMeals().get();

  /// [getMeal] get just one meal document by unique identifier
  getMeal(String uid) => _refs.meal(uid).get();

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

  /// [updateUser] update existing user by unique identifier. key is any user field and value is the new value
  String addOrUpdateUser(Map<String, dynamic> userData, {String documentID}) {
    fs.DocumentReference ref = _refs.user(documentID);
    ref.set(userData, fs.SetOptions(merge: true));

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
    _refs.user(documentID).delete();
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
