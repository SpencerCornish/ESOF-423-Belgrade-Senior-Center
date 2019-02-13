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

  Future _onAuthChanged(fb.User user) async {
    print("Auth Changed :: $user");
  }

  // getMembers (TODO: with role or all?)
  //this will get all
  getAllMembers() => _refs.allUsers().get();
  //...and just one
  getMember(String uid) => _refs.user(uid).get();

  // getMeals (TODO: by date/date range?)
  //this will get all
  getAllMeals() => _refs.allMeals().get();
  //...and just one
  getMeal(String uid) => _refs.meal(uid).get();

  // getClasses (TODO: by day, range?)
  //this will get all
  getAllClasses() => _refs.allClasses().get();
  //...and just one
  getclass(String uid) => _refs.singleClass(uid).get();

  //create new user/class/meal
  createUser(String name, String email, String phone, String password, String role, List classes) {
    _refs.allUsers().add({"name": name, "email": email, "phone_number": phone, "password": password, "role": role});
  }

  createClass(String name, String start, String end, String instructor, String location, int capacity) {
    _refs.allClasses().add({
      "name": name,
      "start_time": start,
      "end_time": end,
      "instructor": instructor,
      "location": location,
      "capacity": capacity
    });
  }

  createMeal(String start, String end, List menu) {
    _refs.allMeals().add({"start_time": start, "end_time": end, "menu": menu});
  }

  //update existing user/class/meal
  updateUser(String documentID, String key, Object value) {
    _refs.user(documentID).set(key, value, merge: true);
  }

  updateClass(String documentID, String key, Object value) {
    _refs.singleClass(documentID).set(key, value, merge: true);
  }

  updateMeal(String documentID, String key, Object value) {
    _refs.meal(documentID).set(key: value, merge: true);
  }

  //delete existing
  deleteUser(String documentID) {
    _refs.user(documentID).delete();
  }

  deleteClass(String documentID) {
    _refs.singleClass(documentID).delete();
  }

  deleteMeal(String documentID) {
    _refs.meal(documentID).delete();
  }
}
