import 'package:test/test.dart';
import 'package:bsc/src/model/activity.dart';

void main() {
  Map<String, dynamic> firestoreData;
  Activity testing;
  //Setup for tests
  setUp(() async {
    //Bogus data in firebase format for testing
    firestoreData = {
      'uuid':"123456789",
      'capacity': -1,
      'start_time': "2019-02-27T12:05:46.173",
      'end_time': "2019-02-27T12:05:58.478",
      'instructor': "Dan Bachler",
      'location': "A room",
      'name': "A class",
    };
    //Create new Activity object
    testing = new Activity.fromFirebase(firestoreData);
  });
  test('Make sure data from firebase is accuratly changed into data for dart', () {
    //Test that values are accurately carried over
    expect(testing.uid, firestoreData['uuid']);
    expect(testing.capacity, firestoreData['capacity']);
    expect(testing.startTime.toIso8601String(), firestoreData['start_time']);
    expect(testing.endTime.toIso8601String(), firestoreData['end_time']);
    expect(testing.instructor, firestoreData['instructor']);
    expect(testing.location, firestoreData['location']);
    expect(testing.name, firestoreData['name']);
  });

  test('Make sure that data from dart is accuratly changed into data for firebase', () {
    Map<String, dynamic> temp = testing.toFirestore();
    expect(firestoreData, temp);
  });
}