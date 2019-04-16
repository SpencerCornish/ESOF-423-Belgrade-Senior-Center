import 'dart:html' hide History;

import 'package:built_collection/built_collection.dart';
import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../../model/activity.dart';
import '../../../constants.dart';
import '../../../state/app.dart';
import '../../core/nav.dart';
import '../../../model/user.dart';

/// [NewActivityProps] class for the new activity page passed in propeerties
class NewActivityProps {
  AppActions actions;
  User user;
}

/// [NewActivityState] state class for the new activity page
class NewActivityState {
  bool activityNameIsValid;
  bool instructorNameIsValid;
  bool locationIsValid;
  bool capacityIsValid;
  bool timeIsValid;
  bool isUnlimited;
}

/// [NewActivity] class to create the new activity page for creating an activity
class NewActivity extends Component<NewActivityProps, NewActivityState> {
  NewActivity(props) : super(props);

  @override
  NewActivityState getInitialState() => NewActivityState()
    ..activityNameIsValid = false
    ..instructorNameIsValid = true
    ..locationIsValid = true
    ..capacityIsValid = true
    ..timeIsValid = false
    ..isUnlimited = false;

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
                      _renderName(),
                      _renderInstructor(),
                    ],
                  //create the Location And Capacity Input fields
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      _renderLocation(),
                      _renderCapacity(),
                    ],
                  _renderDate(),
                  //create the Start and End Time Input field
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      _renderStart(),
                      _renderEnd(),
                    ],
                  _renderSubmit(),
                ]
            ]
        ]
    ];

  /// [_renderName] create the label and input for Name
  _renderName() => new VDivElement()
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
                            ..className = 'help is-danger ${state.activityNameIsValid ? 'is-invisible' : ''}'
                            ..text = 'Activity name may not be empty'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderInstructor] create the label and input for Instructor
  _renderInstructor() => new VDivElement()
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
                            ..className = 'help is-danger ${state.instructorNameIsValid ? 'is-invisible' : ''}'
                            ..text = 'Instructor name may not be blank'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderLocation] create the label and input for location
  _renderLocation() => new VDivElement()
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
                            ..placeholder = "Where is the activity?",
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.locationIsValid ? 'is-invisible' : ''}'
                            ..text = 'Location may not be blank'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderCapacity] create the label and input for capacity
  _renderCapacity() => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'columns is-mobile'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
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
                                    ..disabled = state.isUnlimited
                                    ..type = 'number',
                                  new VParagraphElement()
                                    ..className = 'help is-danger ${state.capacityIsValid ? 'is-invisible' : ''}'
                                    ..text = 'Capacity must be -1, or more than 0'
                                ]
                            ]
                        ]
                    ]
                ],
            ],
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "Unlimited"
            ],
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VDivElement()
                ..className = 'control'
                ..children = [
                  new VCheckboxInputElement()
                    ..className = 'checkbox'
                    ..id = 'isUnlimited-input'
                    ..onClick = _unlimitedBoxCheck
                ]
            ],
        ],
    ];

  /// [_renderDate] create the label and input for date
  _renderDate() => new VDivElement()
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
                                ..onInput = _timeValidator
                                ..className = 'input ${state.timeIsValid ? '' : 'is-danger'}'
                                ..id = 'day-input'
                                ..type = 'date',
                              new VParagraphElement()
                                ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                                ..text = 'Activity must include date'
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderStart] create the label and input for start time
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
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Activity must start before it ends'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderEnd] create the label and input for end time
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
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Activity must start before it ends'
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderSubmit] create the submit button
  _renderSubmit() => new VDivElement()
    ..className = 'field is-grouped is-grouped-right'
    ..children = [
      new VDivElement()
        ..className = 'control'
        ..children = [
          new VButtonElement()
            ..className = 'button is-link is-rounded'
            ..text = "Submit"
            ..disabled = _canActivateSubmit()
            ..onClick = _submitClick
        ]
    ];

  /// [_canActivateSubmit] validator function to ensure needed fields are correct before submit
  bool _canActivateSubmit() {
    if (state.activityNameIsValid && state.timeIsValid) {
      return false; //enables button on false
    }
    return true; //disables button on true
  }

  /// [_activityNameValidator] validator function to ensure name is input correctly
  void _activityNameValidator(_) {
    InputElement actName = querySelector('#act-input');
    bool isValid = Validator.name(actName.value);
    setState((NewActivityProps, NewActivityState) => NewActivityState..activityNameIsValid = isValid);
  }

  /// [_instructorNameValidator] validator function to ensure instructor is input correctly
  void _instructorNameValidator(_) {
    InputElement instructorName = querySelector('#instructorName-input');
    bool isValid = Validator.name(instructorName.value);
    setState((NewActivityProps, NewActivityState) => NewActivityState..instructorNameIsValid = isValid);
  }

  /// [_locationValidator] validator function to ensure location is input correctly
  void _locationValidator(_) {
    InputElement location = querySelector('#location-input');
    bool isValid = Validator.name(location.value);
    setState((NewActivityProps, NewActivityState) => NewActivityState..locationIsValid = isValid);
  }

  /// [_capacityValidator] validator function to ensure capacity is input correctly
  void _capacityValidator(_) {
    InputElement capacity = querySelector('#capacity-input');
    bool isValid = Validator.capacity(int.parse(capacity.value));
    setState((NewActivityProps, NewActivityState) => NewActivityState..capacityIsValid = isValid);
  }

  /// [_unlimitedBoxCheck] state function for the checkbox
  _unlimitedBoxCheck(_) {
    setState((props, state) => state..isUnlimited = !state.isUnlimited);
  }

  /// [_timeValidator] validator function to ensure time is input correctly
  void _timeValidator(_) {
    InputElement start = querySelector('#timeStart-input');
    InputElement end = querySelector('#timeEnd-input');
    InputElement day = querySelector('#day-input');
    try {
      DateTime serveDay = DateTime.parse(day.value);

      String startTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${start.value}:00.000"]);
      String endTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${end.value}:00.000"]);

      DateTime startDT = DateTime.parse(startTime);
      DateTime endDT = DateTime.parse(endTime);

      bool isValid = Validator.time(startDT, endDT);

      setState((NewActivityProps, NewActivityState) => NewActivityState..timeIsValid = isValid);
    } catch (_) {
      setState((NewActivityProps, NewActivityState) => NewActivityState..timeIsValid = false);
    }
  }

  /// [_submitClick] method used for the submit click
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
    int activityCapacity; //capacity of activity
    startTime = formatDate(date, [yyyy, "-", mm, "-", dd, " ${tempStart}:00.000"]);
    endTime = formatDate(date, [yyyy, "-", mm, "-", dd, " ${tempEnd}:00.000"]);

    if (state.isUnlimited) {
      activityCapacity = -1;
    } else {
      if (!capacity.value.isEmpty) {
        activityCapacity = int.parse(capacity.value);
      } else {
        activityCapacity = -1;
      }
    }

    Activity newActivity = (new ActivityBuilder()
          ..capacity = activityCapacity
          ..endTime = DateTime.parse(endTime)
          ..startTime = DateTime.parse(startTime)
          ..instructor = instructor.value
          ..location = location.value
          ..name = activity.value
          ..users = new ListBuilder<String>())
        .build();

    props.actions.server.updateOrCreateActivity(newActivity);

    history.push(Routes.viewActivity);
  }
}
