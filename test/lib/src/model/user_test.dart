import 'package:test/test.dart';
import 'package:bsc/src/model/user.dart';

void main() {
  final firestoreData = new Map<String, dynamic>.from({
    'first_name': "Dan",
    'last_name': "Bachler",
    'email': "email",
    'phone_number': "phoneNumber",
    'mobile_number': "phoneNumber",
    'address': "address",
    'role': "role",
    'dietary_restrictions': "dietaryRestrictions",
    // TODO: Built list
    'emergency_contacts': "",
    'membership_start': "2019-02-27T12:05:46.173",
    'membership_renewal': "2019-02-27T12:05:58.478",
    'disabilities': "disabilities",
    // TODO: Built list
    'forms': "",
    'medical_issues': "medicalIssues",
    'position': "position",
    //Todo:  Built List
    'services': "",
  });
  User testing;
  
  test('Make sure data from firebase is accuratly changed into data for dart',
      () {
    testing = new User.fromFirebase(null,firestoreData,null);
    //Test that values are accurately carried over
    expect(testing.firstName, firestoreData['first_name']);
  });

  test(
      'Make sure that data from dart is accuratly changed into data for firebase',
      () {
    testing = new User.fromFirebase(null,firestoreData,null);
    Map<String, String> temp = testing.toFirestore();
    expect(firestoreData, temp);
  });
}