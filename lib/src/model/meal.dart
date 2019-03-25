library meal;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'meal.g.dart';

/// [Meal] is a model for the user database document
abstract class Meal implements Built<Meal, MealBuilder> {
  /// [uid] is the unique identifier for the meal
  String get uid;

  /// [startTime] required
  DateTime get startTime;

  /// [endTime] required
  DateTime get endTime;

  /// [menu] required
  /// A list of strings that represent the menu for a given meal time.
  BuiltList<String> get menu;

  Meal._();
  factory Meal([updates(MealBuilder b)]) = _$Meal;

  factory Meal.fromFirebase(
    Map<String, dynamic> firestoreData, {
    String uid,
  }) =>
      new Meal((MealBuilder builder) => builder
        ..uid = uid
        ..startTime = DateTime.parse(firestoreData['start_time'])
        ..endTime = DateTime.parse(firestoreData['end_time'])
        ..menu = new BuiltList<String>.from(firestoreData['menu']).toBuilder());

  Map<String, dynamic> toFirestore() => {
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'menu': menu.toList(),
      };

  String toCsv() =>
      [
        '\"${uid}\"',
        '\"${startTime}\"',
        '\"${endTime}\"',
        '\"${menu}\"',
      ].join(',') +
      '\n';
}
