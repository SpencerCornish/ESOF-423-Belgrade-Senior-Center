import 'package:email_validator/email_validator.dart';
import 'dart:convert';

/// [Routes] defines URIs for the application
class Routes {
  /// Route to the base (or Home) of the app
  static const home = '/';

  /// Route for forms page where new users, meals, and classes can be created
  static const createMember = '/new/member';

  /// Route used after a password reset
  static const resetContinue = '/pw_reset/:email_hash';

  static const dashboard = '/dashboard';

  static const viewMember = '/view/members';

  // TODO: Fill in more routes here

}

//Validates various data types across project
class InputValidator {
  //Validates names, only issue is if blank
  static bool nameValidator(String input) {
    if(input == "") {
      return false;
    }
    return true;
  }

  //Validates emails by using emailValidator function
  static bool emailValidator(String input) {
    return EmailValidator.validate(input);
  }

  //Validates phone numbers
  static bool phoneNumberValidator(String input) {
    //Splits string into a list
    List<String> temp = input.split('');
    //Counts digits in input string
    int count = 0;
    for (String x in temp) {
      if(int.tryParse(x) != null) {
        count++;
      }
    }
    if(count == 10 || count == 11) {
      return true;
    } else {return false;}
  }

  //Validates addresses TODO finish this
  static bool addressValidator(String input) {

  }
}

enum Role {
  ADMIN,
  VOLUNTEER,
  MEMBER,
}

/// The different authentication states the UI can be in.
/// This should not be used as a replacement for firebase
/// auth checks.
enum AuthState { LOADING, SUCCESS, INAUTHENTIC, PASS_RESET_SENT, ERR_PASSWORD, ERR_NOT_FOUND, ERR_EMAIL, ERR_OTHER }

String stringToBase(String email) => base64Encode(utf8.encode(email));

String baseToString(String base) => utf8.decode(base64Decode(base));
