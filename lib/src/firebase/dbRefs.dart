import 'package:firebase/firestore.dart';

class DbRefs {
  Firestore _fs;

  DbRefs(this._fs);

  /// [allUsers] returns all documents from the users collection
  CollectionReference allUsers() => _fs.collection('users');

  /// [userFromDocumentUID] takes a unique document identifier for a user, and returns a DocumentReference to a specific user
  /// if no uid is specified, a new one is generated
  /// This will not work with a UID from Firebase login credentials - for that, use [userFromLoginUID]
  DocumentReference userFromDocumentUID([String uid]) => _fs.collection('users').doc(uid);

  /// [userFromLoginUID] takes a unique identifier from Firebase Login credentials for a user,
  /// and returns a query to find that user
  /// This will not work with a document UID - for that, use [userFromDocumentUID]
  Query userFromLoginUID(String uid) => _fs.collection('users').where('login_uid', '==', uid);

  /// [allMeals] returns all documents for the meal collection meals
  CollectionReference allMeals() => _fs.collection('meals');

  /// [meal] takes a unique identifier for a meal, and returns a DocumentReference to a specific meal
  /// if no uid is specified, a new one is generated
  DocumentReference meal([String uid]) => _fs.collection('meals').doc(uid);

  /// [allActivities] returns all documents from the classes collection
  CollectionReference allActivities() => _fs.collection('activities');

  /// [singleClass] takes a unique identifier for a class, and returns a DocumentReference to a specific class
  /// if no uid is specified, a new one is generated
  DocumentReference singleClass([String uid]) => _fs.collection('activities').doc(uid);

  /// [allShifts] references all shifts for all users
  CollectionReference allShifts() => _fs.collection('shifts');

}
