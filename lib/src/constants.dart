import 'package:email_validator/email_validator.dart';

//  TODO: Put constant values here :)

/// [Routes] defines URIs for the application
class Routes {
  /// Route to the base (or Home) of the app
  static const home = '/';

  static const dashboard = '/dashboard';

  // TODO: Fill in more routes here
}

/// Validates email addresses
bool emailIsValid(String email) => EmailValidator.validate(email);

/// Validates passwords meet minimum requirements
bool passwordIsValid(String password) => password.length > 8 && password.contains(new RegExp(r'[0-9A-Z]*'));
