import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// [Routes] defines URIs for the application
class Routes {
  /// Route to the base (or Home) of the app
  static const home = '/';

  /// Route used after a password reset
  static const resetContinue = '/pw_reset/:email_hash';

  static const dashboard = '/dashboard';

  // TODO: Fill in more routes here
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

/// Validates email addresses
bool emailIsValid(String email) => EmailValidator.validate(email);

/// Validates passwords meet minimum requirements
bool passwordIsValid(String password) => password.length > 8 && password.contains(new RegExp(r'[0-9A-Z]*'));

String stringToBase(String email) => base64Encode(utf8.encode(email));

String baseToString(String base) => utf8.decode(base64Decode(base));
