import 'dart:html' hide History;

import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../model/activity.dart';
import '../../../state/app.dart';
import '../../core/nav.dart';
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
  bool showDeletePrompt;
  bool showAddUserPrompt;
}

///[EditActivity] class to create the edit activity page
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
            _renderPromptForDeletion(act),
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
                  //create the Title of Box
                  new VDivElement()
                    ..className = 'field is-grouped is-grouped-left'
                    ..children = [
                      new VDivElement()
                        ..className = 'cloumn has-text-centered'
                        ..children = [
                          new Vh1()
                            ..className = 'title'
                            ..text = "Activity Edit"
                        ]
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
                  //create the submit button
                  renderEditSubmitButton(state.edit, _editClick, _submitClick),
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
                            ..className = 'input ${state.edit ? '' : 'is-static'}'
                            ..id = 'act-input'
                            ..defaultValue = act.name
                            ..readOnly = !state.edit
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
                            ..className = 'input ${state.edit ? '' : 'is-static'}'
                            ..id = 'instructorName-input'
                            ..defaultValue = act.instructor
                            ..readOnly = !state.edit
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
                            ..className = 'input ${state.edit ? '' : 'is-static'}'
                            ..id = 'location-input'
                            ..defaultValue = act.location
                            ..readOnly = !state.edit
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
                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                ..id = 'day-input'
                                ..type = 'date'
                                ..value = formatDate(act.startTime, [yyyy, "-", mm, "-", dd])
                                ..readOnly = !state.edit
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
                                ..className = 'input ${state.edit ? '' : 'is-static'}'
                                ..id = 'timeStart-input'
                                ..type = 'time'
                                ..readOnly = !state.edit
                                ..value = formatDate(act.startTime, [hh, ":", mm])
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
                                ..value = formatDate(act.endTime, [hh, ":", mm])
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
        ..onClick = ((_) => _promptForDeleteClick(userID))
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

  ///[_renderPromptForDeletion] modal that double checks the member is the inteded member for removal
  VNode _renderPromptForDeletion(Activity act) => new VDivElement()
    ..className = "modal ${state.showDeletePrompt ? 'is-active' : ''}"
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
                ..text = 'Remove User from Activity?'
            ],
          new Vsection()
            ..className = 'modal-card-body'
            ..children = [
              new VParagraphElement()..text = "Are you sure you want to remove this user?",
            ],
          new Vfooter()
            ..className = 'modal-card-foot'
            ..children = [
              new VButtonElement()
                ..className = 'button is-danger is-rounded'
                ..text = "Yes"
                ..onClick = (_) => _removeClick(act),
              new VButtonElement()
                ..className = 'button is-rounded'
                ..text = "No"
                ..onClick = _cancelDeletionClick
            ],
        ],
    ];

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

  ///[_promptForDeleteClick] sets the state to show the deletion modal for a user
  _promptForDeleteClick(String userID) => setState((props, state) => state
    ..showDeletePrompt = true
    ..userToDelete = userID);

  ///[_cancelDeletionClick] sets the state to hide the deletion modal with no action
  _cancelDeletionClick(_) => setState((props, state) => state..showDeletePrompt = false);

  ///[_addClick] sets the state to show the addUser modal
  _addClick(_) => setState((props, state) => state..showAddUserPrompt = true);

  ///[_cancelAddClick]sets the state to hide the addUser modal with no action
  _cancelAddClick(_) => setState((props, state) => state..showAddUserPrompt = false);

  ///[_removeClick] actually removes a user from this activity and hides the modal
  _removeClick(Activity act) {
    props.actions.server.updateOrCreateActivity(act.rebuild((builder) => builder..users.remove(state.userToDelete)));
    props.actions.server.fetchAllActivities();
    setState((props, state) => state
      ..showDeletePrompt = false
      ..userToDelete = '');
  }

  ///[_addUserClick] actually adds a user to this activity and hides the modal
  _addUserClick(Activity act, String userId) {
    props.actions.server.updateOrCreateActivity(act.rebuild((builder) => builder..users.add(userId)));
    props.actions.server.fetchAllActivities();
    setState((props, state) => state..showAddUserPrompt = false);
  }

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
    startTime = formatDate(date, [yyyy, "-", mm, "-", dd, " ${tempStart}:00.000"]);
    endTime = formatDate(date, [yyyy, "-", mm, "-", dd, " ${tempEnd}:00.000"]);
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
}

///[_renderActivityNotFound] if the UID is bad this page will simply say the Activity was not found
_renderActivityNotFound() => new VDivElement()..text = 'not found!';
