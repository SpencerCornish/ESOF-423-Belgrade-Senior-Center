import 'package:test/test.dart';
import 'package:bsc/src/model/meal.dart';

void main() {
  final firestoreData = new Map<String, dynamic>.from({
    'uuid': "123456789",
    'start_time': "2019-02-27T12:05:46.173",
    'end_time': "2019-02-27T12:05:58.478",
    'menu':""
  });
  Meal testing;
  
  test('Make sure data from firebase is accuratly changed into data for dart',
      () {
    testing = new Meal.fromFirebase(firestoreData);
    //Test that values are accurately carried over
    expect(testing.uid, firestoreData['uuid']);
    expect(testing.startTime.toIso8601String(), firestoreData['start_time']);
    expect(testing.endTime.toIso8601String(), firestoreData['end_time']);
    expect(testing.menu, "");
  });

  test(
      'Make sure that data from dart is accuratly changed into data for firebase',
      () {
    testing = new Meal.fromFirebase(firestoreData);
    Map<String, dynamic> temp = testing.toFirestore();
    expect(firestoreData, temp);
  });
}