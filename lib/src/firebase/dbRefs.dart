import 'package:firebase/firestore.dart';

class DbRefs {
  Firestore _fs;

  DbRefs(this._fs);

  /// [allUsers] returns all documents from the users collection
  allUsers() => _fs.collection('users');

  /// [user] takes a unique identifier for a user, and returns a DocumentReference to a specific user
  DocumentReference user(String uid) => _fs.collection('users').doc(uid);

  /// [allMeals] returns all documents for the meal collection meals
  allMeals() => _fs.collection('meals');

  /// [meal] takes a unique identifier for a meal, and returns a DocumentReference to a specific meal
  meal(String uid) => _fs.collection('meals').doc(uid);

  /// [allClasses] returns all documents from the classes collection
  allClasses() => _fs.collection('classes');

  /// [singleClass] takes a unique identifier for a class, and returns a DocumentReference to a specific class
  singleClass(String uid) => _fs.collection('classes').doc(uid);
}
