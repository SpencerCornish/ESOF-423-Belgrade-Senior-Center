import 'package:test/test.dart';
import 'package:bsc/src/constants.dart';

void main() {
  //Vars for testing
  final emails = <String, bool> {
    "daniel.bachler@comcast.net":true,
    "daniel.bachler.comcast.net":false,
    "daniel.bachler@comcast":false,
    "@google":false,
    "":false,
    "1":false,
    "1@1.1":false
  };

  group('Constants -', () {
    test('emailValidator correctly checks emails', () {
      emails.forEach((email, isValid) => expect(InputValidator.emailValidator(email),isValid));
    });

    test('stringToBase and baseToString properly encodes strings', () {
      expect(baseToString(stringToBase("test")), "test");
    });
  });
}