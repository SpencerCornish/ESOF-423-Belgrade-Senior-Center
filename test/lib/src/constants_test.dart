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
    //Testing for Validator Class
    test('nameValidator only denies blank strings', () {
      expect(Validator.name(""), false);
      expect(Validator.name("test"), true);
    });
    test('emailValidator correctly checks emails', () {
      emails.forEach((email, isValid) => expect(Validator.email(email), isValid));
    });
    test('phoneNumberValidator works correctly', () {
      phoneNumbers.forEach((number, isValid) => expect(Validator.phoneNumber(number), isValid));
    });

    //Validator.addressValidator currently only returns true, redo when method written
    test('addressValidator', () {
      expect(Validator.address("input"), true);
    });

    //Validator.timeValidator rejects times where the event ends before it starts
    test('timeValidator rejects time sets where end is before start', () {
      String moonLanding = "1969-07-20 20:18:04Z";

      DateTime moonLandingDT = DateTime.parse(moonLanding);
      DateTime now = DateTime.now();

      expect(Validator.time(now, moonLandingDT), false);
    });

    //Validator.capacityValidator rejects capacities below -2
    test('capacityValidator rejects capacities below -2', () {
      expect(Validator.capacity(-4), false);
      expect(Validator.capacity(-1), true);
      expect(Validator.capacity(0), true);
      expect(Validator.capacity(20), true);
    });
    //Testing for other methods
    test('stringToBase and baseToString properly encodes strings', () {
      expect(baseToString(stringToBase("test")), "test");
    });
  });
}
