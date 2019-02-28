library emergencyContact;

import 'package:built_value/built_value.dart';

part 'emergencyContact.g.dart';

/// [emergencyContact] is a model for the user database document
abstract class EmergencyContact implements Built<EmergencyContact, EmergencyContactBuilder> {
  /// [uid] is the unique identifier for the Emergency Contact
  String get uid;

  /// [name] is the name of the contact
  String get name;

  /// [relationship] is how this emergency contact is related to the member
  String get relationship;

  /// [number] is the phone number of the contact
  String get number;

  EmergencyContact._();
  factory EmergencyContact([updates(EmergencyContactBuilder b)]) = _$EmergencyContact;

  factory EmergencyContact.fromFirebase(Map<String, dynamic> firestoreData) =>
      new EmergencyContact((EmergencyContactBuilder builder) => builder
        ..uid = firestoreData['uid']
        ..name = firestoreData['name']
        ..relationship = firestoreData['relationship']
        ..number = firestoreData['number']);

  Map<String, dynamic> toFirestore() => {
        'uid': uid,
        'name': name,
        'relationship': relationship,
        'number': number,
      };
}
