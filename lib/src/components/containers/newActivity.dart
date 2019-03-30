import 'dart:html' hide History;

import 'package:built_collection/built_collection.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../model/activity.dart';
import '../../constants.dart';
import '../../state/app.dart';
import '../core/nav.dart';
import '../../model/user.dart';

class NewActivityProps {
  AppActions actions;
  User user;
}

class NewActivityState {
  bool activityNameIsValid;
  bool instructorNameIsValid;
  bool locationIsValid;
  bool capacityIsValid;
  bool timeIsValid;
}

class NewActivity extends Component<NewActivityProps, NewActivityState> {
  NewActivity(props) : super(props);

  @override
  NewActivityState getInitialState() => NewActivityState()
    ..activityNameIsValid = true
    ..instructorNameIsValid = true
    ..locationIsValid = true
    ..capacityIsValid = true
    ..timeIsValid = true;

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..children = [
      new Nav(new NavProps()
        ..actions = props.actions
        ..user = props.user),
      new VDivElement()
        ..className = 'container'
        ..children = [
          _activityCreation(),
        ]
    ];

  //create the text boxes that are used to create new users
  VNode _activityCreation() => new VDivElement()
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
                            ..text = "Activity Creation"
                        ]
                    ],
                  //create the input fields for activity name and instructor's name
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
                                        ..id = 'actName-lab'
                                        ..children = [
                                          new VLabelElement()
                                            ..className = 'label'
                                            ..text = "Activity Name"
                                        ],
                                      new VDivElement()
                                        ..className = 'field is-horizontal'
                                        ..children = [
                                          new VParagraphElement()
                                            ..className = 'control'
                                            ..children = [
                                              new VInputElement()
                                                ..onInput = _activityNameValidator
                                                ..className = 'input ${state.activityNameIsValid ? '' : 'is-danger'}'
                                                ..id = 'act-input'
                                                ..placeholder = "e.g. Yoga",
                                              new VParagraphElement()
                                                ..className =
                                                    'help is-danger ${state.activityNameIsValid ? 'is-invisible' : ''}'
                                                ..text = 'Activity name may not be empty'
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
                                        ..id = 'instructName-lab'
                                        ..children = [
                                          new VLabelElement()
                                            ..className = 'label'
                                            ..text = "Instructor's Name"
                                        ],
                                      new VDivElement()
                                        ..className = 'field is-horizontal'
                                        ..children = [
                                          new VParagraphElement()
                                            ..className = 'control'
                                            ..children = [
                                              new VInputElement()
                                                ..onInput = _instructorNameValidator
                                                ..className = 'input ${state.instructorNameIsValid ? '' : 'is-danger'}'
                                                ..id = 'instructorName-input'
                                                ..placeholder = "First and Last Name",
                                              new VParagraphElement()
                                                ..className =
                                                    'help is-danger ${state.instructorNameIsValid ? 'is-invisible' : ''}'
                                                ..text = 'Instructor name may not be blank'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
                  //create the Location And Capacity Input fields
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
                                        ..id = 'location-lab'
                                        ..children = [
                                          new VLabelElement()
                                            ..className = 'label'
                                            ..text = "Location"
                                        ],
                                      new VDivElement()
                                        ..className = 'field is-horizontal'
                                        ..children = [
                                          new VParagraphElement()
                                            ..className = 'control'
                                            ..children = [
                                              new VInputElement()
                                                ..onInput = _locationValidator
                                                ..className = 'input ${state.locationIsValid ? '' : 'is-danger'}'
                                                ..id = 'location-input'
                                                ..placeholder = "Where is the activity taking place?",
                                              new VParagraphElement()
                                                ..className =
                                                    'help is-danger ${state.locationIsValid ? 'is-invisible' : ''}'
                                                ..text = 'Location may not be blank'
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
                                        ..id = 'capacity-lab'
                                        ..children = [
                                          new VLabelElement()
                                            ..className = 'label'
                                            ..text = "Capacity"
                                        ],
                                      new VDivElement()
                                        ..className = 'field is-horizontal'
                                        ..children = [
                                          new VParagraphElement()
                                            ..className = 'control'
                                            ..children = [
                                              new VInputElement()
                                                ..onInput = _capacityValidator
                                                ..className = 'input ${state.capacityIsValid ? '' : 'is-danger'}'
                                                ..id = 'capacity-input'
                                                ..type = 'number',
                                              new VParagraphElement()
                                                ..className =
                                                    'help is-danger ${state.capacityIsValid ? 'is-invisible' : ''}'
                                                ..text = 'Capacity must be -1, or more than 0'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
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
                                        ..id = 'day-lab'
                                        ..children = [
                                          new VLabelElement()
                                            ..className = 'label'
                                            ..text = "Date"
                                        ],
                                      new VDivElement()
                                        ..className = 'field is-horizontal'
                                        ..children = [
                                          new VParagraphElement()
                                            ..className = 'control'
                                            ..children = [
                                              new VInputElement()
                                                ..className = 'input'
                                                ..id = 'day-input'
                                                ..type = 'date'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],

                  //Create the start and end time input fields
                  //create the Start Time Input field
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
                                        ..id = 'timeStart-lab'
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
                                                ..id = 'timeStart-input'
                                                ..type = 'time',
                                              new VParagraphElement()
                                                ..className =
                                                    'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                                                ..text = 'Activity must start before it ends'
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
                                        ..id = 'timeEnd-lab'
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
                                                ..id = 'timeEnd-input'
                                                ..type = 'time',
                                              new VParagraphElement()
                                                ..className =
                                                    'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                                                ..text = 'Activity must start before it ends'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
                  //TODO: possibly find a way for admin to add a picture to the database and allow activities to access and utilize them

                  //create the submit button
                  new VDivElement()
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
                    ]
                ]
            ]
        ]
    ];

  void _activityNameValidator(_) {
    InputElement actName = querySelector('#act-input');
    bool isValid = InputValidator.nameValidator(actName.value);
    setState((NewActivityProps, NewActivityState) => NewActivityState..activityNameIsValid = isValid);
  }

  void _instructorNameValidator(_) {
    InputElement instructorName = querySelector('#instructorName-input');
    bool isValid = InputValidator.nameValidator(instructorName.value);
    setState((NewActivityProps, NewActivityState) => NewActivityState..instructorNameIsValid = isValid);
  }

  void _locationValidator(_) {
    InputElement location = querySelector('#location-input');
    bool isValid = InputValidator.nameValidator(location.value);
    setState((NewActivityProps, NewActivityState) => NewActivityState..locationIsValid = isValid);
  }

  void _capacityValidator(_) {
    InputElement capacity = querySelector('#capacity-input');
    bool isValid = InputValidator.capactiyValidator(int.parse(capacity.value));
    setState((NewActivityProps, NewActivityState) => NewActivityState..capacityIsValid = isValid);
  }

  void _timeValidator(_) {
    InputElement start = querySelector('#timeStart-input');
    InputElement end = querySelector('#timeEnd-input');
    InputElement day = querySelector('#day-input');

    DateTime serveDay = DateTime.parse(day.value);

    String startTime = _parseDate(serveDay, start.value);
    String endTime = _parseDate(serveDay, end.value);

    DateTime startDT = DateTime.parse(startTime);
    DateTime endDT = DateTime.parse(endTime);

    //Is valid bool
    bool isValid = InputValidator.timeValidator(startDT, endDT);

    setState((NewActivityProps, NewActivityState) => NewActivityState..timeIsValid = isValid);
  }

  //method used for the submit click
  //timeEnd-input, timeStart-input, capacity-input, location-input, instructorName-input, act-input
  _submitClick(_) {
    InputElement activity = querySelector('#act-input');
    InputElement instructor = querySelector('#instructorName-input');
    InputElement location = querySelector('#location-input');
    InputElement capacity = querySelector('#capacity-input');
    InputElement start = querySelector('#timeStart-input');
    InputElement end = querySelector('#timeEnd-input');
    InputElement day = querySelector('#day-input');
    DateTime date = DateTime.parse(day.value);
    String tempStart = start.value.toString(); //make the start time a string for use in _parseDate
    String tempEnd = end.value.toString(); //make the end time a string for use in _parseDate

    String startTime, endTime;
    int cap; //capacity of activity
    startTime = _parseDate(date, tempStart);
    endTime = _parseDate(date, tempEnd);
    cap = int.parse(capacity.value);

    Activity newActivity = (new ActivityBuilder()
          ..capacity = cap
          ..endTime = DateTime.parse(endTime)
          ..startTime = DateTime.parse(startTime)
          ..instructor = instructor.value
          ..location = location.value
          ..name = activity.value
          ..users = new ListBuilder<String>())
        .build();

    props.actions.server.updateOrCreateActivity(newActivity);
    props.actions.server.fetchAllActivities();

    history.push(Routes.dashboard);
  }

  ///[_parseDate] is a function adopted from the _showDate function that Josh wrote to make a string from a date and time input compatible with DateTime data types
  String _parseDate(DateTime date, String time) {
    String tempDay, tempMonth, tempTime;

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

    print(time);
    tempTime = "${time}:00.000";

    return "${date.year}-${tempMonth}-${tempDay} ${tempTime}";
  }
}
