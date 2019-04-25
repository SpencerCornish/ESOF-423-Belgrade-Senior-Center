import 'package:test/test.dart';
import 'package:bsc/src/model/activity.dart';

void main() {
  final mockActivityData = <String, dynamic>{
    'capacity': -1,
    'start_time': "2019-02-27T12:05:46.173",
    'end_time': "2019-02-27T12:05:58.478",
    'instructor': "Dan Bachler",
    'location': "A room",
    'name': "A class",
    'users': ['test', 'data']
  };
  final mockActivityCsv = '"testID","A class","Dan Bachler","-1","A room","2019-02-27 12:05:46.173","2019-02-27 12:05:58.478","test,data"\n';
  group('Activity - ', () {
    test('fromFirebase factory produces accurate model file', () {
      Activity activity = new Activity.fromFirebase(
        mockActivityData,
        uid: "testID",
      );
      //Test that values are accurately carried over
      expect(activity.capacity, mockActivityData['capacity']);
      expect(activity.startTime.toIso8601String(), mockActivityData['start_time']);
      expect(activity.endTime.toIso8601String(), mockActivityData['end_time']);
      expect(activity.instructor, mockActivityData['instructor']);
      expect(activity.location, mockActivityData['location']);
      expect(activity.name, mockActivityData['name']);
      expect(activity.users.toList(), mockActivityData['users']);
    });

    test('toFirebase function produces a properly formatted map of data', () {
      Activity activity = new Activity.fromFirebase(mockActivityData, uid: "testID");
      Map<String, dynamic> temp = activity.toFirestore();
      expect(mockActivityData, temp);
    });

    test('toCsv function properly formatted csv file of the activity', (){
      Activity activity = new Activity.fromFirebase(mockActivityData, uid: "testID");
      String temp = activity.toCsv();
      expect(temp, mockActivityCsv);
    });
  });
}
