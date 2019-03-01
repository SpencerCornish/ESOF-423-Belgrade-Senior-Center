import 'package:test/test.dart';
import 'package:bsc/src/model/emergencyContact.dart';

void main() {
  final mockUID = "e48bd850a0134e96b25de6432114a134";

  final mockEmergContactData = <String, dynamic>{
    'name': "Dan",
    'relationship': "Myself",
    'number': "4254254256",
  };
  group('EmergencyContact', () {
    test('fromFirebase factory produces accurate model file', () {
      EmergencyContact emergencyContact = new EmergencyContact.fromFirebase(mockUID, mockEmergContactData);
      //Test that values are accurately carried over
      expect(emergencyContact.name, mockEmergContactData['name']);
      expect(emergencyContact.relationship, mockEmergContactData['relationship']);
      expect(emergencyContact.number, mockEmergContactData['number']);
    });

    test('toFirebase function produces a properly formatted map of data', () {
      EmergencyContact emergencyContact = new EmergencyContact.fromFirebase(mockUID, mockEmergContactData);
      Map<String, dynamic> output = emergencyContact.toFirestore();
      expect(mockEmergContactData, output);
    });
  });
}
