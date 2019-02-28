import 'package:test/test.dart';
import 'package:bsc/src/model/activity.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  final firestoreData = new BuiltMap<String, String>.from({
    'uuid': "123456789",
    'capacity': "-1",
    'start_time': "2019-02-27T12:05:46.173",
    'end_time': "2019-02-27T12:05:58.478",
    'instructor': "Dan Bachler",
    'location': "A room",
    'name': "A class",
  });
  Activity testing;
  
  test('Make sure data from firebase is accuratly changed into data for dart',
      () {
    testing = new Activity.fromFirebase(firestoreData.asMap());
    //Test that values are accurately carried over
    expect(testing.uid, firestoreData['uuid']);
    expect(testing.capacity, firestoreData['capacity']);
    expect(testing.startTime.toIso8601String(), firestoreData['start_time']);
    expect(testing.endTime.toIso8601String(), firestoreData['end_time']);
    expect(testing.instructor, firestoreData['instructor']);
    expect(testing.location, firestoreData['location']);
    expect(testing.name, firestoreData['name']);
  });

  test(
      'Make sure that data from dart is accuratly changed into data for firebase',
      () {
    testing = new Activity.fromFirebase(firestoreData.asMap());
    Map<String, dynamic> temp = testing.toFirestore();
    expect(firestoreData.asMap(), temp);
  });
}
