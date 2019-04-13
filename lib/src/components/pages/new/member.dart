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

class NewMemberProps {
  AppActions actions;
  User user;
}

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

  //create the text boxes that are used to create new users
  VNode _userCreation() => new VDivElement()
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
                            ..text = "User Creation"
                        ]
                    ],
                  //create the First and Last Name Input field
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
                                                    ..className =
                                                        'help is-danger ${state.lastNameIsValid ? 'is-invisible' : ''}'
                                                    ..text = 'Last name is required'
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ],
                    ],

                  //create the Email Input field
                  new VDivElement()
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
                    ],

                  //create the Phone Number Input field
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
                                                    ..className =
                                                        'help is-danger ${state.cellNumberIsValid ? 'is-invisible' : ''}'
                                                    ..text = 'Cell number is invalid'
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ],
                        ]
                    ],

                  //create the Address Input field
                  new VDivElement()
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
                                    ..placeholder = "US Only",
                                  new VParagraphElement()
                                    ..className = 'help is-danger ${state.addressIsValid ? 'is-invisible' : ''}'
                                    ..text = 'Address is invalid'
                                ]
                            ]
                        ]
                    ],

                  //create the Dietary Restrictions Input field
                  new VDivElement()
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
                    ],

                  //create the Disabilities Input field
                  new VDivElement()
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
                    ],

                  //create the Medical Issue Input field
                  new VDivElement()
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
                    ],

                  //create the Membership Start Date Input field
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
                                        ..type = 'date'
                                    ],
                                  //create the Membership Renewal Date Input field
                                  new VParagraphElement()
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
                                                    ..className =
                                                        'help is-danger ${state.memIsValid ? 'is-invisible' : ''}'
                                                    ..text = "Renewal Date is before Start Date"
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ],
                        ]
                    ],

                  //TODO: Add a field for profile picture

                  new VDivElement()
                    ..className = 'columns'
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
                        ..className = 'column is-narrow'
                        ..children = [
                          new VLabelElement()
                            ..className = 'label'
                            ..text = "Completed Medical Form"
                        ],
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
                        ..className = 'column is-narrow'
                        ..children = [
                          new VLabelElement()
                            ..className = 'label'
                            ..text = "Completed Waiver & Release Form"
                        ],
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
                        ..className = 'column is-narrow'
                        ..children = [
                          new VLabelElement()
                            ..className = 'label'
                            ..text = "Completed Intake Form"
                        ],
                    ],

                  //create the drop down menu for establishing the type of user
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      new VDivElement()
                        ..className = 'column'
                        ..children = [
                          _roleHelper(),
                        ],
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
                        ..className = 'column is-narrow'
                        ..children = [
                          new VLabelElement()
                            ..className = 'label'
                            ..text = "Requires Home Delivery for Meals"
                        ],
                    ],
                  //create the submit button
                  new VDivElement()
                    ..className = 'field is-grouped is-grouped-right'
                    ..children = [
                      new VDivElement()
                        ..className = 'control'
                        ..children = [
                          new VButtonElement()
                            ..className = 'button is-link'
                            ..disabled = _canActivateSubmit()
                            ..text = "Submit"
                            ..onClick = _submitClick
                        ]
                    ]
                ]
            ]
        ]
    ];

  //Input validation for each field

  //Validation for first name
  void _firstNameValidation(_) {
    //Gets first field
    InputElement first = querySelector('#fName-input');
    //Checks if value is blank by calling Validator class
    bool isValid = Validator.name(first.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => NewMemberState..firstNameIsValid = isValid);
    _canActivateSubmit;
  }

  //Validation for last name
  void _lastNameValidation(_) {
    //Gets last field
    InputElement last = querySelector('#lName-input');
    //Validates with validator class
    bool isValid = Validator.name(last.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => NewMemberState..lastNameIsValid = isValid);
    _canActivateSubmit;
  }

  //Validation for email using Spencer's function from constants.dart
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

  //Validation for phone number, doesnt check if blank
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

  //Validation for cell number, doesnt check if blank
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

  void _addressValidator(_) {
    InputElement address = querySelector("#address-input");
    bool isValid = Validator.address(address.value);
    setState((NewMemberProps, NewMemberState) => NewMemberState..addressIsValid = isValid);
    _canActivateSubmit();
  }

  bool _canActivateSubmit() {
    if (state.firstNameIsValid && state.lastNameIsValid && state.addressIsValid && state.memIsValid) {
      return false; //enables button on false
    }
    return true; //disables button on true
  }

  //method used for the submit click
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
    props.actions.server.fetchAllMembers();

    history.push(Routes.dashboard);
  }

  ///[roleHelper] creates dropdown for role selection
  VNode _roleHelper() {
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
      ]);
  }

  _dropDownClick(_) {
    setState((props, state) => state..dropDownActive = !state.dropDownActive);
  }

  _changeRoleMemClick(_) {
    setState((props, state) => state..role = "member");
  }

  _changeRoleVolClick(_) {
    setState((props, state) => state..role = "volunteer");
  }

  _changeRoleAdminClick(_) {
    setState((props, state) => state..role = "admin");
  }

  //Every time this function is called (when the check box is ticked), it flips the state of mealBool (true when ticked, false when unticked)
  _checkBoxCheck(_) {
    setState((props, state) => state..mealBool = !state.mealBool);
  }

  _medCheckBoxCheck(_) {
    setState((props, state) => state..medBool = !state.medBool);
  }

  _waiverCheckBoxCheck(_) {
    setState((props, state) => state..waiverBool = !state.waiverBool);
  }

  _intakeBoxCheck(_) {
    setState((props, state) => state..intakeBool = !state.intakeBool);
  }
}
