import 'package:mockito/mockito.dart';
import 'package:firebase/firestore.dart';

import 'package:bsc/src/firebase/firebaseClient.dart';

class FirestoreMock extends Mock implements Firestore {}

class FirebaseClientMock extends Mock implements FirebaseClient {}
