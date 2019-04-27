import 'package:test/test.dart';
import 'package:bsc/src/model/shift.dart';

void main() {
  final testUserUID = "e93da15510b8434d8202";
  final testInTime = new DateTime.now();
  final testOutTime = new DateTime.now().add(Duration(days: 2));

  final mockFirestoreShiftData = new Map<String, dynamic>.from({
    "user_id": testUserUID,
    "in_time": testInTime.toIso8601String(),
    "out_time": testOutTime.toIso8601String(),
  });
  final mockShiftCsv = '"testUID","foo","bar","' +
      testInTime.toIso8601String() +
      '","' +
      testOutTime.toIso8601String() +
      '","-48:00:00.000000"\n';
      
  group('Shift -', () {
    test('fromFirebase factory produces accurate model file', () {
      Shift shiftFromTestData = new Shift.fromFirebase('', mockFirestoreShiftData);

      expect(shiftFromTestData.inTime, testInTime);
      expect(shiftFromTestData.outTime, testOutTime);
      expect(shiftFromTestData.userID, testUserUID);

      // Check memoized field (workDuration)
      expect(shiftFromTestData.durationWorked.inHours.abs(), 48);
    });

    test('toFirebase function produces a properly formatted map of data', () {
      Shift shiftFromTestData = new Shift.fromFirebase('', mockFirestoreShiftData);

      final firebaseMap = shiftFromTestData.toFirebase();

      expect(firebaseMap, mockFirestoreShiftData);
    });

    test('toCsv function properly formatted csv file of the activity', () {
      Shift testShift = new Shift.fromFirebase('testUID', mockFirestoreShiftData);
      String temp = testShift.toCsv("foo", "bar");
      expect(temp, mockShiftCsv);
    });
  });
}
