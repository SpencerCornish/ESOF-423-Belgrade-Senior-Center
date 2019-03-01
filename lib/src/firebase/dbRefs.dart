import 'package:firebase/firestore.dart';

class DbRefs {
  Firestore _fs;

  DbRefs(this._fs);

  /// [allUsers] returns all documents from the users collection
  CollectionReference allUsers() => _fs.collection('users');

  /// [user] takes a unique identifier for a user, and returns a DocumentReference to a specific user
  /// if no uid is specified, a new one is generated
  DocumentReference user([String uid]) => _fs.collection('users').doc(uid);

  /// [allMeals] returns all documents for the meal collection meals
  CollectionReference allMeals() => _fs.collection('meals');

  /// [meal] takes a unique identifier for a meal, and returns a DocumentReference to a specific meal
  /// if no uid is specified, a new one is generated
  DocumentReference meal([String uid]) => _fs.collection('meals').doc(uid);

  /// [allClasses] returns all documents from the classes collection
  CollectionReference allActivities() => _fs.collection('activity');

  /// [singleClass] takes a unique identifier for a class, and returns a DocumentReference to a specific class
  /// if no uid is specified, a new one is generated
  DocumentReference singleClass([String uid]) => _fs.collection('classes').doc(uid);
}
