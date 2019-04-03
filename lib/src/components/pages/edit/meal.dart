import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../state/app.dart';
import '../../core/nav.dart';
import '../../../model/meal.dart';
import '../../../model/user.dart';

class EditMealProps {
  AppActions actions;
  User user;
  BuiltMap<String, Meal> mealMap;
  String selectedMealUID;
}

class EditMealState {
  bool edit;
}

class EditMeal extends Component<EditMealProps, EditMealState> {
  EditMeal(props) : super(props);

  @override
  EditMealState getInitialState() => EditMealState()..edit = false;

  @override
  void componentWillUpdate(EditMealProps nextProps, EditMealState nextState) {
    super.componentWillUpdate(nextProps, nextState);
  }

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() {
    Meal meal = props.mealMap[props.selectedMealUID];
    if (meal == null) return _renderMealNotFound();
    return new VDivElement()
      ..children = [
        new Nav(new NavProps()
          ..actions = props.actions
          ..user = props.user),
        _mealCreation(meal),
      ];
  }

  ///[_showDate] helper function to put a date into a proper format to view in a date type input box
  String _showDate(DateTime date) {
    String tempDay, tempMonth;

    if (date.day.toString().length == 1) {
      tempDay = "0${date.day}";
    } else {
      tempDay = date.day.toString();
    }

    if (date.month.toString().length == 1) {
      tempMonth = "0${date.month}";
    } else {
      tempMonth = date.month.toString();
    }

    return "${date.year}-${tempMonth}-${tempDay}";
  }

  ///[_showTime] helper function to put a time into a proper format to view in a time type input box
  String _showTime(String hour, String min) {
    if (hour.length == 1) {
      hour = "0${hour}";
    }

    if (min.length == 1) {
      min = "0${min}";
    }
    return hour + ":" + min;
  }

  //create the text boxes that are used to create new users
  VNode _mealCreation(Meal meal) => new VDivElement()
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
                            ..text = "Meal Edit"
                        ]
                    ],
                  //create the input fields for meal start and end times, and date
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      new VDivElement()
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'serveDate-input'
                                                ..type = 'date'
                                                ..readOnly = !state.edit
                                                ..value = _showDate(meal.startTime)
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ],
                      new VDivElement()
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'mealStart-input'
                                                ..type = 'time'
                                                ..readOnly = !state.edit
                                                ..value = _showTime(
                                                    meal.startTime.hour.toString(), meal.startTime.minute.toString())
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ],
                      new VDivElement()
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'mealEnd-input'
                                                ..type = 'time'
                                                ..readOnly = !state.edit
                                                ..value = _showTime(
                                                    meal.endTime.hour.toString(), meal.endTime.minute.toString())
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],

                  //create the input box for what the meal is
                  new VDivElement()
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
                      new VDivElement()
                        ..className = 'field-body'
                        ..children = [
                          new VDivElement()
                            ..className = 'field'
                            ..children = [
                              new VDivElement()
                                ..className = 'control'
                                ..children = [
                                  new VTextAreaElement()
                                    ..className = 'textarea'
                                    ..id = 'meal-input'
                                    ..text = _listHelper(meal)
                                    ..readOnly = !state.edit
                                ]
                            ]
                        ]
                    ],

                  //create the submit or edit button
                  _renderButton()
                ]
            ]
        ]
    ];

  VNode _renderButton() {
    if (state.edit) {
      return _renderSubmit();
    }
    return (_renderEdit());
  }

  ///[_renderEdit] creates a button to toggle from a view page to increase the number of input fields
  _renderEdit() => new VDivElement()
    ..className = 'field is-grouped is-grouped-right'
    ..children = [
      new VDivElement()
        ..className = 'control'
        ..children = [
          new VAnchorElement()
            ..className = 'button is-link'
            ..text = "Edit"
            ..onClick = _editClick
        ],
    ];

  ///[_renderSubmit] create the submit button to collect the data
  _renderSubmit() => new VDivElement()
    ..className = 'field is-grouped is-grouped-right'
    ..children = [
      new VDivElement()
        ..className = 'control'
        ..children = [
          new VAnchorElement()
            ..className = 'button is-link'
            ..text = "Submit"
            ..onClick = _submitClick
        ]
    ];

  ///[_editClick] listener for the click action of the edit button to put page into an edit state
  _editClick(_) {
    setState((props, state) => state..edit = !state.edit);
  }

  String _listHelper(Meal meal) {
    String menu = "";

    for (String menuItem in meal.menu.toList()) {
      menu = menu + menuItem;
    }

    return menu;
  }

  //method used for the submit click
  //variable names serveDate-input, mealStart-input, mealEnd-input, meal-input
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
    startTime = _parseDate(serveDay, tempStart);
    endTime = _parseDate(serveDay, tempEnd);

    ListBuilder<String> temp = new ListBuilder();
    temp.add(menu);

    Meal update = props.mealMap[props.selectedMealUID].rebuild((builder) => builder
      ..startTime = DateTime.parse(startTime)
      ..endTime = DateTime.parse(endTime)
      ..menu = temp);

    props.actions.server.updateOrCreateMeal(update);
    props.actions.server.fetchAllMeals();

    setState((props, state) => state..edit = !state.edit);
  }

  ///[_renderUserNotFound] if the UID is bad this page will simply say the user was not found
  _renderMealNotFound() => new VDivElement()..text = 'not found!';

  ///[_parseDate] is a function adopted from the _showDate function that Josh wrote to make a string from a date and time input compatible with DateTime data types
  String _parseDate(DateTime date, String time) {
    String tempDay, tempMonth, tempTime;
    List<String> timeList;

    if (date.day.toString().length == 1) {
      tempDay = "0${date.day}";
    } else {
      tempDay = date.day.toString();
    }

    if (date.month.toString().length == 1) {
      tempMonth = "0${date.month}";
    } else {
      tempMonth = date.month.toString();
    }

    timeList = time.split(":");

    if (timeList[0].length == 1) {
      timeList[0] = "0${timeList[0]}";
    }

    if (timeList[1].length == 1) {
      timeList[1] = "0${timeList[1]}";
    }

    tempTime = timeList[0] + ":" + timeList[1] + ":00.000";

    return "${date.year}-${tempMonth}-${tempDay} ${tempTime}";
  }
}
