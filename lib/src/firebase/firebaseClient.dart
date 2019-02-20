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
      newUser = new User.fromFirebase(fbUser, null, {});
    }
    _actions.setUser(newUser);
    _actions.setAuthState(fbUser == null ? AuthState.INAUTHENTIC : AuthState.SUCCESS);
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

  resetPassword(String email) {
    // TODO: Adjust this redurect url as needed.
    _auth.sendPasswordResetEmail(email,
        new fb.ActionCodeSettings(url: "https://bsc-development.firebaseapp.com/pw_reset/${stringToBase(email)}"));
    _actions.setAuthState(AuthState.PASS_RESET_SENT);
  }
}
