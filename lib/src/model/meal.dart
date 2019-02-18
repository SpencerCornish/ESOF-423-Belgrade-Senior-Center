library meal;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';
import 'package:firebase/firebase.dart' as fb;

import '../constants.dart';

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

  factory Meal.frmFirebase(Map<String, dynamic> firestoreData) =>
      new Meal((MealBuilder builder) => builder
      ..uid = firestoreData['uid']
      ..startTime = DateTime.parse(firestoreData['start_time'])
      ..endTime = DateTime.parse(firestoreData['end_time'])
      ..menu =firestoreData['menu']
      );
}