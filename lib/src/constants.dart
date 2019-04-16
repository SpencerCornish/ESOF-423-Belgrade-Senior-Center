import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:date_format/date_format.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:wui_builder/wui_builder.dart';

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
  static const editMeal = '/edit/meal/:meal_uid';
  static const editActivity = '/edit/activity/:activity_uid';
  static const activitySignUp = '/signup/activity/byuser/:user_uid';

  static String generateEditMemberURL(String uid) => '/edit/member/$uid';
  static String generateEditMealURL(String uid) => '/edit/meal/$uid';
  static String generateEditActivityURL(String uid) => '/edit/activity/$uid';
  static String generateActivitySignUpURL(String uid) => '/signup/activity/byuser/$uid';

  static const viewActivity = '/view/activities';
  static const viewMeal = '/view/meals';

  static const viewShifts = '/view/shifts';

  static const viewAllShifts = '/admin/shifts';
}

//Validates various data types across project
class Validator {
  /// [name] returns true if the name is valid
  static bool name(String input) => !(input == '');

  /// [email] validates emails, returns true if is valid
  static bool email(String input) => EmailValidator.validate(input);

  /// [phoneNumber] validates if the string represents a valid phone number
  static bool phoneNumber(String input) {
    //Splits string into a list of chars
    List<String> temp = input.split('');
    //Counts digits in input string
    int count = 0;
    for (String x in temp) {
      if (int.tryParse(x) != null) {
        count++;
      }
    }
    if (count == 10 || count == 11) {
      return true;
    } else {
      return false;
    }
  }

  static bool address(String input) => input != "";

  /// [time] ensures start is before end
  static bool time(DateTime start, DateTime end) => start.isBefore(end);

  /// [capacity] ensures a valid usage size
  static bool capacity(int i) => i > -2;
}

/// [ExportHeader] is the header strings for csv table outputs
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

class HttpEndpoint {
  static const baseUrl = "https://us-central1-bsc-development.cloudfunctions.net/";

  static const createUserLogin = baseUrl + "createUserLogin";
}

/// The different authentication states the UI can be in.
/// This should not be used as a replacement for firebase
/// auth checks on the backend.
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

/// [formatTimeRange] turns a start - end time into a human readable string
String formatTimeRange(DateTime start, DateTime end) {
  String range;
  range = start == null ? "" : formatDate(start, [DD, ", ", M, " ", dd, " ", yyyy, ",\t", hh, ":", nn, " ", am]);
  range = range + " - ";
  range = range + (end == null ? "" : formatDate(end, [hh, ":", nn, " ", am]));

  return range;
}

String checkText(String text) => text != '' ? text : "N/A";

String tdClass(String text) => text != '' ? 'td' : "td has-text-grey";

/// identical render methods for the various pages

/// [renderSearch] render search bar
renderSearch(_searchListener(_)) => new VDivElement()
  ..className = 'column is-narrow'
  ..children = [
    new VDivElement()
      ..className = 'field'
      ..children = [
        new VParagraphElement()
          ..className = 'control has-icons-left'
          ..children = [
            new VInputElement()
              ..className = 'input'
              ..placeholder = 'Search'
              ..type = 'submit'
              ..id = 'Search'
              ..onKeyUp = _searchListener
              ..type = 'text',
            new VSpanElement()
              ..className = 'icon is-left'
              ..children = [new Vi()..className = 'fas fa-search'],
          ],
      ],
  ];

/// [renderExport] render the export csv button
renderExport(_onExportCsvClick(_)) => new VDivElement()
  ..className = 'column is-narrow'
  ..children = [
    new VDivElement()
      ..className = 'field'
      ..children = [
        new VDivElement()
          ..className = 'control'
          ..children = [
            new VParagraphElement()
              ..className = 'button is-rounded'
              ..onClick = _onExportCsvClick
              ..children = [
                new VSpanElement()
                  ..className = 'icon'
                  ..children = [new Vi()..className = 'fas fa-file-csv'],
                new VSpanElement()..text = 'Export',
              ],
          ],
      ],
  ];

///[renderRefresh] a refresh button to ensure the data is up-to-date
renderRefresh(_onRefreshClick(_)) => new VDivElement()
  ..className = 'column is-narrow'
  ..children = [
    new VDivElement()
      ..className = 'field'
      ..children = [
        new VDivElement()
          ..className = 'control'
          ..children = [
            new VParagraphElement()
              ..className = 'button is-rounded'
              ..onClick = _onRefreshClick
              ..children = [
                new VSpanElement()
                  ..className = 'icon'
                  ..children = [new Vi()..className = 'fas fa-sync-alt'],
                new VSpanElement()..text = 'Refresh',
              ],
          ],
      ],
  ];

/// [titleRow] helper function to create the title row
List<VNode> titleRow(List<String> title) {
  List<VNode> nodeList = new List();
  for (String title in title) {
    nodeList.add(
      new VTableCellElement()
        ..className = 'title is-5'
        ..text = title,
    );
  }
  return nodeList;
}

/// [stringToBase] encodes strings to base64 format
String stringToBase(String email) => base64Encode(utf8.encode(email));

/// [baseToString] encodes base64 strings to utf-8 decoded string format
String baseToString(String base) => utf8.decode(base64Decode(base));
