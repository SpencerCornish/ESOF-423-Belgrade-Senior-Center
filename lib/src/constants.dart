import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:date_format/date_format.dart';

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

  static const viewMembers = '/view/members';

  static const editMember = '/edit/member/:user_uid';

  static String generateEditMemberURL(String uid) => '/edit/member/$uid';

  static const viewActivity = '/view/activities';
  static const viewMeal = '/view/meals';

  static const viewShifts = '/view/shifts';

  static const viewAllShifts = '/admin/shifts';

  // TODO: Fill in more routes here

}

class ExportHeader {
  static const user = [
    'ID',
    'Last',
    'First',
    'Email',
    'Address',
    'Phone',
    'Cell',
    'Position',
    'Role',
    'Dietary Restrictions',
    'Disabilities',
    'Medical Issues',
    'Membership Start Date',
    'Membership Renewal Date',
  ];

  static const activity = [
    'ID',
    'Name',
    'Instructor',
    'Capacity',
    'location',
    'Start',
    'End',
  ];

  static const meal = [
    'ID',
    'Start',
    'End',
    'Menu',
  ];

  static const shift = [
    'Punch ID',
    'First',
    'Last',
    'In Time',
    'Out Time',
    'Duration',
  ];
}

enum Role {
  ADMIN,
  VOLUNTEER,
  MEMBER,
}

/// The different authentication states the UI can be in.
/// This should not be used as a replacement for firebase
/// auth checks.
enum AuthState {
  LOADING,
  SUCCESS,
  INAUTHENTIC,
  PASS_RESET_SENT,
  ERR_PASSWORD,
  ERR_NOT_FOUND,
  ERR_EMAIL,
  ERR_OTHER,
}

/// [formatTime] turns a time into a human readable string
String formatTime(DateTime time) =>
    time == null ? "" : formatDate(time, [DD, ", ", M, " ", dd, " ", yyyy, " at ", hh, ":", nn, " ", am]);

/// Validates email addresses
bool emailIsValid(String email) => EmailValidator.validate(email);

/// Validates passwords meet minimum requirements
bool passwordIsValid(String password) => password.length > 6 && password.contains(new RegExp(r'[0-9A-Z]*'));

String stringToBase(String email) => base64Encode(utf8.encode(email));

String baseToString(String base) => utf8.decode(base64Decode(base));
