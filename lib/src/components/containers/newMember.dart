import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../constants.dart';
import '../../model/emergencyContact.dart';
import '../../state/app.dart';
import '../core/nav.dart';
import '../../model/user.dart';

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
}

class NewMember extends Component<NewMemberProps, NewMemberState> {
  NewMember(props) : super(props);

  @override
  NewMemberState getInitialState() => NewMemberState()
    ..firstNameIsValid = true
    ..lastNameIsValid = true
    ..emailIsValid = true
    ..phoneNumberIsValid = true
    ..cellNumberIsValid = true
    ..addressIsValid = true
    ;

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
                                    ..text = "First Name"
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
                                                ..text = "Last Name"
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
                                                    ..className = 'help is-danger ${state.cellNumberIsValid ? 'is-invisible' : ''}'
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
                            ..text = "Address",
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
                                    ..className = 'input ${state.cellNumberIsValid ? '' : 'is-danger'}'
                                    ..id = 'address-input'
                                    ..placeholder = "US Only",
                                  new VParagraphElement()
                                    ..className = 'help is-danger ${state.cellNumberIsValid ? 'is-invisible' : ''}'
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
                                    ..text = "Membership Start",
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
                                                ..text = "Membership Renewal"
                                            ],
                                          new VDivElement()
                                            ..className = 'field'
                                            ..children = [
                                              new VParagraphElement()
                                                ..className = 'control is-expanded'
                                                ..children = [
                                                  new VInputElement()
                                                    ..className = 'input'
                                                    ..id = 'memRenew-input'
                                                    ..type = 'date'
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ],
                        ]
                    ],

                  //TODO: Add a field for profile picture

                  //create the drop down menu for establishing the type of user
                  new VDivElement()
                    ..className = 'columns is-centered'
                    ..children = [
                      new VDivElement()
                        ..className = 'dropdown'
                        ..children = [
                          new VDivElement()
                            ..className = 'dropdown-trigger'
                            ..children = [
                              new VAnchorElement()
                                ..className = 'button is-dropdown-menu is-centered'
                                ..children = [
                                  new VSpanElement()
                                    ..text = "Role"
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
                                    ]
                                ]
                            ]
                        ]
                    ],
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

  //Input validation for each field 

  //Validation for first name
  void _firstNameValidation(_) {
    //Gets first field
    InputElement first = querySelector('#fName-input');
    //Checks if value is blank by calling InputValidator class
    bool isValid = InputValidator.nameValidator(first.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => 
      NewMemberState..firstNameIsValid = isValid);
  }

  //Validation for last name
  void _lastNameValidation(_) {
    //Gets last field
    InputElement last = querySelector('#lName-input');
    //Validates with validator class
    bool isValid = InputValidator.nameValidator(last.value);
    //Sets new state
    setState((NewMemberProps, NewMemberState) => 
      NewMemberState..lastNameIsValid = isValid);
  }

  //Validation for email using Spencer's function from constants.dart
  void _emailValidator(_) {
    //Gets email field
    InputElement email = querySelector('#email-input');
    //Input validation from input validator
    bool isValid = InputValidator.emailValidator(email.value)
    setState((NewMemberProps, NewMemberState) =>
      NewMemberState..emailIsValid = isValid);
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
  
   //Validation for phone number, doesnt check if blank
  void _phoneNumberValidator(_) {
    //Gets phone field and then value from field
    InputElement phone = querySelector('#phoneNum-input');
    String value = phone.value;
    //If blank exit
    if(value == '') {
      return;
    }
    //Validation by validation class
    bool isValid = InputValidator.emailValidator(value);    
    //Sets state
    setState((NewMemberProps, NewMemberState) =>
      NewMemberState..phoneNumberIsValid = isValid);
  }

  //Validation for cell number, doesnt check if blank
  void _cellNumberValidator(_) {
    //Gets cell field and then value from field
    InputElement cell = querySelector('#cellNum-input');
    String value = cell.value;
    //Exits if blank
    if(value == '') {
      return;
    }
    //Validation from validator class
    bool isValid =InputValidator.emailValidator(value);
    //Sets state
    setState((NewMemberProps, NewMemberState) =>
      NewMemberState..cellNumberIsValid = isValid);
  }

  void _addressValidator(_) {
    InputElement address =querySelector("#address-input");
    bool isValid = InputValidator.addressValidator(address.value);
    setState((NewMemberProps, NewMemberState) =>
      NewMemberState..addressIsValid = isValid);
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
          ..role = "NULL"
          ..position = "NULL"
          ..forms = new ListBuilder<String>())
        .build();

    props.actions.server.updateOrCreateUser(newUser);
    props.actions.server.fetchAllMembers();

    history.push(Routes.dashboard);
  }
}
