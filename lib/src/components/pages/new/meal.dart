import 'dart:html' hide History;

import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../constants.dart';
import '../../../state/app.dart';
import '../../core/nav.dart';
import '../../../model/meal.dart';
import '../../../model/user.dart';

/// [NewMealProps] class for the new meal page passed in propeerties
class NewMealProps {
  AppActions actions;
  User user;
  Meal meal;
}

/// [NewMealState] state class for the new meal page
class NewMealState {
  bool timeIsValid;
  bool mealIsValid;
}

/// [NewMeal] class to create the new meal page for creating an meal
class NewMeal extends Component<NewMealProps, NewMealState> {
  NewMeal(props) : super(props);

  @override
  NewMealState getInitialState() => NewMealState()
    ..timeIsValid = false
    ..mealIsValid = false;

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..children = [
      new Nav(new NavProps()
        ..actions = props.actions
        ..user = props.user),
      _mealCreation(),
    ];

  /// [_mealCreation] create the text boxes that are used to create new users
  VNode _mealCreation() => new VDivElement()
    ..className = 'container'
    ..children = [
      new VDivElement()
        ..className = 'columns is-centered margin-top'
        ..children = [
          new VDivElement()
            ..className = 'column is-three-quarters'
            ..children = [
              new VDivElement()
                ..className = 'box'
                ..children = [
                  //create the Title of Box
                  new VDivElement()
                    ..className = 'field is-grouped is-grouped-left'
                    ..children = [
                      new VDivElement()
                        ..className = 'cloumn has-text-centered'
                        ..children = [
                          new Vh1()
                            ..className = 'title'
                            ..text = "Meal Creation"
                        ]
                    ],
                  //create the input fields for meal start and end times, and date
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      _renderDate(),
                      _renderStart(),
                      _renderEnd(),
                    ],

                  //create the input box for what the meal is
                  _renderMenuLabel(),
                  //create the submit button
                  _renderSubmit(),
                ]
            ]
        ]
    ];

  /// [_renderDate] render date input and label
  _renderDate() => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-body'
                ..children = [
                  new VDivElement()
                    ..className = 'field'
                    ..id = 'date-lab'
                    ..children = [
                      new VLabelElement()
                        ..className = 'label'
                        ..text = "Serving Date"
                    ],
                  new VDivElement()
                    ..className = 'field is-horizontal'
                    ..children = [
                      new VParagraphElement()
                        ..className = 'control'
                        ..children = [
                          new VInputElement()
                            ..onInput = _timeValidator
                            ..className = 'input ${state.timeIsValid ? '' : 'is-danger'}'
                            ..id = 'serveDate-input'
                            ..type = 'date',
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Meal needs a date and time'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderStart] render start input and label
  _renderStart() => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-body'
                ..children = [
                  new VDivElement()
                    ..className = 'field'
                    ..id = 'mealStart-lab'
                    ..children = [
                      new VLabelElement()
                        ..className = 'label'
                        ..text = "Start Time"
                    ],
                  new VDivElement()
                    ..className = 'field is-horizontal'
                    ..children = [
                      new VParagraphElement()
                        ..className = 'control'
                        ..children = [
                          new VInputElement()
                            ..onInput = _timeValidator
                            ..className = 'input ${state.timeIsValid ? '' : 'is-danger'}'
                            ..id = 'mealStart-input'
                            ..type = 'time',
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Meal ends before it begins, please correct.'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderEnd] render end input and label
  _renderEnd() => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-body'
                ..children = [
                  new VDivElement()
                    ..className = 'field'
                    ..id = 'mealEnd-lab'
                    ..children = [
                      new VLabelElement()
                        ..className = 'label'
                        ..text = "End Time"
                    ],
                  new VDivElement()
                    ..className = 'field is-horizontal'
                    ..children = [
                      new VParagraphElement()
                        ..className = 'control'
                        ..children = [
                          new VInputElement()
                            ..onInput = _timeValidator
                            ..className = 'input ${state.timeIsValid ? '' : 'is-danger'}'
                            ..id = 'mealEnd-input'
                            ..type = 'time',
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Meal ends before it begins, please correct.'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderMenuLabel] render menu label
  _renderMenuLabel() => new VDivElement()
    ..className = 'columns'
    ..children = [
      new VDivElement()
        ..className = 'column is-narrow'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-label is-normal'
                ..children = [
                  new VLabelElement()
                    ..className = 'label'
                    ..text = "Meal",
                ]
            ]
        ],
      _renderMenu(),
    ];

  /// [_renderMenu] render menu input
  _renderMenu() => new VDivElement()
    ..className = 'field-body'
    ..children = [
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VDivElement()
            ..className = 'control'
            ..children = [
              new VTextAreaElement()
                ..onInput = _mealValidator
                ..className = 'textarea ${state.mealIsValid ? '' : 'is-danger'}'
                ..id = 'meal-input'
                ..placeholder = "Enter meal information. The first 15 characters will be visible as a title",
              new VParagraphElement()
                ..className = 'help is-danger ${state.mealIsValid ? 'is-invisible' : ''}'
                ..text = 'Meal needs a menu.'
            ]
        ]
    ];

  /// [_renderSubmit] render submit button
  _renderSubmit() => new VDivElement()
    ..className = 'field is-grouped is-grouped-right'
    ..children = [
      new VDivElement()
        ..className = 'control'
        ..children = [
          new VButtonElement()
            ..className = 'button is-link is-rounded'
            ..disabled = _canActivateSubmit()
            ..text = "Submit"
            ..onClick = _submitClick
        ]
    ];

  /// [_canActivateSubmit] validator function to ensure all required fields are present before submition is possible
  bool _canActivateSubmit() {
    if (state.mealIsValid && state.timeIsValid) {
      return false; //enables button on false
    }
    return true; //disables button on true
  }

  /// [_mealValidator] validator function to ensure menu is input correctly
  _mealValidator(_) {
    TextAreaElement meal = querySelector('#meal-input');
    String menu = meal.value;
    bool isValid = Validator.name(menu);
    setState((NewMealProps, NewMealState) => NewMealState..mealIsValid = isValid);
  }

  //Checks that the meal does not start before it ends
  /// [_timeValidator] validator function to ensure time is input correctly
  _timeValidator(_) {
    //Gets the 3 date time inputs
    InputElement date = querySelector('#serveDate-input');
    InputElement time_start = querySelector('#mealStart-input');
    InputElement time_end = querySelector('#mealEnd-input');
    try {
      DateTime serveDay = DateTime.parse(date.value);

      String startTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${time_start.value}:00.000"]);
      String endTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${time_end.value}:00.000"]);

      DateTime start = DateTime.parse(startTime);
      DateTime end = DateTime.parse(endTime);

      bool isValid = Validator.time(start, end);

      setState((NewMealProps, NewMealState) => NewMealState..timeIsValid = isValid);
    } catch (_) {
      setState((NewMealProps, NewMealState) => NewMealState..timeIsValid = false);
    }
  }

  //method used for the submit click
  //variable names serveDate-input, mealStart-input, mealEnd-input, meal-input
  /// [_submitClick] method used for the submit click
  _submitClick(_) {
    InputElement date = querySelector('#serveDate-input');
    InputElement start = querySelector('#mealStart-input');
    InputElement end = querySelector('#mealEnd-input');
    TextAreaElement meal = querySelector('#meal-input');
    DateTime serveDay = DateTime.parse(date.value);
    String tempStart = start.value; //make the start time a string for use in _parseDate
    String tempEnd = end.value; //make the end time a string for use in _parseDate
    String menu = meal.value;
    String startTime, endTime;
    startTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${tempStart}:00.000"]);
    endTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${tempEnd}:00.000"]);
    ListBuilder<String> temp = new ListBuilder();
    temp.add(menu);

    Meal newMeal = (new MealBuilder()
          ..startTime = DateTime.parse(startTime)
          ..endTime = DateTime.parse(endTime)
          ..menu = temp)
        .build();

    props.actions.server.updateOrCreateMeal(newMeal);

    history.push(Routes.viewMeal);
  }
}
