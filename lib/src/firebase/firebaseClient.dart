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

  Future _onAuthChanged(fb.User fbUser) async {
    print("Auth Changed :: $fbUser");
    User newUser;
    if (fbUser != null) {
      newUser = new User.fromFirebase(fbUser, null);
    }
    _actions.setUser(newUser);
  }

  Future logOut() async => _auth.signOut();

  Future<bool> signInAdmin(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(email, password);
      if (userCred != null) {
        return true;
      }
    } on fb.FirebaseError catch (e) {
      if (e.code == "auth/user-not-found") {
        print("user did not exist!");
      } else if (e.code == "auth/wrong-password") {
        print("Incorrect Password!!");
      } else {
        print("e.code: ${e.code}");
      }
    } catch (e) {
      print("Unexpected error with sign in: $e");
    }
    return false;
  }
}
