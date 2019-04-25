import 'package:test/test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:bsc/src/model/user.dart';
import 'package:bsc/src/model/emergencyContact.dart';

void main() {
  final formList = ['forma', 'formb'];
  final serviceList = ['servicea', 'serviceb'];
  final emergencyContactList = [];
  final mockFirestoreUserData = new Map<String, dynamic>.from({
    'login_uid': "Login_UID",
    'first_name': "Dan",
    'last_name': "Bachler",
    'email': "test@example.com",
    'phone_number': "phoneNumber",
    'mobile_number': "phoneNumber",
    'address': "443 E Main Street Bozeman, MT 59715",
    'role': "admin",
    'dietary_restrictions': "dietaryRestrictions",
    'homeDelivery': false,
    'medRelease': false,
    'waiverRelease': false,
    'intakeForm': false,
    'emergency_ContactName': '',
    'emergency_ContactNumber': '',
    'emergency_ContactRelation': '',
    'membership_start': "2019-02-27T12:05:46.173",
    'membership_renewal': "2019-02-27T12:05:58.478",
    'disabilities': "disabilities",
    'forms': formList,
    'medical_issues': "medicalIssues",
    'position': "position",
    'services': serviceList,
  });
  group('User -', () {
    test('fromFirebase factory produces accurate model file', () {
      User userFromTestData = new User.fromFirebase(mockFirestoreUserData, new BuiltList<EmergencyContact>(),
          loginUID: 'Login_UID', docUID: 'data_UID');

      // Datetimes
      expect(userFromTestData.membershipStart.toIso8601String(), mockFirestoreUserData['membership_start']);
      expect(userFromTestData.membershipRenewal.toIso8601String(), mockFirestoreUserData['membership_renewal']);

      // maps
      expect(userFromTestData.forms.toList(), formList);
      expect(userFromTestData.services.toList(), serviceList);
    });

    test('toFirebase function produces a properly formatted map of data', () {
      User userFromTestData = new User.fromFirebase(mockFirestoreUserData, new BuiltList<EmergencyContact>(),
          loginUID: 'Login_UID', docUID: 'data_UID');
      Map<String, dynamic> output = userFromTestData.toFirestore();
      expect(mockFirestoreUserData, output);
    });
  });
}
