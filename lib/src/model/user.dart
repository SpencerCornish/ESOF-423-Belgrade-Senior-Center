library user;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:firebase/firebase.dart' as fb;

import '../constants.dart';

part 'user.g.dart';

/// [User] is a model for the user database document
abstract class User implements Built<User, UserBuilder> {
  /// [uid] is the unique identifier for the user
  String get uid;

  // TODO: Hudrate these fields when creating a user model
  // /// [firstName] required
  // String get firstName;

  // /// [lastName] required
  // String get lastName;

  // /// [email] may be an empty string
  // String get email;

  // /// [number] may be an empty string
  // String get number;

  // /// [cellNumber] may be an empty string
  // String get cellNumber;

  // /// [address] US only
  // String get address;

  // /// [role] is an enumeration of the users' role. This controls access levels, as well as the pages shown to the user.
  // /// All of this is backed up with proper database rules, so maliciously subverting the user role locally will have
  // /// no effect.
  // Role get role;

  // /// [dietaryRestrictions] is a comma separated list of restricted dietary items for the user
  // String get dietaryRestrictions;

  // /// [emergencyContacts] is a built list of [EmergencyContact] objects
  // BuiltList<String> get emergencyContacts;

  // /// [membershipStart] is a DateTime object representing the time at which the user's membership began
  // DateTime get membershipStart;

  // /// [membershipRenewal] is a DateTime object representing the time at which the user's membership began
  // DateTime get membershipRenewal;

  User._();
  factory User([updates(UserBuilder b)]) = _$User;

  factory User.fromFirebase(fb.User fbUser, fb.UserInfo additionalInfo) =>
      new User((UserBuilder builder) => builder..uid = fbUser.uid);
}
