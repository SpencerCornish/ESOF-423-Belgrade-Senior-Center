library activity;

import 'package:built_value/built_value.dart';

part 'activity.g.dart';

/// [Activity] is a model for the user database document
abstract class Activity implements Built<Activity, ActivityBuilder> {
  /// [uid] is the unique identifier for the activity
  String get uid;

  /// [capacity] May be -1 for unlimited
  int get capacity;

  /// [endTime] required
  DateTime get endTime;

  /// [startTime] required
  DateTime get startTime;

  /// [instructor] Can be a blank string
  String get instructor;

  /// [location] required
  String get location;

  /// [name] required
  String get name;

  Activity._();
  factory Activity([updates(ActivityBuilder b)]) = _$Activity;

  factory Activity.fromFirebase(Map<String, String> firestoreData) => new Activity((ActivityBuilder builder) => builder
    ..uid = firestoreData['uuid']
    ..capacity = int.parse(firestoreData['capacity'])
    ..startTime = DateTime.parse(firestoreData['start_time'])
    ..endTime = DateTime.parse(firestoreData['end_time'])
    ..instructor = firestoreData['instructor']
    ..location = firestoreData['location']
    ..name = firestoreData['name']);

  Map<String, String> toFirestore() => {
        'uuid': uid,
        'capacity': capacity.toString(),
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'instructor': instructor,
        'location': location,
        'name': name,
      };
}
