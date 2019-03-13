import 'dart:html' hide History;

import 'package:bsc/src/constants.dart';
import 'package:bsc/src/model/emergencyContact.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../core/nav.dart';

import '../../model/user.dart';

import '../../state/app.dart';

class EditMemberProps {
  AppActions actions;
  User user;
  BuiltMap<String, User> userMap;
  String selectedMemberUID;
}

class EditMemberState {
  bool edit;
  bool dropDownActive;
  int listsCreated;
  // int addEm;
}

/// [EditMember] class / page to allow user information to be changed for a given user by uid
class EditMember extends Component<EditMemberProps, EditMemberState> {
  EditMember(props) : super(props);

  @override
  EditMemberState getInitialState() => EditMemberState()
    ..edit = false
    ..dropDownActive = false
    ..listsCreated = 0;
  // ..addEm = 0;

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillUpdate(EditMemberProps nextProps, EditMemberState nextState) {
    super.componentWillUpdate(nextProps, nextState);
  }

  @override
  VNode render() {
    User user = props.userMap[props.selectedMemberUID];
    if (user == null) return _renderUserNotFound();
    return new VDivElement()
      ..children = [
        new Nav(new NavProps()
          ..actions = props.actions
          ..user = props.user),
        new VDivElement()
          ..className = 'container'
          ..children = [
            new VDivElement()
              ..className = 'columns is-mobile margin-top is-centered'
              ..children = [
                new VDivElement()
                  ..className = 'column is-four-fifths'
                  ..children = [
                    new VDivElement()
                      ..className = 'box is-4'
                      ..children = _pageElements(user),
                  ],
              ],
          ],
      ];
  }

  ///[_pageElements] helper function to add all fields to the render method
  List<VNode> _pageElements(User user) {
    List<VNode> nodeList = <VNode>[];
    state.edit ? nodeList.addAll(_renderEditHeader(user)) : nodeList.addAll(_renderHeader(user));
    nodeList.addAll(_renderMembership(user));
    nodeList.add(_renderAddress(user));
    nodeList.add(_renderNumber(user));
    nodeList.addAll(_renderListRows(user.emergencyContacts, "Emergency Contact"));
    // nodeList.addAll(_renderListRows(user.dietaryRestrictions, "Dietary Restriction"));
    // nodeList.addAll(_renderListRows(user.disabilities, "Disability"));
    // nodeList.addAll(_renderListRows(user.medicalIssues, "Medical Issue"));
    return nodeList;
  }

  //possible list implementation which was acomplished above and simply needs to work for type desired
  //dietary restrictions
  //disabilities
  //medical issues

  ///[_renderEditHeader] function to change the name into an editable field group by state change
  List<VNode> _renderEditHeader(User user) {
    List<VNode> nodeList = <VNode>[];
    nodeList.add(new VDivElement()
      ..className = 'columns'
      ..children = [new VDivElement()..className = 'column is-narrow']);
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile'
      ..children = [
        new VDivElement()
          ..className = 'column is-narrow is-offset-1'
          ..children = [
            new VSpanElement()
              ..className = 'icon is-large'
              ..children = [new Vi()..className = 'fas fa-5x fa-user'],
          ],
        new VDivElement()
          ..className = 'column is-one-fifth'
          ..children = [
            new VLabelElement()
              ..className = "label"
              ..text = "First Name: ",
            new VDivElement()..className = 'column',
            new VLabelElement()
              ..className = "label"
              ..text = "Last Name: ",
            new VDivElement()..className = 'column',
            new VLabelElement()
              ..className = "label"
              ..text = "Preferred Name: ",
            new VDivElement()..className = 'column',
          ],
        new VDivElement()
          ..className = 'column is-5'
          ..children = [
            new VDivElement()
              ..className = "control"
              ..children = [
                new VInputElement()
                  ..className = "input"
                  ..id = "First_Name"
                  ..defaultValue = _checkText(user.firstName),
                new VDivElement()..className = 'column',
                new VInputElement()
                  ..className = "input"
                  ..id = "Last_Name"
                  ..defaultValue = _checkText(user.lastName),
                new VDivElement()..className = 'column',
                new VInputElement()
                  ..className = "input"
                  ..id = "Preferred_Name"
                  ..defaultValue = _checkText(user.firstName),
                new VDivElement()..className = 'column',
              ],
          ],
        new VDivElement()
          ..className = 'column is-2'
          ..children = [
            state.edit ? _renderSubmit() : _renderEdit(),
          ],
      ]);
    return nodeList;
  }

  ///[_renderHeader] makes the title bar of the editMember page
  List<VNode> _renderHeader(User user) {
    List<VNode> nodeList = <VNode>[];
    nodeList.add(new VDivElement()
      ..className = 'columns'
      ..children = [new VDivElement()..className = 'column is-narrow']);
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile'
      ..children = [
        new VDivElement()
          ..className = 'column is-narrow is-offset-1'
          ..children = [
            new VSpanElement()
              ..className = 'icon is-large'
              ..children = [new Vi()..className = 'fas fa-5x fa-user'],
          ],
        new VDivElement()
          ..className = 'column is-narrow'
          ..children = [
            new Vh4()
              ..className = 'title is-4'
              ..text = user.firstName + " " + user.lastName,
            new Vh5()
              ..className = 'subtitle is-5'
              ..text = "Preferred Name: " + user.firstName,
          ],
        new VDivElement()..className = 'column',
        new VDivElement()
          ..className = 'column is-2'
          ..children = [
            state.edit ? _renderSubmit() : _renderEdit(),
          ],
      ]);
    return nodeList;
  }

  ///[_renderAddress] row for address label and input
  _renderAddress(User user) => new VDivElement()
    ..className = 'columns is-mobile is-vcentered'
    ..children = [
      new VDivElement()
        ..className = 'column is-narrow'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Address",
        ],
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..id = "Address"
                ..defaultValue = _checkText(user.address)
                ..readOnly = !state.edit,
            ],
        ],
    ];

  ///[_renderNumber] row for numbers and email
  _renderNumber(User user) => new VDivElement()
    ..className = 'columns is-mobile is-centered is-vcentered'
    ..children = [
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Home Phone",
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..id = "PhoneNumber"
                ..defaultValue = _checkText(user.phoneNumber)
                ..readOnly = !state.edit,
            ],
        ],
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Cell or Messsage Phone",
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..id = "Mobile"
                ..defaultValue = _checkText(user.mobileNumber)
                ..readOnly = !state.edit,
            ],
        ],
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Email Address",
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..id = "Email"
                ..defaultValue = _checkText(user.email)
                ..readOnly = !state.edit,
            ],
        ],
    ];

  ///[_renderListRows] function for the list type items
  ///will show at least one or as many as member has
  List<VNode> _renderListRows(BuiltList<dynamic> list, String type) {
    List<VNode> nodeList = <VNode>[];

    if (list.isNotEmpty) {
      nodeList.add(
        new VDivElement()
          ..className = 'box'
          ..children = [
            new VDivElement()
              ..className = 'columns is-mobile is-centered is-vcentered'
              ..children = [
                new VDivElement()
                  ..className = 'column is-narrow'
                  ..children = [
                    new VLabelElement()
                      ..className = "label"
                      ..text =
                          "${list.length > 1 ? ((type.compareTo("Disability") == 0) ? 'Disabilities' : '$type' + 's') : '$type'}:",
                  ],
                new VDivElement()
                  ..className = 'column'
                  ..children = _renderListRowsHelper(list, type),
                // new VDivElement()
                //   ..className = 'column'
                //   ..children = _addEmergencyContactHelper(user),
                // new VDivElement()
                //   ..className = 'column'
                //   ..children = [_renderAddEmergencyContact()],
              ],
          ],
      );
    } else {
      nodeList.add(new VDivElement()
        ..className = 'box'
        ..children = [
          new VDivElement()
            ..className = 'columns is-mobile is-centered is-vcentered'
            ..children = [
              new VDivElement()
                ..className = 'column is-narrow'
                ..children = [
                  new VLabelElement()
                    ..className = "label"
                    ..text = type,
                ],
              new VDivElement()
                ..className = 'column'
                ..children = [
                  new VDivElement()
                    ..className = "field"
                    ..children = [
                      new VDivElement()
                        ..className = "control"
                        ..children = [
                          new VInputElement()
                            ..className = "input ${state.edit ? '' : 'is-static'}"
                            ..defaultValue = _checkText("")
                            ..readOnly = !state.edit,
                          // _renderAddEmergencyContact(),
                        ],
                    ],
                ],
            ],
        ]);
    }
    return nodeList;
  }

  ///[_renderListRowsHelper] helper function to create the input boxes for list type
  List<VNode> _renderListRowsHelper(BuiltList<dynamic> list, String type) {
    List<VNode> nodeList = <VNode>[];

    for (Object item in list) {
      nodeList.add(new VDivElement()
        ..className = "control"
        ..children = [
          new VInputElement()
            ..className = "input ${state.edit ? '' : 'is-static'}"
            ..id = type
            ..defaultValue = _checkText(item.toString())
            ..readOnly = !state.edit,
        ]);
    }
    return nodeList;
  }

  List<VNode> _renderMembership(User user) {
    List<VNode> nodeList = <VNode>[];
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile is-centered is-vcentered'
      ..children = [
        new VDivElement()
          ..className = 'column is-narrow'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Membership Start",
          ],
        new VDivElement()
          ..className = 'column'
          ..children = [
            new VDivElement()
              ..className = "control"
              ..children = [
                new VInputElement()
                  ..className = "input ${state.edit ? '' : 'is-static'}"
                  ..id = "Start"
                  ..defaultValue = _checkText(
                      "${user.membershipStart.month}/${user.membershipStart.day}/${user.membershipStart.year}")
                  ..readOnly = !state.edit,
              ],
          ],
        new VDivElement()
          ..className = 'column is-narrow'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Renewal",
          ],
        new VDivElement()
          ..className = 'column'
          ..children = [
            new VDivElement()
              ..className = "control"
              ..children = [
                new VInputElement()
                  ..className = "input ${state.edit ? '' : 'is-static'}"
                  ..id = "Renewal"
                  ..defaultValue = _checkText(
                      "${user.membershipRenewal.month}/${user.membershipRenewal.day}/${user.membershipRenewal.year}")
                  ..readOnly = !state.edit,
              ],
          ],
        new VDivElement()
          ..className = 'column is-narrow'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Role",
          ],
        new VDivElement()
          ..className = 'column'
          ..children = [
            _roleHelper(user),
          ],
      ]);
    return nodeList;
  }

  //************************************throws many errors TODO: fix this
  /**
   * Expected a value of type 'Element', but got one of type 'Text' dart:sdk_internal 4025:19                                           as_C
   * ... SOME MORE STUFF IN HERE
   * package:wui_builder/src/wui_builder/component/component.dart 71:5   update
   * package:wui_builder/src/wui_builder/component/component.dart 151:5  setState
   * package:bsc/src/components/containers/editMember.dart 490:5         [_dropDownClick]
   * package:wui_builder/src/wui_builder/velement/velement.dart 3937:62  e
   * dart:sdk_internal 27983:34                                          arg
   */

  VNode _roleHelper(User user) {
    if (state.edit) {
      return (new VDivElement()
        ..className = 'dropdown ${state.dropDownActive ? 'is-active' : ''}'
        ..children = [
          new VDivElement()
            ..className = 'dropdown-trigger'
            ..onClick = _dropDownClick
            ..children = [
              new VAnchorElement()
                ..className = 'button is-dropdown-menu is-centered'
                ..children = [
                  new VSpanElement()
                    ..text = user.role
                    ..children = [
                      new VSpanElement()
                        ..className = 'icon'
                        ..children = [new Vi()..className = "fas fa-angle-down"]
                    ],
                  new VDivElement()
                    ..className = 'dropdown-menu'
                    ..id = 'dropdown-menu'
                    ..children = [
                      new VDivElement()
                        ..className = 'dropdown-content'
                        ..children = [
                          new VDivElement()
                            ..className = 'dropdown-item'
                            ..text = "Member",
                          new VDivElement()
                            ..className = 'dropdown-item'
                            ..text = "Volunteer",
                          new VDivElement()
                            ..className = 'dropdown-item'
                            ..text = "Admin",
                        ],
                    ],
                ],
            ],
        ]);
    } else {
      return (new VDivElement()
        ..className = 'column'
        ..children = [
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..id = "Role"
                ..defaultValue = _checkText(user.role)
                ..readOnly = !state.edit,
            ],
        ]);
    }
  }

  ///[_checkText] takes in passed text and will return N/A if string is empty and the user is not being eddited
  ///or return the orrigional string for all other conditions
  String _checkText(String text) => state.edit ? text : (text != '' ? text : "N/A");

  // ///[_renderAddEmergencyContact] creates a button to add an input field for aditional emergency contacts if in edit state
  // VNode _renderAddEmergencyContact() {
  //   if (state.edit) {
  //     return (new VParagraphElement()
  //       ..className = 'control'
  //       ..children = [
  //         new VAnchorElement()
  //           ..className = 'button is-link'
  //           ..text = "Add"
  //           ..onClick = _renderAddEmergencyContactClick
  //       ]);
  //   } else {
  //     return new VDivElement()..className = 'control';
  //   }
  // }

  // ///[_renderAddEmergencyContactClick] listener for the click action of the addEmergencyContact button to put page into an edit state
  // _renderAddEmergencyContactClick(_) {
  //   print(state.addEm);
  //   setState((props, state) => state..addEm = (state.addEm + 1));
  // }

  _dropDownClick(_) {
    setState((props, state) => state..dropDownActive = !state.dropDownActive);
  }

  ///[_renderEdit] creates a button to toggle from a view page to increase the number of input fields
  _renderEdit() => new VDivElement()
    ..className = 'control'
    ..children = [
      new VAnchorElement()
        ..className = 'button is-link'
        ..text = "Edit"
        ..onClick = _editClick
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
            ..onClick = _editClick
        ]
    ];

  ///[_submitClick] listener to grab all available data on page and push to firebase
  _submitClick(_) {
    InputElement first = querySelector('#Fisrt_Name');
    InputElement last = querySelector('#Last_Name');
    InputElement email = querySelector('#Email');
    InputElement cell = querySelector('#Mobile');
    InputElement phone = querySelector('#PhoneNumber');
    InputElement address = querySelector('#Address');
    // InputElement diet = querySelector('#diet-input');
    // InputElement disability = querySelector('#disabilities-input');
    // InputElement medical = querySelector('#medicalIssue-input');
    InputElement memStart = querySelector('#Start');
    InputElement memRenew = querySelector('#Renewal');

    // TODO: edit the user object
    User newUser = (new UserBuilder()
          ..firstName = first.value
          ..lastName = last.value
          ..email = email.value
          ..mobileNumber = cell.value
          ..phoneNumber = phone.value
          ..address = address.value
          ..dietaryRestrictions = "NULL"
          ..disabilities = "NULL"
          ..medicalIssues = "NULL"
          ..membershipStart = DateTime.parse(memStart.value)
          ..membershipRenewal = DateTime.parse(memRenew.value)
          ..emergencyContacts = new ListBuilder<EmergencyContact>()
          ..services = new ListBuilder<String>()
          ..role = "NULL"
          ..position = "NULL"
          ..forms = new ListBuilder<String>())
        .build();

    props.actions.server.updateOrCreateUser(newUser);
    props.actions.server.fetchAllMembers();
  }

  ///[_renderUserNotFound] if the UID is bad this page will simply say the user was not found
  _renderUserNotFound() => new VDivElement()..text = 'not found!';
}
