library emergencyContat;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'emergencyContact.g.dart';

/// [emergencyContact] is a model for the user database document
abstract class EmergencyContact implements Built<EmergencyContact, EmergencyContactBuilder> {
  /// [uid] is the unique identifier for the meal
  String get uid;

  /// [name] is the name of the contact
  String get name;

  ///[number] is the phone number of the contact
  int get number;


  EmergencyContact._();
  factory EmergencyContact([updates(EmergencyContactBuilder b)]) = _$EmergencyContact;

  factory EmergencyContact.fromFirebase(Map<String, dynamic> firestoreData) => new EmergencyContact((EmergencyContactBuilder builder) => builder
    ..uid = firestoreData['uid']
    ..startTime = DateTime.parse(firestoreData['start_time'])
    ..endTime = DateTime.parse(firestoreData['end_time'])
    //Old
    ..menu =firestoreData['menu']
    //New
    //..menu = new BuiltList<String>.from(firestoreData['menu'])
    );

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'name':name,
        'number':number,
      };
}