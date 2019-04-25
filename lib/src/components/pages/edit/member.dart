import 'dart:html' hide History;

import 'package:bsc/src/model/emergencyContact.dart';
import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../constants.dart';
import '../../core/nav.dart';
import '../../core/pageRepeats.dart';
import '../../../model/user.dart';
import '../../../state/app.dart';

/// [EditMemberProps] class for the edit member page passed in propeerties
class EditMemberProps {
  AppActions actions;
  User user;
  BuiltMap<String, User> userMap;
  String selectedMemberUID;
}

/// [EditMemberState] state class for the edit member page
class EditMemberState {
  bool firstNameIsValid;
  bool lastNameIsValid;
  bool emailIsValid;
  bool phoneNumberIsValid;
  bool cellNumberIsValid;
  bool addressIsValid;
  bool hasInvalid;
  bool memIsValid;

  bool edit;
  bool dropDownActive;
  int listsCreated;
  String role;
  bool mealBool;
  bool medBool;
  bool waiverBool;
  bool intakeBool;
}

/// [EditMember] class / page to allow user information to be changed for a given user by uid
class EditMember extends Component<EditMemberProps, EditMemberState> {
  EditMember(props) : super(props);

  @override
  EditMemberState getInitialState() => EditMemberState()
    ..firstNameIsValid = true
    ..lastNameIsValid = true
    ..emailIsValid = true
    ..phoneNumberIsValid = true
    ..cellNumberIsValid = true
    ..addressIsValid = true
    ..hasInvalid = true
    ..memIsValid = true
    ..edit = false
    ..dropDownActive = false
    ..listsCreated = 0
    ..role = props.userMap[props.selectedMemberUID].role
    ..mealBool = props.userMap[props.selectedMemberUID].homeDeliver
    ..medBool = props.userMap[props.selectedMemberUID].medRelease
    ..waiverBool = props.userMap[props.selectedMemberUID].waiverRelease
    ..intakeBool = props.userMap[props.selectedMemberUID].intakeForm;

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
    nodeList.add(_renderTextArea(user, "Dietary Restrictions", user.dietaryRestrictions));
    nodeList.add(_renderTextArea(user, "Disabilities", user.disabilities));
    nodeList.add(_renderTextArea(user, "Medical Issues", user.medicalIssues));
    nodeList.addAll(_renderListRows(user.emergencyContacts, "Emergency Contact"));
    nodeList.addAll(_renderListRows(user.services, "Available Service"));
    nodeList.add(_renderCheckboxes());
    return nodeList;
  }

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
          ..className = 'column is-narrow is-offset-1 is-1'
          ..children = [
            new VSpanElement()
              ..className = 'icon is-large'
              ..children = [new Vi()..className = 'fas fa-5x fa-user'],
          ],
        new VDivElement()
          ..className = 'column is-4'
          ..children = [
            new VLabelElement()
              ..className = "label"
              ..text = "First Name",
            new VInputElement()
              ..onInput = _firstNameValidation
              ..className = "input ${state.lastNameIsValid ? '' : 'is-danger'}"
              ..id = "First_Name"
              ..tabIndex = 1
              ..defaultValue = checkText(user.firstName),
            new VParagraphElement()
              ..className = 'help is-danger ${state.firstNameIsValid ? 'is-invisible' : ''}'
              ..text = 'First name is required',
            new VLabelElement()
              ..className = 'label'
              ..text = "Position",
            new VInputElement()
              ..className = "input"
              ..id = "Position"
              ..tabIndex = 4
              ..defaultValue = checkText(user.position)
          ],
        new VDivElement()
          ..className = 'column is-4'
          ..children = [
            new VLabelElement()
              ..className = "label"
              ..text = "Last Name",
            new VInputElement()
              ..onInput = _lastNameValidation
              ..className = "input ${state.lastNameIsValid ? '' : 'is-danger'}"
              ..id = "Last_Name"
              ..tabIndex = 2
              ..defaultValue = checkText(user.lastName),
            new VParagraphElement()
              ..className = 'help is-danger ${state.lastNameIsValid ? 'is-invisible' : ''}'
              ..text = 'Last name is required',
            new VLabelElement()
              ..className = 'label'
              ..text = "Role",
            _roleHelper(user),
          ],
        new VDivElement()
          ..className = 'column is-2'
          ..children = [
            renderSubmit(
                _submitClick,
                Validator.canActivateSubmit(
                    state.firstNameIsValid, state.memIsValid, state.addressIsValid, state.lastNameIsValid)),
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
          ..className = 'column is-narrow is-offset-1 is-1'
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
            _renderPosition(user),
          ],
        new VDivElement()
          ..className = 'column is-one-fifth is-offset-1'
          ..children = [
            renderEdit(_editClick),
          ],
      ]);
    return nodeList;
  }

  ///[_renderPosition] creates the position row
  VNode _renderPosition(User user) {
    if (!state.edit) {
      return (new VDivElement()
        ..className = 'columns is-mobile is-centered is-vcentered'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow is-offset-3'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "Position",
            ],
          new VDivElement()
            ..className = 'column'
            ..children = [
              new VDivElement()
                ..className = "control"
                ..children = [
                  new VInputElement()
                    ..className = "input is-static"
                    ..id = "Position"
                    ..defaultValue = checkText(user.position)
                    ..readOnly = true,
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
    } else {
      return (new VDivElement());
    }
  }

  ///[_rollHelper] creates either a dropdown for edit or a box for viewing role
  VNode _roleHelper(User user) {
    if (state.edit) {
      return (new VDivElement()
        ..className = 'dropdown ${state.dropDownActive ? 'is-active' : ''}'
        ..children = [
          new VDivElement()
            ..className = 'dropdown-trigger'
            ..onClick = _dropDownClick
            ..children = [
              new VButtonElement()
                ..className = 'button is-dropdown-menu is-centered'
                ..children = [
                  new VSpanElement()..text = state.role,
                  new VSpanElement()
                    ..className = 'icon'
                    ..children = [new Vi()..className = "fas fa-angle-down"],
                  new VDivElement()
                    ..className = 'dropdown-menu'
                    ..id = 'dropdown-menu'
                    ..children = [
                      new VDivElement()
                        ..className = 'dropdown-content'
                        ..children = [
                          new VAnchorElement()
                            ..className = 'dropdown-item ${state.role.compareTo("member") == 0 ? 'is-active' : ''}'
                            ..onClick = _changeRollMemClick
                            ..text = "member",
                          new VAnchorElement()
                            ..className = 'dropdown-item ${state.role.compareTo("volunteer") == 0 ? 'is-active' : ''}'
                            ..onClick = _changeRollVolClick
                            ..text = "volunteer",
                          new VAnchorElement()
                            ..className = 'dropdown-item ${state.role.compareTo("admin") == 0 ? 'is-active' : ''}'
                            ..onClick = _changeRollAdminClick
                            ..text = "admin",
                        ],
                    ],
                ],
            ],
        ]);
    } else {
      return (new VDivElement()
        ..className = "control"
        ..children = [
          new VInputElement()
            ..className = "input is-static"
            ..id = "Role"
            ..defaultValue = checkText(state.role)
            ..readOnly = true,
        ]);
    }
  }

  ///[_renderMembership] creates the membership row
  List<VNode> _renderMembership(User user) {
    List<VNode> nodeList = <VNode>[];
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile is-vcentered'
      ..children = [
        new VDivElement()
          ..className = 'column is-narrow is-offset-1'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Membership:",
          ],
      ]);
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile is-vcentered'
      ..children = [
        new VDivElement()
          ..className = 'column is-narrow is-offset-2'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Start",
          ],
        new VDivElement()
          ..className = 'column is-3'
          ..children = [
            new VParagraphElement()
              ..className = "control"
              ..children = [
                new VDateInputElement()
                  ..onInput = _membershipValidator
                  ..className = "input ${state.edit ? '' : 'is-static'} ${state.memIsValid ? '' : 'is-danger'}"
                  ..id = "Start"
                  ..value = formatDate(user.membershipStart, [yyyy, "-", mm, "-", dd])
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
          ..className = 'column is-3'
          ..children = [
            new VParagraphElement()
              ..className = "control"
              ..children = [
                new VDateInputElement()
                  ..onInput = _membershipValidator
                  ..className = "input ${state.edit ? '' : 'is-static'} ${state.memIsValid ? '' : 'is-danger'}"
                  ..id = "Renewal"
                  ..value = formatDate(user.membershipRenewal, [yyyy, "-", mm, "-", dd])
                  ..readOnly = !state.edit,
              ],
          ],
        new VParagraphElement()
          ..className = 'help is-danger ${state.memIsValid ? 'is-invisible' : ''}'
          ..text = "Renewal Date is before Start Date",
      ]);
    return nodeList;
  }

  ///[_renderAddress] row for address label and input
  _renderAddress(User user) => new VDivElement()
    ..className = 'columns is-mobile is-vcentered'
    ..children = [
      new VDivElement()
        ..className = 'column is-narrow is-offset-1'
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
                ..onInput = _addressValidator
                ..className = "input ${state.edit ? '' : 'is-static'} ${state.addressIsValid ? '' : 'is-danger'}"
                ..id = "Address"
                ..defaultValue = checkText(user.address)
                ..readOnly = !state.edit,
              new VParagraphElement()
                ..className = 'help is-danger ${state.addressIsValid ? 'is-invisible' : ''}'
                ..text = 'Address is invalid',
            ],
        ],
    ];

  ///[_renderNumber] row for numbers and email
  _renderNumber(User user) => new VDivElement()
    ..className = 'columns is-mobile is-centered is-vcentered'
    ..children = [
      new VDivElement()
        ..className = 'column is-offset-1'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Home Phone",
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..onInput = _phoneNumberValidator
                ..className = "input ${state.edit ? '' : 'is-static'} ${state.phoneNumberIsValid ? '' : 'is-danger'}"
                ..id = "PhoneNumber"
                ..defaultValue = checkText(user.phoneNumber)
                ..readOnly = !state.edit,
              new VParagraphElement()
                ..className = 'help is-danger ${state.phoneNumberIsValid ? 'is-invisible' : ''}'
                ..text = 'Phone number is invalid',
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
                ..onInput = _cellNumberValidator
                ..className = "input ${state.edit ? '' : 'is-static'} ${state.cellNumberIsValid ? '' : 'is-danger'}"
                ..id = "Mobile"
                ..defaultValue = checkText(user.mobileNumber)
                ..readOnly = !state.edit,
              new VParagraphElement()
                ..className = 'help is-danger ${state.cellNumberIsValid ? 'is-invisible' : ''}'
                ..text = 'Cell number is invalid',
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
                ..onInput = _emailValidator
                ..className = "input ${state.edit ? '' : 'is-static'} ${state.emailIsValid ? '' : 'is-danger'}"
                ..id = "Email"
                ..defaultValue = checkText(user.email)
                ..readOnly = !state.edit,
              new VParagraphElement()
                ..className = 'help is-danger ${state.emailIsValid ? 'is-invisible' : ''}'
                ..text = 'Email is invalid',
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
                      ..text = type + "${list.length > 1 ? 's' : ''}",
                  ],
                new VDivElement()
                  ..className = 'column'
                  ..children = _renderListRowsHelper(list, type),
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
                            ..defaultValue = checkText("")
                            ..readOnly = !state.edit,
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
            ..defaultValue = checkText(item.toString())
            ..readOnly = !state.edit,
        ]);
    }
    return nodeList;
  }

  ///[_renderTextArea] create each row ot text area items with a given label
  _renderTextArea(User user, String label, String defaultValue) => new VDivElement()
    ..className = 'columns is-mobile is-centered is-vcentered'
    ..children = [
      new VDivElement()
        ..className = 'column is-2'
        ..children = [
          new Vlabel()
            ..className = 'label'
            ..text = label,
        ],
      new VDivElement()
        ..className = 'column is-four-fifths'
        ..children = [
          new VTextAreaElement()
            ..className = 'textarea'
            ..defaultValue = defaultValue
            ..id = label.replaceAll(" ", "_")
            ..readOnly = !state.edit,
        ],
    ];

  VNode _renderCheckboxes() => new VDivElement()
    ..className = 'box'
    ..children = [
      new VDivElement()
        ..className = 'columns is-mobile'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VDivElement()
                ..className = 'control'
                ..children = [
                  new VCheckboxInputElement()
                    ..className = 'checkbox'
                    ..id = 'medRelease-input'
                    ..onClick = _medCheckBoxCheck
                ]
            ],
          new VDivElement()
            ..className = 'column'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "Has completed Medical Form"
            ],
        ],
      new VDivElement()
        ..className = 'columns is-mobile'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VDivElement()
                ..className = 'control'
                ..children = [
                  new VCheckboxInputElement()
                    ..className = 'checkbox'
                    ..id = 'waiverRelease-input'
                    ..onClick = _waiverCheckBoxCheck
                ]
            ],
          new VDivElement()
            ..className = 'column'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "Has completed the Waiver & Release Form"
            ],
        ],
      new VDivElement()
        ..className = 'columns is-mobile'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VDivElement()
                ..className = 'control'
                ..children = [
                  new VCheckboxInputElement()
                    ..className = 'checkbox'
                    ..id = 'intakeForm-input'
                    ..onClick = _intakeBoxCheck
                ]
            ],
          new VDivElement()
            ..className = 'column'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "Has completed the Intake Form"
            ],
        ],
      new VDivElement()
        ..className = 'columns is-mobile'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VDivElement()
                ..className = 'control'
                ..children = [
                  new VCheckboxInputElement()
                    ..className = 'checkbox'
                    ..id = 'mealOption-input'
                    ..onClick = _checkBoxCheck
                ]
            ],
          new VDivElement()
            ..className = 'column'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "Requires Home Delivery for Meals"
            ],
        ]
    ];

  //Input validation for each field

  /// [_firstNameValidation]Validation for first name
  void _firstNameValidation(_) {
    //Gets first field
    InputElement first = querySelector('#First_Name');
    //Checks if value is blank by calling Validator class
    bool isValid = Validator.name(first.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => NewMemberState..firstNameIsValid = isValid);
  }

  /// [_lastNameValidation] Validation for last name
  void _lastNameValidation(_) {
    //Gets last field
    InputElement last = querySelector('#Last_Name');
    //Validates with validator class
    bool isValid = Validator.name(last.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => NewMemberState..lastNameIsValid = isValid);
  }

  /// [_emailValidator] Validation for email using Spencer's function from constants.dart
  void _emailValidator(_) {
    //Gets email field
    InputElement email = querySelector('#Email');
    //Input validation from input validator
    bool isValid = Validator.email(email.value);
    setState((NewMemberProps, NewMemberState) => NewMemberState..emailIsValid = isValid);
  }

  //Validation for phone numbers
  //Area code is required

  //Possible formats
  //4252734489
  //14252734489
  //(425)2734489
  //1(425)2734489
  //425-273-4489
  //1-425-273-4489
  //+1-425-273-4489

  /// [_membershipValidator] Validation for membership
  void _membershipValidator(_) {
    InputElement memStart = querySelector('#Start');
    InputElement memRenew = querySelector('#Renewal');
    try {
      DateTime start = DateTime.parse(memStart.value);
      DateTime end = DateTime.parse(memRenew.value);
      bool isValid = Validator.time(start, end);
      setState((NewMemberProps, NewMemberState) => NewMemberState..memIsValid = isValid);
    } catch (_) {
      state.memIsValid = false;
    }
  }

  /// [_phoneNumberValidator] Validation for phone number, doesnt check if blank
  void _phoneNumberValidator(_) {
    //Gets phone field and then value from field
    InputElement phone = querySelector('#PhoneNumber');
    String value = phone.value;
    //If blank exit
    if (value == '') {
      return;
    }
    //Validation by validation class
    bool isValid = Validator.phoneNumber(value);
    //Sets state
    setState((NewMemberProps, NewMemberState) => NewMemberState..phoneNumberIsValid = isValid);
  }

  /// [_cellNumberValidator] Validation for cell number, doesnt check if blank
  void _cellNumberValidator(_) {
    //Gets cell field and then value from field
    InputElement cell = querySelector('#Mobile');
    String value = cell.value;
    //Exits if blank
    if (value == '') {
      return;
    }
    //Validation from validator class
    bool isValid = Validator.phoneNumber(value);
    //Sets state
    setState((NewMemberProps, NewMemberState) => NewMemberState..cellNumberIsValid = isValid);
  }

  /// [_addressValidator] Validation for address
  void _addressValidator(_) {
    InputElement address = querySelector("#Address");
    bool isValid = Validator.address(address.value);
    setState((NewMemberProps, NewMemberState) => NewMemberState..addressIsValid = isValid);
  }

  ///[_submitClick] listener to grab all available data on page and push to firebase
  _submitClick(_) {
    InputElement first = querySelector('#First_Name');
    InputElement last = querySelector('#Last_Name');
    InputElement email = querySelector('#Email');
    InputElement cell = querySelector('#Mobile');
    InputElement phone = querySelector('#PhoneNumber');
    InputElement address = querySelector('#Address');
    TextAreaElement diet = querySelector('#Dietary_Restrictions');
    TextAreaElement disability = querySelector('#Disabilities');
    TextAreaElement medical = querySelector('#Medical_Issues');
    InputElement memStart = querySelector('#Start');
    InputElement memRenew = querySelector('#Renewal');
    InputElement position = querySelector('#Position');

    User userToUpdate = props.userMap[props.selectedMemberUID].rebuild((builder) => builder
      ..firstName = first.value
      ..lastName = last.value
      ..email = email.value
      ..mobileNumber = cell.value
      ..phoneNumber = phone.value
      ..address = address.value
      ..role = state.role
      ..dietaryRestrictions = diet.value
      ..disabilities = disability.value
      ..medicalIssues = medical.value
      ..membershipStart = DateTime.parse(memStart.value)
      ..membershipRenewal = DateTime.parse(memRenew.value)
      ..emergencyContacts = new ListBuilder<EmergencyContact>()
      ..services = new ListBuilder<String>()
      ..position = position.value
      ..forms = new ListBuilder<String>()
      ..homeDeliver = state.mealBool
      ..medRelease = state.medBool
      ..waiverRelease = state.waiverBool
      ..intakeForm = state.intakeBool);

    props.actions.server.updateOrCreateUser(userToUpdate);
    props.actions.server.fetchAllMembers();

    setState((props, state) => state..edit = !state.edit);
  }

  ///[_dropDownClick] listener to open the dropdown
  _dropDownClick(_) {
    setState((props, state) => state..dropDownActive = !state.dropDownActive);
  }

  ///[_changeRollMemClick] listener to close the dropdown and select member
  _changeRollMemClick(_) {
    setState((props, state) => state..role = "member");
  }

  ///[_changeRollVolClick] listener to close the dropdown and select volunteer
  _changeRollVolClick(_) {
    setState((props, state) => state..role = "volunteer");
  }

  ///[_changeRollAdminClick] listener to close the dropdown and select admin
  _changeRollAdminClick(_) {
    setState((props, state) => state..role = "admin");
  }

  ///[_editClick] listener for the click action of the edit button to put page into an edit state
  _editClick(_) {
    setState((props, state) => state..edit = !state.edit);
  }

  /// [_checkBoxCheck] on click to set state of checkbox
  _checkBoxCheck(_) {
    setState((props, state) => state..mealBool = !state.mealBool);
  }

  /// [_medCheckBoxCheck] on click to set state of checkbox
  _medCheckBoxCheck(_) {
    setState((props, state) => state..medBool = !state.medBool);
  }

  /// [_waiverCheckBoxCheck] on click to set state of checkbox
  _waiverCheckBoxCheck(_) {
    setState((props, state) => state..waiverBool = !state.waiverBool);
  }

  /// [_intakeBoxCheck] on click to set state of checkbox
  _intakeBoxCheck(_) {
    setState((props, state) => state..intakeBool = !state.intakeBool);
  }

  ///[_renderUserNotFound] if the UID is bad this page will simply say the user was not found
  _renderUserNotFound() => new VDivElement()..text = 'not found!';
}
