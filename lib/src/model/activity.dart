library activity;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

part 'activity.g.dart';

/// [Activity] is a model for the user database document
abstract class Activity implements Built<Activity, ActivityBuilder> {
  /// [uid] is the unique identifier for the activity
  @nullable
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

  /// [users] is a built list of user ids
  BuiltList<String> get users;

  Activity._();
  factory Activity([updates(ActivityBuilder b)]) = _$Activity;

  factory Activity.fromFirebase(
    Map<String, dynamic> firestoreData, {
    String uid,
  }) =>
      new Activity(
        (ActivityBuilder builder) => builder
          ..uid = uid
          ..capacity = firestoreData['capacity']
          ..startTime = DateTime.parse(firestoreData['start_time'])
          ..endTime = DateTime.parse(firestoreData['end_time'])
          ..instructor = firestoreData['instructor']
          ..location = firestoreData['location']
          ..name = firestoreData['name']
          ..users = new ListBuilder<String>(firestoreData['users'] ?? []),
      );

  Map<String, dynamic> toFirestore() => {
        'capacity': capacity,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'instructor': instructor,
        'location': location,
        'name': name,
        'users': users.toList(),
      };

  String toCsv() =>
      [
        '\"${uid}\"',
        '\"${name}\"',
        '\"${instructor}\"',
        '\"${capacity}\"',
        '\"${location}\"',
        '\"${startTime}\"',
        '\"${endTime}\"',
        '\"${users.join(',')}\"'
      ].join(',') +
      '\n';
}
