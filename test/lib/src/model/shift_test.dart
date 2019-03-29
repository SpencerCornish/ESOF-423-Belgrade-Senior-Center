import 'package:test/test.dart';
import 'package:built_collection/built_collection.dart';
import 'package:bsc/src/model/shift.dart';

void main() {
  final testUserUID = "e93da155-10b8-434d-8202-d31c41003645";
  final testInTime = new DateTime.now();
  final testOutTime = new DateTime.now().add(Duration(days: 2));

  final mockFirestoreShiftData = new Map<String, dynamic>.from({
    "user_id": testUserUID,
    "in_time": testInTime.toIso8601String(),
    "out_time": testOutTime.toIso8601String(),
  });
  group('Shift -', () {
    test('fromFirebase factory produces accurate model file', () {
      Shift shiftFromTestData = new Shift.fromFirebase(mockFirestoreShiftData);

      expect(shiftFromTestData.inTime, testInTime);
      expect(shiftFromTestData.outTime, testOutTime);
      expect(shiftFromTestData.userID, testUserUID);

      // Check memoized field (workDuration)
      expect(shiftFromTestData.durationWorked, Duration(days: 2));
    });

    test('toFirebase function produces a properly formatted map of data', () {
      Shift shiftFromTestData = new Shift.fromFirebase(mockFirestoreShiftData);

      final firebaseMap = shiftFromTestData.toFirebase();

      expect(firebaseMap, mockFirestoreShiftData);
    });
  });
}
