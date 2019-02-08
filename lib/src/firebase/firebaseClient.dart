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

  // getMembers (with role or all?)
  getMembers(){
    return _refs.userRef().get();
  }
  // getMeals (by date/date range?)
  getMeals(){
    return _refs.userRef().get();
  }
  // getClasses (by day, range?)
  getClasses(){
    return _refs.userRef().get();
  }

  //create new user/class/meal
  createUser(name, email, phone, password, role, classes){
      _refs.userRef().add({
        "name": name,
        "email": email,
        "phone_number": phone,
        "password": password,
        "role": role
      });
  }

  createClass(name, start, end, instructor, location, capacity){
      _refs.classRef().add({
        "name": name,
        "start_time": start,
        "end_time": end,
        "instructor": instructor,
        "location": location,
        "capacity": capacity
      });
  }

  createMeal(start, end, menu){
      _refs.mealRef().add({
        "start_time": start,
        "end_time": end,
        "menu": menu
      });
  }  
  //update existing user/class/meal (especially date)
  updateUser(String documentID, String key, value){
    Map update = new Map<String, Object>();
    update.putIfAbsent(key, value);
    
    _refs.userRef().document(documentID)
      .set(update, merge : true);
  }

  updateClass(String documentID, String key, value){
    Map update = new Map<String, Object>();
    update.putIfAbsent(key, value);
    
    _refs.classRef().document(documentID)
      .set(update, merge : true);
  }

  updateMeal(String documentID, String key, value){
    Map update = new Map<String, Object>();
    update.putIfAbsent(key, value);
    
    _refs.mealRef().document(documentID)
      .set(update, merge : true);
  }
  //delete existing
  deleteUser(String documentID){
    _refs.userRef().document(documentID).delete();
  }

  deleteClass(String documentID){
    _refs.classRef().document(documentID).delete();
  }

  deleteMeal(String documentID){
    _refs.mealRef().document(documentID).delete();
  }
}
