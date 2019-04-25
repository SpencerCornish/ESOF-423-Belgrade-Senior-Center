import 'package:test/test.dart';
import 'package:bsc/src/constants.dart';

import 'test_data.dart';

void main() {
  group('Constants -', () {
    //Testing for Validator Class
    test('nameValidator only denies blank strings', () {
      expect(Validator.name(""), false);
      expect(Validator.name("test"), true);
    });
    test('emailValidator correctly checks emails', () {
      testEmails.forEach((email, isValid) => expect(Validator.email(email), isValid));
    });
    test('phoneNumberValidator works correctly', () {
      testPhones.forEach((number, isValid) => expect(Validator.phoneNumber(number), isValid));
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
