import 'package:email_validator/email_validator.dart';
import 'dart:convert';

/// [Routes] defines URIs for the application
class Routes {
  /// Route to the base (or Home) of the app
  static const home = '/';

  /// Route for forms page where new users can be created
  static const loginRedirect = '/login/next/:next_url';

  // Generate the above URL
  static String generateLoginRedirect(String nextUrl) => '/login/next/${stringToBase(nextUrl)}';

  /// Route for forms page where new users, meals, and classes can be created
  static const createMember = '/new/member';
  
  //route for new activity page
  static const createAct = '/new/activity';

  static const createMeal = '/new/meal';

  /// Route used after a password reset
  static const resetContinue = '/pw_reset/:email_hash';

  static const dashboard = '/dashboard';

  static const viewMember = '/view/members';

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
bool passwordIsValid(String password) => password.length > 6 && password.contains(new RegExp(r'[0-9A-Z]*'));

String stringToBase(String email) => base64Encode(utf8.encode(email));

String baseToString(String base) => utf8.decode(base64Decode(base));
