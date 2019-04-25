import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:bsc/src/firebase/dbRefs.dart';
import 'package:firebase/firestore.dart';

import '../test_data.dart';
import '../mocks.dart';

void main() {
  DbRefs refs;
  Firestore firestore;

  setUp(() {
    firestore = new FirestoreMock();
    refs = new DbRefs(firestore);
  });
  group("DB Refs -", () {
    test('allUsers gets correct collection', () {
      refs.allUsers();

      verify(firestore.collection('users'));
    });
    test('userFromDocumentUID gets correct document', () {
      refs.userFromDocumentUID("testUID");

      verify(firestore.collection('users').doc("testUID"));
    });
    test('userFromLoginUID makes correct query', () {
      refs.userFromLoginUID("TestID");

      verify(firestore.collection('users').where('login_uid', '==', "TestID"));
    });
    test('allMeals gets correct collection', () {
      refs.allMeals();

      verify(firestore.collection('meals'));
    });
    test('meal gets correct document', () {
      refs.meal("testUID");

      verify(firestore.collection('meals').doc('testUID'));
    });
    test('allActivities gets correct collection', () {
      refs.allActivities();

      verify(firestore.collection('activities'));
    });
    test('activity gets correct document', () {
      refs.activity("testUID");

      verify(firestore.collection('activity').doc("testUID"));
    });
    test('allShifts gets correct collection', () {
      refs.allShifts();

      verify(firestore.collection('shifts'));
    });
  });
}
