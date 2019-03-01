import 'package:test/test.dart';
import 'package:bsc/src/model/activity.dart';

void main() {
  final mockUID = "e48bd850a0134e96b25de6432114a134";
  final mockActivityData = <String, dynamic>{
    'capacity': -1,
    'start_time': "2019-02-27T12:05:46.173",
    'end_time': "2019-02-27T12:05:58.478",
    'instructor': "Dan Bachler",
    'location': "A room",
    'name': "A class",
  };
  group('Activity - ', () {
    test('fromFirebase factory produces accurate model file', () {
      Activity activity = new Activity.fromFirebase(mockUID, mockActivityData);
      //Test that values are accurately carried over
      expect(activity.capacity, mockActivityData['capacity']);
      expect(activity.startTime.toIso8601String(), mockActivityData['start_time']);
      expect(activity.endTime.toIso8601String(), mockActivityData['end_time']);
      expect(activity.instructor, mockActivityData['instructor']);
      expect(activity.location, mockActivityData['location']);
      expect(activity.name, mockActivityData['name']);
    });

    test('toFirebase function produces a properly formatted map of data', () {
      Activity activity = new Activity.fromFirebase(mockUID, mockActivityData);
      Map<String, dynamic> temp = activity.toFirestore();
      expect(mockActivityData, temp);
    });
  });
}
