import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../model/activity.dart';
import '../../state/app.dart';
import '../core/nav.dart';
import '../../model/user.dart';

class EditActivityProps {
  AppActions actions;
  User user;
  BuiltMap<String, Activity> activityMap;
  String selectedActivityUID;
}

class EditActivityState {
  bool edit;
}

class EditActivity extends Component<EditActivityProps, EditActivityState> {
  EditActivity(props) : super(props);

  History _history;

  @override
  EditActivityState getInitialState() => EditActivityState()..edit = false;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillUpdate(EditActivityProps nextProps, EditActivityState nextState) {
    super.componentWillUpdate(nextProps, nextState);
  }

  @override
  VNode render() {
    Activity act = props.activityMap[props.selectedActivityUID];
    if (act == null) return _renderActivityNotFound();
    return new VDivElement()
      ..children = [
        new Nav(new NavProps()
          ..actions = props.actions
          ..user = props.user),
        new VDivElement()
          ..className = 'container'
          ..children = [
            _activityCreation(act),
          ]
      ];
  }

  //create the text boxes that are used to create new users
  VNode _activityCreation(Activity act) => new VDivElement()
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'act-input'
                                                ..defaultValue = act.name
                                                ..readOnly = !state.edit
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'instructorName-input'
                                                ..defaultValue = act.instructor
                                                ..readOnly = !state.edit
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
                                            ..text = "Loaction"
                                        ],
                                      new VDivElement()
                                        ..className = 'field is-horizontal'
                                        ..children = [
                                          new VParagraphElement()
                                            ..className = 'control'
                                            ..children = [
                                              new VInputElement()
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'location-input'
                                                ..defaultValue = act.location
                                                ..readOnly = !state.edit
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'capacity-input'
                                                ..type = 'number'
                                                ..readOnly = !state.edit
                                                ..defaultValue = act.capacity.toString()
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'day-input'
                                                ..type = 'date'
                                                ..value = _showDate(act.startTime)
                                                ..readOnly = !state.edit
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'timeStart-input'
                                                ..type = 'time'
                                                ..readOnly = !state.edit
                                                ..value = _showTime(
                                                    act.startTime.hour.toString(), act.startTime.minute.toString())
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
                                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                                ..id = 'timeEnd-input'
                                                ..type = 'time'
                                                ..readOnly = !state.edit
                                                ..value = _showTime(
                                                    act.endTime.hour.toString(), act.endTime.minute.toString())
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
                  //create the submit button
                  _renderButton(),
                ]
            ]
        ]
    ];

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

  ///[_editClick] listener for the click action of the edit button to put page into an edit state
  _editClick(_) {
    setState((props, state) => state..edit = !state.edit);
  }

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

    Activity update = props.activityMap[props.selectedActivityUID].rebuild((builder) => builder
      ..capacity = cap
      ..endTime = DateTime.parse(endTime)
      ..startTime = DateTime.parse(startTime)
      ..instructor = instructor.value
      ..location = location.value
      ..name = activity.value);

    props.actions.server.updateOrCreateActivity(update);
    props.actions.server.fetchAllActivities();

    setState((props, state) => state..edit = !state.edit);
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

///[_renderActivityNotFound] if the UID is bad this page will simply say the Activity was not found
_renderActivityNotFound() => new VDivElement()..text = 'not found!';
