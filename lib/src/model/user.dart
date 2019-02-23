library user;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:firebase/firebase.dart' as fb;

part 'user.g.dart';

/// [User] is a model for the user database document
abstract class User implements Built<User, UserBuilder> {
  /// [uid] is the unique identifier for the user
  String get uid;

  /// TODO: Hudrate these fields when creating a user model
  /// [firstName] required
  String get firstName;

  /// [lastName] required
  String get lastName;

  /// [email] may be an empty string
  String get email;

  /// [phoneNumber] may be an empty string
  String get phoneNumber;

  /// [address] US only
  String get address;

  /// [role] is an enumeration of the users' role. This controls access levels, as well as the pages shown to the user.
  /// All of this is backed up with proper database rules, so maliciously subverting the user role locally will have
  /// no effect.
  String get role;

  /// [dietaryRestrictions] is a comma separated list of restricted dietary items for the user
  String get dietaryRestrictions;

  /// [emergencyContacts] is a built list of [EmergencyContact] objects
  BuiltList<String> get emergencyContacts;

  /// [membershipStart] is a DateTime object representing the time at which the user's membership began
  DateTime get membershipStart;

  /// [membershipRenewal] is a DateTime object representing the time at which the user's membership began
  DateTime get membershipRenewal;

  /// [disabilities] required
  String get disabilities;

  /// [forms] required
  BuiltList<String> get forms;

  /// [medicalIssues] required
  String get medicalIssues;

  /// [position] may be blank for normal users
  /// The current position of the user, only used in case of admins and volunteers
  String get position;

  /// [services] required
  /// A list of services that are used by the user
  BuiltList<String> get services;

  User._();
  factory User([updates(UserBuilder b)]) = _$User;

  factory User.fromFirebase(fb.User fbUser, fb.UserInfo additionalInfo, Map<String, dynamic> firestoreData) =>
      new User((UserBuilder builder) => builder
        ..uid = fbUser.uid
        ..firstName = firestoreData['first_name']
        ..lastName = firestoreData['last_name']
        ..email = firestoreData['email']
        ..phoneNumber = firestoreData['phone_number']
        ..address = firestoreData['address']
        ..role = firestoreData['role']
        ..dietaryRestrictions = firestoreData['dietary_restrictions']
        ..emergencyContacts = firestoreData['emergency_contacts']
        ..membershipStart = DateTime.parse(firestoreData['membership_start'])
        ..membershipRenewal = DateTime.parse(firestoreData['membership_renewal'])
        ..disabilities = firestoreData['disabilities']
        ..forms = firestoreData['forms']
        ..medicalIssues = firestoreData['medical_issues']
        ..position = firestoreData['position']
        ..services = firestoreData['services']);

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'role': role,
        'dietary_restrictions': dietaryRestrictions,
        'emergency_contacts': emergencyContacts,
        'membership_start': membershipStart.toIso8601String(),
        'membership_renewal': membershipRenewal.toIso8601String(),
        'disabilities': disabilities,
        'forms': forms,
        'medical_issues': medicalIssues,
        'position': position,
        'services': services,
      };
}
