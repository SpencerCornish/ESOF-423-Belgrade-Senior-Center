import 'package:test/test.dart';
import 'package:bsc/src/model/emergencyContact.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  final firestoreData = new BuiltMap<String, String>.from({
    'uuid': "123456789",
    'name':"Dan",
    'relationship':"Myself",
    'number':"4254254256"
  });
  EmergencyContact testing;
  
  test('Make sure data from firebase is accuratly changed into data for dart',
      () {
    testing = new EmergencyContact.fromFirebase(firestoreData.asMap());
    //Test that values are accurately carried over
    expect(testing.uid, firestoreData['uuid']);
    expect(testing.name, firestoreData['name']);
    expect(testing.relationship, firestoreData['realationship']);
    expect(testing.number, firestoreData['number']);
  });

  test(
      'Make sure that data from dart is accuratly changed into data for firebase',
      () {
    testing = new EmergencyContact.fromFirebase(firestoreData.asMap());
    Map<String, String> temp = testing.toFirestore();
    expect(firestoreData.asMap(), temp);
  });
}