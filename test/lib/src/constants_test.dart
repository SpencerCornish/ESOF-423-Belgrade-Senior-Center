import 'package:test/test.dart';
import 'package:bsc/src/constants.dart';

void main() {
  //Vars for testing
  final emails = <String, bool>{
    "daniel.bachler@comcast.net": true,
    "daniel.bachler.comcast.net": false,
    "daniel.bachler@comcast": false,
    "@google": false,
    "": false,
    "1": false,
    "1@1.1": false
  };

  final phoneNumbers = <String, bool>{
    "4252734489": true,
    "425-273-4489": true,
    "1-425-273-4489": true,
    "1(425)273-4489": true,
    "1": false,
    "123456789123": false,
    "dan": false
  };

  group('Constants -', () {
    //Testing for InputValidator Class
    test('nameValidator only denies blank strings', () {
      expect(InputValidator.nameValidator(""), false);
      expect(InputValidator.nameValidator("test"), true);
    });
    test('emailValidator correctly checks emails', () {
      emails.forEach((email, isValid) => expect(InputValidator.emailValidator(email), isValid));
    });
    test('phoneNumberValidator works correctly', () {
      phoneNumbers.forEach((number, isValid) => expect(InputValidator.phoneNumberValidator(number), isValid));
    });

    //InputValidator.addressValidator currently only returns true, redo when method written
    test('addressValidator', () {
      expect(InputValidator.addressValidator("input"), true);
    });
    //Testing for other methods
    test('stringToBase and baseToString properly encodes strings', () {
      expect(baseToString(stringToBase("test")), "test");
    });
  });
}
