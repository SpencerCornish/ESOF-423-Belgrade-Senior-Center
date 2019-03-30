import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../model/activity.dart';
import '../../middleware/serverMiddleware.dart';
import '../../state/app.dart';
import '../core/nav.dart';
import '../../model/user.dart';

class EditActivityProps {
  AppActions actions;
  User user;
  BuiltMap<String, Activity> activityMap;
  BuiltMap<String, User> userMap;
  String selectedActivityUID;
}

class EditActivityState {
  bool edit;
  String userToDelete;
  bool showDeletePrompt;
  bool showAddUserPrompt;
}

class EditActivity extends Component<EditActivityProps, EditActivityState> {
  EditActivity(props) : super(props);

  History _history;

  @override
  EditActivityState getInitialState() => EditActivityState()
    ..edit = false
    ..showAddUserPrompt = false
    ..showDeletePrompt = false
    ..userToDelete = '';

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillMount() {
    props.actions.server.fetchAllMembers();
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
          ..children = [
            _renderPromptForDeletion(act, state.userToDelete),
            _renderAddUser(act, state.userToDelete),
            _activityCreation(act),
          ]
      ];
  }

  //create the text boxes that are used to create new activities
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
                            ..text = "Edit Activity"
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
                                                ..value = _dateFormat(act.startTime)
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
                                                ..value = _timeFormat(
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
                                                ..value = _timeFormat(
                                                    act.endTime.hour.toString(), act.endTime.minute.toString())
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],
                  new VParagraphElement()
                    ..className = 'title'
                    ..text = "Attendees",
                  _renderAttendance(act),
                  //create the submit button
                  _renderButton(),
                ]
            ]
        ]
    ];

  VNode _renderAttendance(Activity act) {
    List<VNode> nodeList = new List<VNode>();

    nodeList.add(new VTableRowElement()
      ..className = 'tr'
      ..children = [
        new VTableCellElement()
          ..className = 'subtitle is-5'
          ..text = "First Name",
        new VTableCellElement()
          ..className = 'subtitle is-5'
          ..text = "Last Name",
        new VTableCellElement()
          ..className = 'td'
          ..text = "",
        new VTableCellElement()
          ..className = 'td'
          ..children = [
            new VButtonElement()
              ..className = "button is-success is-rounded"
              ..text = "Add"
              ..onClick = _addClick,
          ],
      ]);

    for (String userID in act.users) {
      User userObj = props.userMap[userID];
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = [
          new VTableCellElement()
            ..className = 'td'
            ..text = userObj?.firstName ?? '',
          new VTableCellElement()
            ..className = 'td'
            // ..id = 'name_cell${state.attNum}'
            ..text = userObj?.lastName ?? '',
          new VTableCellElement()
            ..children = [
              new VButtonElement()
                ..className = "button is-danger is-rounded"
                ..text = "Remove"
                ..onClick = _promptForDeleteClick,
            ]
        ]);
    }

    return new VTableElement()
      ..className = 'table is-narrow is-striped is-fullwidth'
      ..id = "attendance"
      ..children = nodeList;
  }

  VNode _renderPromptForDeletion(Activity act, String uid) => new VDivElement()
    ..className = "modal ${state.showDeletePrompt ? 'is-active' : ''}"
    ..children = [
      new VDivElement()..className = 'modal-background',
      new VDivElement()
        ..className = 'modal-card'
        ..children = [
          new Vsection()
            ..className = 'modal-card-body'
            ..children = [
              new VParagraphElement()..text = "Are you sure you want to remove this user?",
            ],
          new Vfooter()
            ..className = 'modal-card-foot'
            ..children = [
              new VButtonElement()
                ..className = 'button is-danger'
                ..text = "Yes"
                ..onClick = (_) => _removeClick(act, uid),
              new VButtonElement()
                ..className = 'button'
                ..text = "No"
                ..onClick = _cancelDeletionClick
            ],
        ],
    ];

  VNode _renderAddUser(Activity act, String uid) => new VDivElement()
    ..className = "modal ${state.showAddUserPrompt ? 'is-active' : ''}"
    ..children = [
      new VDivElement()..className = 'modal-background',
      new VDivElement()
        ..className = 'modal-card'
        ..children = [
          new Vsection()
            ..className = 'modal-card-body'
            ..children = _renderUserTable(act),
        ],
    ];

  List<VNode> _renderUserTable(Activity act) {
    List<VNode> items = new List<VNode>();

    items.add(new VTableRowElement()
      ..children = [
        new VTableCellElement()
          ..className = 'td'
          ..text = 'Name',
        new VTableCellElement()
          ..className = 'td'
          ..text = '',
      ]);

    for (User u in props.userMap.values) {
      items.add(
        new VTableRowElement()
          ..children = [
            new VTableCellElement()
              ..className = 'td'
              // ..id = 'name_cell${state.attNum}'
              ..text = "${u.firstName ?? ''} ${u.lastName ?? ''}",
            new VTableCellElement()
              ..className = 'td'
              ..children = [
                new VButtonElement()
                  ..className = "button is-danger is-rounded"
                  ..text = "Choose"
                  ..onClick = (_) => _addUserClick(act, u.docUID),
              ],
          ],
      );
    }

    return items;
  }

  _promptForDeleteClick(_) => setState((props, state) => state..showDeletePrompt = true);

  _cancelDeletionClick(_) => setState((props, state) => state..showDeletePrompt = false);

  _addClick(_) => setState((props, state) => state..showAddUserPrompt = true);

  _cancelAddClick(_) => setState((props, state) => state..showAddUserPrompt = false);

  _removeClick(Activity act, String userId) {
    props.actions.server.updateOrCreateActivity(act.rebuild((builder) => builder..users.remove(userId)));
    props.actions.server.fetchAllActivities();
    setState((props, state) => state..showDeletePrompt = false);
  }

  _addUserClick(Activity act, String userId) {
    props.actions.server.updateOrCreateActivity(act.rebuild((builder) => builder..users.add(userId)));
    props.actions.server.fetchAllActivities();
    setState((props, state) => state..showAddUserPrompt = false);
  }

  ///[_timeFormat] helper function to put a time into a proper format to view in a time type input box
  String _timeFormat(String hour, String min) {
    if (hour.length == 1) {
      hour = "0${hour}";
    }

    if (min.length == 1) {
      min = "0${min}";
    }
    return hour + ":" + min;
  }

  //TODO:  Replace with date_parse library in constants.dart
  ///[_dateFormat] helper function to put a date into a proper format to view in a date type input box
  String _dateFormat(DateTime date) {
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

  // TODO: Move to constants.dart
  ///[_parseDate] is a function adopted from the _dateFormat function that Josh wrote to make a string from a date and time input compatible with DateTime data types
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
