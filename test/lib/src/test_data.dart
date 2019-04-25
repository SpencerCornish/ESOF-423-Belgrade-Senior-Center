import 'package:bsc/src/model/activity.dart';
import 'package:bsc/src/model/meal.dart';
import 'package:bsc/src/model/emergencyContact.dart';
import 'package:bsc/src/model/user.dart';
import 'package:built_collection/built_collection.dart';

final testEmails = <String, bool>{
  "daniel.bachler@comcast.net": true,
  "daniel.bachler.comcast.net": false,
  "daniel.bachler@comcast": false,
  "@google": false,
  "": false,
  "1": false,
  "1@1.1": false
};

final testPhones = <String, bool>{
  "4252734489": true,
  "425-273-4489": true,
  "1-425-273-4489": true,
  "1(425)273-4489": true,
  "1": false,
  "123456789123": false,
  "dan": false
};

final testUser = (new UserBuilder()
      ..firstName = ''
      ..lastName = ''
      ..email = "test@test.com"
      ..phoneNumber = ''
      ..mobileNumber = ''
      ..address = ''
      ..role = ''
      ..homeDeliver = false
      ..medRelease = false
      ..waiverRelease = false
      ..intakeForm = false
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

final testActivity = (new ActivityBuilder()
      ..capacity = 0
      ..endTime = new DateTime.fromMicrosecondsSinceEpoch(0)
      ..startTime = new DateTime.fromMicrosecondsSinceEpoch(0)
      ..instructor = ""
      ..location = ""
      ..name = "")
    .build();

final testMeal = (new MealBuilder()
      ..startTime = new DateTime.fromMicrosecondsSinceEpoch(0)
      ..endTime = new DateTime.fromMicrosecondsSinceEpoch(0)
      ..menu = new BuiltList<String>(["", ""]).toBuilder())
    .build();
