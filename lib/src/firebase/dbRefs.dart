import 'package:firebase/firestore.dart';

class DbRefs {
  Firestore _fs;

  DbRefs(this._fs);

  userRef(){
    _fs.collection('users');
  }

  mealRef(){
    _fs.collection('meals');
  }

  classRef(){
    _fs.collection('classes');
  }
}
