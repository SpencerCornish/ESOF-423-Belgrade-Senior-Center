library shift;

import 'package:built_value/built_value.dart';

part 'shift.g.dart';

abstract class Shift implements Built<Shift, ShiftBuilder> {
  @nullable
  String get punchID;

  String get userID;

  @nullable
  DateTime get inTime;

  @nullable
  DateTime get outTime;

  @memoized
  Duration get durationWorked => inTime.difference(outTime);

  Shift._();
  factory Shift([updates(ShiftBuilder b)]) = _$Shift;

  factory Shift.fromFirebase(
    Map<String, dynamic> firestoreData,
  ) =>
      new Shift((ShiftBuilder builder) => builder
        ..userID = firestoreData["user_id"]
        ..inTime = DateTime.tryParse(firestoreData["in_time"])
        ..outTime = DateTime.tryParse(firestoreData["out_time"]));

  Map<String, dynamic> toFirebase() => {
        "user_id": userID,
        "in_time": inTime?.toIso8601String() ?? '',
        "out_time": outTime?.toIso8601String() ?? '',
      };

  String toCsv(String fName, String lName) =>
      [
        '\"${punchID}\"',
        '\"${fName}\"',
        '\"${lName}\"',
        '\"${inTime}\"',
        '\"${outTime}\"',
        '\"${durationWorked}\"',
      ].join(',') +
      '\n';
}
