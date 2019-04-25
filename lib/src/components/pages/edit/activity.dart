import 'dart:html' hide History;

import 'package:bsc/src/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../model/activity.dart';
import '../../../state/app.dart';
import '../../core/nav.dart';
import '../../core/modal.dart';
import '../../core/pageRepeats.dart';
import '../../../model/user.dart';

///[EditActivityProps] class to hold passed in properties of edit activity page
class EditActivityProps {
  AppActions actions;
  User user;
  BuiltMap<String, Activity> activityMap;
  BuiltMap<String, User> userMap;
  String selectedActivityUID;
}

///[EditActivityState] class to hold state of edit activity page
class EditActivityState {
  bool edit;
  String userToDelete;
  bool showDeleteUserPrompt;
  bool showDeleteActivityPrompt;
  bool showAddUserPrompt;
  bool timeIsValid;
  bool activityNameIsValid;
  bool instructorNameIsValid;
  bool locationIsValid;
  bool capacityIsValid;
}

///[EditActivity] class to create the edit activity page
class EditActivity extends Component<EditActivityProps, EditActivityState> {
  EditActivity(props) : super(props);

  History _history;

  @override
  EditActivityState getInitialState() => EditActivityState()
    ..edit = false
    ..showAddUserPrompt = false
    ..showDeleteUserPrompt = false
    ..showDeleteActivityPrompt = false
    ..userToDelete = ''
    ..activityNameIsValid = true
    ..instructorNameIsValid = true
    ..locationIsValid = true
    ..capacityIsValid = true
    ..timeIsValid = true;

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
            _renderPromptForUserDeletion(act),
            _renderPromptForActivityDeletion(),
            _renderAddUser(act, state.userToDelete),
            _activityCreation(act),
          ]
      ];
  }

  /// [_activityCreation] create the text boxes that are used to create new activities
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
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      new VDivElement()
                        ..className = 'column is-narrow'
                        ..children = [
                          new Vh1()
                            ..className = 'title'
                            ..text = "Activity Edit"
                        ],
                      new VDivElement()..className = 'column',
                      new VDivElement()
                        ..className = 'column is-narrow'
                        ..children = [
                          renderEditSubmitButton(
                              edit: state.edit,
                              onEditClick: _editClick,
                              onSubmitClick: _submitClick,
                              onDeleteClick: _promptForRemoveActivityClick,
                              submitIsDisabled:
                                  Validator.canActivateSubmit(state.activityNameIsValid, state.timeIsValid)),
                        ],
                    ],
                  //create the input fields for activity name and instructor's name
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      _renderName(act),
                      _renderInstructor(act),
                    ],
                  //create the Location And Capacity Input fields
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      _renderLocation(act),
                      _renderCapacity(act),
                    ],
                  _renderDateField(act),
                  _renderTimeFields(act),
                  new VParagraphElement()
                    ..className = 'title'
                    ..text = "Attendees",
                  _renderAttendance(act),
                ]
            ]
        ]
    ];

  ///[_renderName] label and input for name
  _renderName(Activity act) => new VDivElement()
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
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.activityNameIsValid ? '' : 'is-danger'}'
                            ..id = 'act-input'
                            ..defaultValue = act.name
                            ..readOnly = !state.edit,
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.activityNameIsValid ? 'is-invisible' : ''}'
                            ..text = 'Activity name may not be empty'
                        ]
                    ]
                ]
            ]
        ]
    ];

  ///[_renderInstructor] label and input for instructor
  _renderInstructor(Activity act) => new VDivElement()
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
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.instructorNameIsValid ? '' : 'is-danger'}'
                            ..id = 'instructorName-input'
                            ..defaultValue = act.instructor
                            ..readOnly = !state.edit,
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.instructorNameIsValid ? 'is-invisible' : ''}'
                            ..text = 'Instructor name may not be blank'
                        ]
                    ]
                ]
            ]
        ]
    ];

  ///[_renderLocation] label and input for location
  _renderLocation(Activity act) => new VDivElement()
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
                            ..onInput = _locationValidator
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.locationIsValid ? '' : 'is-danger'}'
                            ..id = 'location-input'
                            ..defaultValue = act.location
                            ..readOnly = !state.edit,
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.locationIsValid ? 'is-invisible' : ''}'
                            ..text = 'Location may not be blank'
                        ]
                    ]
                ]
            ]
        ]
    ];

  ///[_renderCapacity] label and input for capacity
  _renderCapacity(Activity act) => new VDivElement()
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
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.capacityIsValid ? '' : 'is-danger'}'
                            ..id = 'capacity-input'
                            ..readOnly = !state.edit
                            ..defaultValue = _capView(act.capacity.toString()),
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.capacityIsValid ? 'is-invisible' : ''}'
                            ..text = 'Capacity must be -1, or more than 0'
                        ]
                    ]
                ]
            ]
        ]
    ];

  ///[_renderDateField] label and input for date
  _renderDateField(Activity act) => new VDivElement()
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
                                ..className =
                                    'input ${state.edit ? '' : 'is-static'} ${state.timeIsValid ? '' : 'is-danger'}'
                                ..id = 'day-input'
                                ..type = 'date'
                                ..value = formatDate(act.startTime, [yyyy, "-", mm, "-", dd])
                                ..readOnly = !state.edit,
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

  /// [_renderTimeFields] Create the start and end time input fields
  _renderTimeFields(Activity act) => new VDivElement()
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
                                ..className =
                                    'input ${state.edit ? '' : 'is-static'} ${state.timeIsValid ? '' : 'is-danger'}'
                                ..id = 'timeStart-input'
                                ..type = 'time'
                                ..readOnly = !state.edit
                                ..value = formatDate(act.startTime, [hh, ":", mm]),
                              new VParagraphElement()
                                ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
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
                                ..className =
                                    'input ${state.edit ? '' : 'is-static'} ${state.timeIsValid ? '' : 'is-danger'}'
                                ..id = 'timeEnd-input'
                                ..type = 'time'
                                ..readOnly = !state.edit
                                ..value = formatDate(act.endTime, [hh, ":", mm]),
                              new VParagraphElement()
                                ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                                ..text = 'Activity must start before it ends'
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ];

  ///[_renderAttendance] show member first and last names that are checked in for an activity
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
          ..children = [_renderAddButton()],
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
            ..text = userObj?.lastName ?? '',
          new VTableCellElement()
            ..className = 'td'
            ..text = "",
          new VTableCellElement()..children = [_renderRemoveButton(userID)]
        ]);
    }

    return new VTableElement()
      ..className = 'table is-narrow is-striped is-fullwidth'
      ..id = "attendance"
      ..children = nodeList;
  }

  ///[_renderAddButton] button to check in more users
  VNode _renderAddButton() {
    if (state.edit) {
      return new VButtonElement()
        ..className = "button is-rounded"
        ..onClick = _addClick
        ..children = [
          new VSpanElement()
            ..className = 'icon'
            ..children = [
              new Vi()..className = 'fas fa-user-plus',
            ],
          new VSpanElement()..text = 'Add',
        ];
    }
    return new VParagraphElement();
  }

  ///[_renderRemoveButton] button to take users out of an activity
  VNode _renderRemoveButton(String userID) {
    if (state.edit) {
      return new VButtonElement()
        ..className = "button is-small is-rounded"
        ..onClick = ((_) => _promptForRemoveUserClick(userID))
        ..children = [
          new VSpanElement()
            ..className = 'icon'
            ..children = [
              new Vi()..className = 'fas fa-minus-circle',
            ],
          new VSpanElement()..text = 'Remove'
        ];
    }
    return new VParagraphElement();
  }

  VNode _renderPromptForUserDeletion(Activity act) => new ConfirmModal(ConfirmModalProps()
    ..isOpen = state.showDeleteUserPrompt
    ..cancelButtonStyle = ""
    ..cancelButtonText = "Cancel"
    ..submitButtonStyle = "is-danger"
    ..submitButtonText = "Remove"
    ..message = "Are you sure you want to remove this user?"
    ..onCancel = _cancelRemoveUserClick
    ..onConfirm = () => _removeUserClick(act));

  VNode _renderPromptForActivityDeletion() => new ConfirmModal(ConfirmModalProps()
    ..isOpen = state.showDeleteActivityPrompt
    ..cancelButtonStyle = ""
    ..cancelButtonText = "Cancel"
    ..submitButtonStyle = "is-danger"
    ..submitButtonText = "Remove"
    ..message = "Are you sure you want to remove this activity? This cannot be undone."
    ..onCancel = _cancelRemoveActivityClick
    ..onConfirm = _removeActivityClick);

  ///[_rederAddUser] modal containing list of members able to be added to current activity
  VNode _renderAddUser(Activity act, String uid) => new VDivElement()
    ..className = "modal ${state.showAddUserPrompt ? 'is-active' : ''}"
    ..children = [
      new VDivElement()..className = 'modal-background',
      new VDivElement()
        ..className = 'modal-card'
        ..children = [
          new Vsection()
            ..className = 'modal-card-head'
            ..children = [
              new VParagraphElement()
                ..className = 'title is-4'
                ..text = 'Select a Person to Add'
            ],
          new Vsection()
            ..className = 'modal-card-body'
            ..children = [
              new VTableElement()
                ..className = 'table is-narrow is-striped is-fullwidth'
                ..children = _renderUserTable(act),
            ],
          new Vfooter()
            ..className = 'modal-card-foot'
            ..children = [
              new VButtonElement()
                ..className = 'button is-rounded'
                ..text = 'Cancel'
                ..onClick = _cancelAddClick
            ],
        ],
    ];

  ///[_renderUserTable] the actual table of users for the addUser modal
  List<VNode> _renderUserTable(Activity act) {
    List<VNode> items = new List<VNode>();

    items.add(new VTableRowElement()
      ..children = [
        new VTableCellElement()
          ..className = 'title is-5'
          ..text = 'Name',
        new VTableCellElement()
          ..className = 'td'
          ..text = '',
      ]);

    for (User u in props.userMap.values) {
      // skip users present in activity already to disallow repeate user additions
      if (act.users.contains(u.docUID)) {
        continue;
      }
      items.add(
        new VTableRowElement()
          ..children = [
            new VTableCellElement()
              ..className = 'td'
              ..text = "${u.firstName ?? ''} ${u.lastName ?? ''}",
            new VTableCellElement()
              ..className = 'td'
              ..children = [
                new VButtonElement()
                  ..className = "button is-info is-rounded"
                  ..text = "Choose"
                  ..onClick = (_) => _addUserClick(act, u.docUID),
              ],
          ],
      );
    }

    return items;
  }

  _promptForRemoveUserClick(String userID) => setState((props, state) => state
    ..showDeleteUserPrompt = true
    ..userToDelete = userID);

  _cancelRemoveUserClick() => setState((props, state) => state..showDeleteUserPrompt = false);

  _promptForRemoveActivityClick() => setState((props, state) => state..showDeleteActivityPrompt = true);

  _cancelRemoveActivityClick() => setState((props, state) => state..showDeleteActivityPrompt = false);

  ///[_capView] converts capacity from the stored number (or lack there of) to a pretty output
  String _capView(String text) {
    if (text != '') {
      if (text == '-1') {
        text = "Unlimited";
      }
    } else {
      text = "N/A";
    }
    return text;
  }

  ///[_capReset] converts capacity from the visual look to a  number for storage
  int _capReset(String cap) {
    if (cap != '') {
      if (cap == 'Unlimited') {
        return -1;
      }
      return int.parse(cap);
    } else {
      return int.parse(cap);
    }
  }

  /// [_activityNameValidator] validator function to ensure name is input correctly
  void _activityNameValidator(_) {
    InputElement actName = querySelector('#act-input');
    bool isValid = Validator.name(actName.value);
    setState((EditActivityProps, EditActivityState) => EditActivityState..activityNameIsValid = isValid);
  }

  /// [_instructorNameValidator] validator function to ensure instructor is input correctly
  void _instructorNameValidator(_) {
    InputElement instructorName = querySelector('#instructorName-input');
    bool isValid = Validator.name(instructorName.value);
    setState((EditActivityProps, EditActivityState) => EditActivityState..instructorNameIsValid = isValid);
  }

  /// [_locationValidator] validator function to ensure location is input correctly
  void _locationValidator(_) {
    InputElement location = querySelector('#location-input');
    bool isValid = Validator.name(location.value);
    setState((EditActivityProps, EditActivityState) => EditActivityState..locationIsValid = isValid);
  }

  /// [_capacityValidator] validator function to ensure capacity is input correctly
  void _capacityValidator(_) {
    InputElement capacity = querySelector('#capacity-input');
    bool isValid = Validator.capacity(int.parse(capacity.value));
    setState((EditActivityProps, EditActivityState) => EditActivityState..capacityIsValid = isValid);
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

      setState((EditActivityProps, EditActivityState) => EditActivityState..timeIsValid = isValid);
    } catch (_) {
      setState((EditActivityProps, EditActivityState) => EditActivityState..timeIsValid = false);
    }
  }

  ///[_addClick] sets the state to show the addUser modal
  _addClick(_) => setState((props, state) => state..showAddUserPrompt = true);

  ///[_cancelAddClick]sets the state to hide the addUser modal with no action
  _cancelAddClick(_) => setState((props, state) => state..showAddUserPrompt = false);

  _removeUserClick(Activity act) {
    props.actions.server.updateOrCreateActivity(act.rebuild((builder) => builder..users.remove(state.userToDelete)));
    props.actions.server.fetchAllActivities();
    setState((props, state) => state
      ..showDeleteUserPrompt = false
      ..userToDelete = '');
  }

  _removeActivityClick() {
    print("REMOVE THE ACTIVITY");
  }

  ///[_addUserClick] actually adds a user to this activity and hides the modal
  _addUserClick(Activity act, String userId) {
    props.actions.server.updateOrCreateActivity(act.rebuild((builder) => builder..users.add(userId)));
    props.actions.server.fetchAllActivities();
    setState((props, state) => state..showAddUserPrompt = false);
  }

  ///[_editClick] listener for the click action of the edit button to put page into an edit state
  _editClick() {
    setState((props, state) => state..edit = !state.edit);
  }

  //method used for the submit click
  //timeEnd-input, timeStart-input, capacity-input, location-input, instructorName-input, act-input
  _submitClick() {
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
    startTime = formatDate(date, [yyyy, "-", mm, "-", dd, " ${tempStart}:00.000"]);
    endTime = formatDate(date, [yyyy, "-", mm, "-", dd, " ${tempEnd}:00.000"]);
    cap = _capReset(capacity.value);

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
}

///[_renderActivityNotFound] if the UID is bad this page will simply say the Activity was not found
_renderActivityNotFound() => new VDivElement()..text = 'not found!';
