library user;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import './emergencyContact.dart';

part 'user.g.dart';

/// [User] is a model for the user database document
abstract class User implements Built<User, UserBuilder> {
  /// [loginUID] is the unique identifier for the user's login
  /// This represents the uid of the user's login credential, which
  /// is not the same as the place we store their userdata
  @nullable
  String get loginUID;

  /// [docUID] is the unique identifier for the user's data stored
  /// in the database
  @nullable
  String get docUID;

  /// [firstName] required
  String get firstName;

  /// [lastName] required
  String get lastName;

  /// [email] may be an empty string
  String get email;

  /// [phoneNumber] may be an empty string
  String get phoneNumber;

  /// [mobileNumber] may be an empty string
  String get mobileNumber;

  /// [address] US only
  String get address;

  /// [role] is an enumeration of the users' role. This controls access levels, as well as the pages shown to the user.
  /// All of this is backed up with proper database rules, so maliciously subverting the user role locally will have
  /// no effect.
  String get role;

  /// [dietaryRestrictions] is a comma separated list of restricted dietary items for the user
  String get dietaryRestrictions;

  /// [emergencyContactName] is the name of an emergency contact
  String get emergencyContactName;

  /// [emergencyContactNumber] is the number of the emergency contact
  String get emergencyContactNumber;

  /// [emergencyContactRelation] is the relationship of the emergency contact to the user
  String get emergencyContactRelation;

  /// [membershipStart] is a DateTime object representing the time at which the user's membership began
  DateTime get membershipStart;

  /// [membershipRenewal] is a DateTime object representing the time at which the user's membership began
  DateTime get membershipRenewal;

  /// [disabilities] required
  String get disabilities;

  /// [forms] required
  BuiltList<String> get forms;

  /// [medicalIssues] required
  @nullable
  String get medicalIssues;

  /// [position] may be blank for normal users
  /// The current position of the user, only used in case of admins and volunteers
  String get position;

  /// [homeDelivery] is a boolean that tells admins whether or not the user gets their meals home delivered
  @nullable
  bool get homeDeliver;

  /// [medRelease] is a boolean that tells admins whether or not someone has submitted their medical release form
  @nullable
  bool get medRelease;

  /// [waiverRelease] is a boolean that tells admins whether or not someone has submitted their waiver & Release
  @nullable
  bool get waiverRelease;

  /// [intakeForm] is a boolean that tells admins whether or not someone has submitted their waiver & Release
  @nullable
  bool get intakeForm;

  /// [services] required
  /// A list of services that are used by the user
  BuiltList<String> get services;

  User._();
  factory User([updates(UserBuilder b)]) = _$User;

  factory User.fromFirebase(
    Map<String, dynamic> firestoreData,
    BuiltList<EmergencyContact> emergencyContact, {
    String docUID,
    String loginUID,
    String email,
  }) =>
      new User((UserBuilder builder) => builder
        ..docUID = docUID
        ..loginUID = loginUID ?? firestoreData['login_uid']
        ..firstName = firestoreData['first_name']
        ..lastName = firestoreData['last_name']
        ..email = email ?? firestoreData['email']
        ..phoneNumber = firestoreData['phone_number']
        ..mobileNumber = firestoreData['mobile_number']
        ..address = firestoreData['address']
        ..role = firestoreData['role'].toLowerCase()
        ..dietaryRestrictions = firestoreData['dietary_restrictions']
        ..homeDeliver = firestoreData['homeDelivery'] ?? false
        ..emergencyContactName = firestoreData['emergency_ContactName'] ?? ''
        ..emergencyContactNumber = firestoreData['emergency_ContactNumber'] ?? ''
        ..emergencyContactRelation = firestoreData['emergency_ContactRelation'] ?? ''
        ..membershipStart = DateTime.parse(firestoreData['membership_start'])
        ..membershipRenewal = DateTime.parse(firestoreData['membership_renewal'])
        ..disabilities = firestoreData['disabilities']
        ..forms = BuiltList<String>.from(firestoreData['forms']).toBuilder()
        ..medicalIssues = firestoreData['medical_issues']
        ..position = firestoreData['position']
        ..services = BuiltList<String>.from(firestoreData['services']).toBuilder()
        ..medRelease = firestoreData['medRelease'] ?? false
        ..waiverRelease = firestoreData['waiverRelease'] ?? false
        ..intakeForm = firestoreData['intakeForm'] ?? false);

  Map<String, dynamic> toFirestore() => {
        'login_uid': loginUID ?? '',
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'mobile_number': mobileNumber,
        'address': address,
        'role': role.toLowerCase(),
        'dietary_restrictions': dietaryRestrictions,
        'homeDelivery': homeDeliver,
        'medRelease': medRelease,
        'waiverRelease': waiverRelease,
        'intakeForm': intakeForm,
        'emergency_ContactName': emergencyContactName,
        'emergency_ContactNumber': emergencyContactNumber,
        'emergency_ContactRelation': emergencyContactRelation,
        'membership_start': membershipStart.toIso8601String(),
        'membership_renewal': membershipRenewal.toIso8601String(),
        'disabilities': disabilities,
        'forms': forms.toList(),
        'medical_issues': medicalIssues,
        'position': position,
        'services': services.toList(),
      };

  String toCsv() =>
      [
        '\"${docUID}\"',
        '\"${lastName}\"',
        '\"${firstName}\"',
        '\"${email}\"',
        '\"${address}\"',
        '\"${phoneNumber}\"',
        '\"${mobileNumber}\"',
        '\"${position}\"',
        '\"${role}\"',
        '\"${dietaryRestrictions}\"',
        '\"${disabilities}\"',
        '\"${medicalIssues}\"',
        '\"${emergencyContactName}\"',
        '\"${emergencyContactNumber}\"',
        '\"${emergencyContactRelation}\"',
        '\"${services.join(',')}\"',
        '\"${membershipStart.month}/${membershipStart.day}/${membershipStart.year}\"',
        '\"${membershipRenewal.month}/${membershipRenewal.day}/${membershipRenewal.year}\"',
      ].join(',') +
      '\n';
}
