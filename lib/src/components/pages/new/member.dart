import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../constants.dart';
import '../../../model/emergencyContact.dart';
import '../../../state/app.dart';
import '../../core/nav.dart';
import '../../../model/user.dart';

/// [NewMemberProps] class for the new member page passed in propeerties
class NewMemberProps {
  AppActions actions;
  User user;
}

/// [NewMemberState] state class for the new member page
class NewMemberState {
  bool firstNameIsValid;
  bool lastNameIsValid;
  bool emailIsValid;
  bool phoneNumberIsValid;
  bool cellNumberIsValid;
  bool addressIsValid;
  bool mealBool;
  bool dropDownActive;
  bool medBool;
  bool waiverBool;
  bool intakeBool;
  bool hasInvalid;
  bool memIsValid;
  String role;
}

/// [NewMember] class to create the new meal page for creating an meal
class NewMember extends Component<NewMemberProps, NewMemberState> {
  NewMember(props) : super(props);

  @override
  NewMemberState getInitialState() => NewMemberState()
    ..firstNameIsValid = false
    ..lastNameIsValid = false
    ..emailIsValid = true
    ..phoneNumberIsValid = true
    ..cellNumberIsValid = true
    ..addressIsValid = false
    ..mealBool = false
    ..dropDownActive = false
    ..medBool = false
    ..waiverBool = false
    ..intakeBool = false
    ..hasInvalid = true
    ..memIsValid = false
    ..role = "member";

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
          _userCreation(),
        ]
    ];

  /// [_userCreation] create the text boxes that are used to create new users
  VNode _userCreation() => new VDivElement()
    ..className = 'container'
    ..children = [
      new VDivElement()
        ..className = 'columns is-centered margin-top'
        ..children = [
          new VDivElement()
            ..className = 'column is-three-quarters'
            ..children = [_renderBox()]
        ]
    ];

  ///[_renderBox] renders all input fields
  _renderBox() => new VDivElement()
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
                ..text = "User Creation"
            ]
        ],
      //create the First and Last Name Input field
      _renderName(),
      //create the Email Input field
      _renderEmail(),
      //create the Phone Number Input field
      _renderPhone(),
      //create the Address Input field
      _renderAddress(),
      //create the Dietary Restrictions Input field
      _renderRestricitons(),
      //create the Disabilities Input field
      _renderDissability(),
      //create the Medical Issue Input field
      _renderMedIssue(),
      //create the Membership Start Date Input field and renewal
      _renderMembershipDates(),
      //create the drop down menu for establishing the type of user
      new VDivElement()
        ..className = 'columns is-centered'
        ..children = [
          new VDivElement()
            ..className = 'column is-three-quarters'
            ..children = [_renderRoleBox()],
        ],
      new VDivElement()
        ..className = 'columns is-centered'
        ..children = [
          new VDivElement()
            ..className = 'column is-half'
            ..children = [_renderCheckboxes()],
        ],
      //create the submit button
      new VDivElement()
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
        ]
    ];

  ///[_renderName] renders Name label and input
  VNode _renderName() => new VDivElement()
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
                ..id = 'fName-lab'
                ..children = [
                  new VLabelElement()
                    ..className = 'label'
                    ..children = [
                      new VSpanElement()..text = "First Name",
                      new VSpanElement()
                        ..className = "has-text-danger"
                        ..text = '*'
                    ]
                ],
              new VDivElement()
                ..className = 'field is-horizontal'
                ..children = [
                  new VParagraphElement()
                    ..className = 'control'
                    ..children = [
                      new VInputElement()
                        ..className = 'input ${state.firstNameIsValid ? '' : 'is-danger'}'
                        ..onInput = _firstNameValidation
                        ..id = 'fName-input'
                        ..placeholder = "First Name",
                      new VParagraphElement()
                        ..className = 'help is-danger ${state.firstNameIsValid ? 'is-invisible' : ''}'
                        ..text = 'First name is required'
                    ],
                  new VParagraphElement()
                    ..className = 'field'
                    ..children = [
                      new VDivElement()
                        ..className = 'field is-horizontal'
                        ..children = [
                          new VDivElement()
                            ..className = 'field-label is-normal'
                            ..id = 'lName-lab'
                            ..children = [
                              new VLabelElement()
                                ..className = 'label'
                                ..children = [
                                  new VSpanElement()..text = "Last Name",
                                  new VSpanElement()
                                    ..className = "has-text-danger"
                                    ..text = '*'
                                ]
                            ],
                          new VDivElement()
                            ..className = 'field'
                            ..children = [
                              new VParagraphElement()
                                ..className = 'control is-expanded'
                                ..children = [
                                  new VInputElement()
                                    ..className = 'input ${state.lastNameIsValid ? '' : 'is-danger'}'
                                    ..onInput = _lastNameValidation
                                    ..id = 'lName-input'
                                    ..placeholder = "Last Name",
                                  new VParagraphElement()
                                    ..className = 'help is-danger ${state.lastNameIsValid ? 'is-invisible' : ''}'
                                    ..text = 'Last name is required'
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ],
    ];

  ///[_renderEmail] renders Email label and input
  VNode _renderEmail() => new VDivElement()
    ..className = 'field is-horizontal'
    ..children = [
      new VDivElement()
        ..className = 'field-label is-normal'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Email",
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
                  new VInputElement()
                    ..onInput = _emailValidator
                    ..className = 'input ${state.emailIsValid ? '' : 'is-danger'}'
                    ..id = 'email-input'
                    ..placeholder = "name@example.com"
                    ..type = 'email',
                  new VParagraphElement()
                    ..className = 'help is-danger ${state.emailIsValid ? 'is-invisible' : ''}'
                    ..text = 'Email is invalid'
                ]
            ]
        ]
    ];

  ///[_renderPhone] renders Phone label and input
  VNode _renderPhone() => new VDivElement()
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
                ..id = 'phoneNum-label'
                ..children = [
                  new VLabelElement()
                    ..className = 'label'
                    ..text = "Phone Number",
                ],
              new VDivElement()
                ..className = 'field is-horizontal'
                ..children = [
                  new VParagraphElement()
                    ..className = 'control'
                    ..children = [
                      new VInputElement()
                        ..onInput = _phoneNumberValidator
                        ..className = 'input ${state.phoneNumberIsValid ? '' : 'is-danger'}'
                        ..id = 'phoneNum-input'
                        ..placeholder = "888-888-88888"
                        ..type = 'tel',
                      new VParagraphElement()
                        ..className = 'help is-danger ${state.phoneNumberIsValid ? 'is-invisible' : ''}'
                        ..text = 'Phone number is invalid'
                    ],
                  //create the Cell Phone Number Input field
                  new VParagraphElement()
                    ..className = 'field'
                    ..children = [
                      new VDivElement()
                        ..className = 'field is-horizontal'
                        ..children = [
                          new VDivElement()
                            ..className = 'field-label is-normal'
                            ..id = 'cellNum-label'
                            ..children = [
                              new VLabelElement()
                                ..className = 'label'
                                ..text = "Cell Number"
                            ],
                          new VDivElement()
                            ..className = 'field'
                            ..children = [
                              new VParagraphElement()
                                ..className = 'control is-expanded'
                                ..children = [
                                  new VInputElement()
                                    ..onInput = _cellNumberValidator
                                    ..className = 'input ${state.cellNumberIsValid ? '' : 'is-danger'}'
                                    ..id = 'cellNum-input'
                                    ..placeholder = "888-888-88888"
                                    ..type = 'tel',
                                  new VParagraphElement()
                                    ..className = 'help is-danger ${state.cellNumberIsValid ? 'is-invisible' : ''}'
                                    ..text = 'Cell number is invalid'
                                ]
                            ]
                        ]
                    ]
                ]
            ],
        ]
    ];

  ///[_renderAddress] renders Address label and input
  VNode _renderAddress() => new VDivElement()
    ..className = 'field is-horizontal'
    ..children = [
      new VDivElement()
        ..className = 'field-label is-normal'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..children = [
              new VSpanElement()..text = "Mailing Address",
              new VSpanElement()
                ..className = "has-text-danger"
                ..text = '*'
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
                  new VInputElement()
                    ..onInput = _addressValidator
                    ..className = 'input ${state.addressIsValid ? '' : 'is-danger'}'
                    ..id = 'address-input'
                    ..placeholder = "1111 Example st. Belgrade, MT 59714",
                  new VParagraphElement()
                    ..className = 'help is-danger ${state.addressIsValid ? 'is-invisible' : ''}'
                    ..text = 'Address is invalid'
                ]
            ]
        ]
    ];

  ///[_renderRestricitons] renders Restricitons label and input
  VNode _renderRestricitons() => new VDivElement()
    ..className = 'field is-horizontal'
    ..children = [
      new VDivElement()
        ..className = 'field-label is-normal'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Dietary Restrictions",
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
                  new VInputElement()
                    ..className = 'input'
                    ..id = 'diet-input'
                    ..placeholder = "e.g. Lactose Intolerant"
                ]
            ]
        ]
    ];

  ///[_renderDissability] renders dissability label and input
  VNode _renderDissability() => new VDivElement()
    ..className = 'field is-horizontal'
    ..children = [
      new VDivElement()
        ..className = 'field-label is-normal'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Disabilities",
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
                  new VInputElement()
                    ..className = 'input'
                    ..id = 'disabilities-input'
                    ..placeholder = "e.g. Blind"
                ]
            ]
        ]
    ];

  ///[_renderMedIssue] renders meddical isses label and input
  VNode _renderMedIssue() => new VDivElement()
    ..className = 'field is-horizontal'
    ..children = [
      new VDivElement()
        ..className = 'field-label is-normal'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Medical Issues",
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
                  new VInputElement()
                    ..className = 'input'
                    ..id = 'medicalIssue-input'
                    ..placeholder = "e.g. ADD/ADHD"
                ]
            ]
        ]
    ];

  ///[_renderMembershipDates] renders membership start label and input and calls to render membership renewal
  VNode _renderMembershipDates() => new VDivElement()
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
                ..id = 'memStart-label'
                ..children = [
                  new VLabelElement()
                    ..className = 'label'
                    ..children = [
                      new VSpanElement()..text = "Membership Start",
                      new VSpanElement()
                        ..className = "has-text-danger"
                        ..text = '*'
                    ]
                ],
              new VDivElement()
                ..className = 'field is-horizontal'
                ..children = [
                  new VParagraphElement()
                    ..className = 'control'
                    ..children = [
                      new VInputElement()
                        ..className = 'input'
                        ..id = 'memStart-input'
                        ..onInput = _membershipValidator
                        ..type = 'date'
                    ],
                  //create the Membership Renewal Date Input field
                  _renderRenewal(),
                ]
            ],
        ]
    ];

  ///[_renderRenewal] renders membership renewal label and input
  VNode _renderRenewal() => new VParagraphElement()
    ..className = 'field'
    ..children = [
      new VDivElement()
        ..className = 'field is-horizontal'
        ..children = [
          new VDivElement()
            ..className = 'field-label is-normal'
            ..id = 'memRenew-label'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..children = [
                  new VSpanElement()..text = "Memership Renewal",
                  new VSpanElement()
                    ..className = "has-text-danger"
                    ..text = '*'
                ]
            ],
          new VDivElement()
            ..className = 'field'
            ..children = [
              new VParagraphElement()
                ..className = 'control is-expanded'
                ..children = [
                  new VInputElement()
                    ..onInput = _membershipValidator
                    ..className = 'input'
                    ..id = 'memRenew-input'
                    ..type = 'date',
                  new VParagraphElement()
                    ..className = 'help is-danger ${state.memIsValid ? 'is-invisible' : ''}'
                    ..text = "Renewal Date is before Start Date"
                ]
            ]
        ]
    ];

  ///[_renderRoleBox] creates a box describing the choices of role
  VNode _renderRoleBox() => new VDivElement()
    ..className = 'box'
    ..children = [
      new VDivElement()
        ..className = 'columns is-mobile is-centered'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VLabelElement()
                ..className = 'label'
                ..text = "User Role "
            ],
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              _renderRolePicker(),
            ],
        ],
      new VParagraphElement()
        ..children = [
          new VSpanElement()
            ..className = 'has-text-weight-bold'
            ..text = 'Admin: ',
          new VSpanElement()
            ..className = ''
            ..text = 'Can view, edit and create everything. Creates a login with the specified email.',
        ],
      new VParagraphElement()
        ..children = [
          new VSpanElement()
            ..className = 'has-text-weight-bold'
            ..text = 'Volunteer: ',
          new VSpanElement()
            ..className = ''
            ..text =
                'Can view, edit and create everything except other user\'s punches. Creates a login with the specified email.',
        ],
      new VParagraphElement()
        ..children = [
          new VSpanElement()
            ..className = 'has-text-weight-bold'
            ..text = 'Member: ',
          new VSpanElement()
            ..className = ''
            ..text = 'Has no permissions, cannot log in.',
        ],
    ];

  ///[_renderRolePicker] creates dropdown for role selection
  VNode _renderRolePicker() => new VDivElement()
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
                        ..onClick = _changeRoleMemClick
                        ..text = "member",
                      new VAnchorElement()
                        ..className = 'dropdown-item ${state.role.compareTo("volunteer") == 0 ? 'is-active' : ''}'
                        ..onClick = _changeRoleVolClick
                        ..text = "volunteer",
                      new VAnchorElement()
                        ..className = 'dropdown-item ${state.role.compareTo("admin") == 0 ? 'is-active' : ''}'
                        ..onClick = _changeRoleAdminClick
                        ..text = "admin",
                    ],
                ],
            ],
        ],
    ];

  ///[_renderRoleBox] creates a box with all needed checkboxes
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
    InputElement first = querySelector('#fName-input');
    //Checks if value is blank by calling Validator class
    bool isValid = Validator.name(first.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => NewMemberState..firstNameIsValid = isValid);
    _canActivateSubmit;
  }

  /// [_lastNameValidation] Validation for last name
  void _lastNameValidation(_) {
    //Gets last field
    InputElement last = querySelector('#lName-input');
    //Validates with validator class
    bool isValid = Validator.name(last.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => NewMemberState..lastNameIsValid = isValid);
    _canActivateSubmit;
  }

  /// [_emailValidator] Validation for email using Spencer's function from constants.dart
  void _emailValidator(_) {
    //Gets email field
    InputElement email = querySelector('#email-input');
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
    InputElement memStart = querySelector('#memStart-input');
    InputElement memRenew = querySelector('#memRenew-input');
    try {
      DateTime start = DateTime.parse(memStart.value);
      DateTime end = DateTime.parse(memRenew.value);
      bool isValid = Validator.time(start, end);
      setState((NewMemberProps, NewMemberState) => NewMemberState..memIsValid = isValid);
    } catch (_) {
      state.memIsValid = false;
    }
    _canActivateSubmit;
  }

  /// [_phoneNumberValidator] Validation for phone number, doesnt check if blank
  void _phoneNumberValidator(_) {
    //Gets phone field and then value from field
    InputElement phone = querySelector('#phoneNum-input');
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
    InputElement cell = querySelector('#cellNum-input');
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
    InputElement address = querySelector("#address-input");
    bool isValid = Validator.address(address.value);
    setState((NewMemberProps, NewMemberState) => NewMemberState..addressIsValid = isValid);
    _canActivateSubmit();
  }

  /// [_canActivateSubmit] if all are valid enables submit button
  bool _canActivateSubmit() {
    if (state.firstNameIsValid && state.lastNameIsValid && state.addressIsValid && state.memIsValid) {
      return false; //enables button on false
    }
    return true; //disables button on true
  }

  /// [_submitClick] method used for the submit click
  //will need to send fName-input, lName-input, email-input,
  //cellNum-input, phoneNum-input, address-input, diet-input,
  //disabilities-input, medicalIssue-input, memStart-input , and memRenew-input, and role type to database
  _submitClick(_) {
    InputElement first = querySelector('#fName-input');
    InputElement last = querySelector('#lName-input');
    InputElement email = querySelector('#email-input');
    InputElement cell = querySelector('#cellNum-input');
    InputElement phone = querySelector('#phoneNum-input');
    InputElement address = querySelector('#address-input');
    InputElement diet = querySelector('#diet-input');
    InputElement disability = querySelector('#disabilities-input');
    InputElement medical = querySelector('#medicalIssue-input');
    InputElement memStart = querySelector('#memStart-input');
    InputElement memRenew = querySelector('#memRenew-input');

    //create a new user object
    User newUser = (new UserBuilder()
          ..firstName = first.value
          ..lastName = last.value
          ..email = email.value
          ..mobileNumber = cell.value
          ..phoneNumber = phone.value
          ..address = address.value
          ..dietaryRestrictions = diet.value
          ..disabilities = disability.value
          ..medicalIssues = medical.value
          ..membershipStart = DateTime.parse(memStart.value)
          ..membershipRenewal = DateTime.parse(memRenew.value)
          ..emergencyContacts = new ListBuilder<EmergencyContact>()
          ..services = new ListBuilder<String>()
          ..role = state.role
          ..position = "NULL"
          ..forms = new ListBuilder<String>()
          ..homeDeliver = state.mealBool
          ..medRelease = state.medBool
          ..waiverRelease = state.waiverBool
          ..intakeForm = state.intakeBool)
        .build();

    props.actions.server.updateOrCreateUser(newUser);

    history.push(Routes.viewMembers);
  }

  /// [_dropDownClick] function to change state and open dropdown
  _dropDownClick(_) {
    setState((props, state) => state..dropDownActive = !state.dropDownActive);
  }

  /// [_changeRoleMemClick] function to change state and close dropdown
  _changeRoleMemClick(_) {
    setState((props, state) => state..role = "member");
  }

  /// [_changeRoleVolClick] function to change state and close dropdown
  _changeRoleVolClick(_) {
    setState((props, state) => state..role = "volunteer");
  }

  /// [_changeRoleAdminClick] function to change state and close dropdown
  _changeRoleAdminClick(_) {
    setState((props, state) => state..role = "admin");
  }

  //Every time this function is called (when the check box is ticked), it flips the state of mealBool (true when ticked, false when unticked)
  /// [_checkBoxCheck] function to change state and tick checkbox
  _checkBoxCheck(_) {
    setState((props, state) => state..mealBool = !state.mealBool);
  }

  /// [_medCheckBoxCheck] function to change state and tick checkbox
  _medCheckBoxCheck(_) {
    setState((props, state) => state..medBool = !state.medBool);
  }

  /// [_waiverCheckBoxCheck] function to change state and tick checkbox
  _waiverCheckBoxCheck(_) {
    setState((props, state) => state..waiverBool = !state.waiverBool);
  }

  /// [_intakeBoxCheck] function to change state and tick checkbox
  _intakeBoxCheck(_) {
    setState((props, state) => state..intakeBool = !state.intakeBool);
  }
}
