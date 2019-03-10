import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../constants.dart';
import '../../model/emergencyContact.dart';
import '../../state/app.dart';
import '../../store.dart';
import '../core/nav.dart';
import '../../model/user.dart';

class NewActivityProps {
  AppActions actions;
  User user;
}

class NewActivity extends PComponent<NewActivityProps> {
  NewActivity(props) : super(props);

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
                            ..text = "Activity Creation"
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
                                        ..className = 'input'
                                        ..id = 'fName-input'
                                        ..placeholder = "First Name"
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
                                                    ..className = 'input'
                                                    ..id = 'lName-input'
                                                    ..placeholder = "Last Name"
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
                                    ..className = 'input'
                                    ..id = 'email-input'
                                    ..placeholder = "Email@email.email"
                                    ..type = 'email'
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
                                        ..className = 'input'
                                        ..id = 'phoneNum-input'
                                        ..placeholder = "1234567891"
                                        ..type = 'tel'
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
                                                    ..className = 'input'
                                                    ..id = 'cellNum-input'
                                                    ..placeholder = "1234567891"
                                                    ..type = 'tel'
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
                                    ..className = 'input'
                                    ..id = 'address-input'
                                    ..placeholder = "US Only"
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
                                ..id = 'timeStart-label'
                                ..children = [
                                  new VLabelElement()
                                    ..className = 'label'
                                    ..text = "Start Time",
                                ],
                              new VDivElement()
                                ..className = 'field is-horizontal'
                                ..children = [
                                  new VParagraphElement()
                                    ..className = 'control'
                                    ..children = [
                                      new VInputElement()
                                        ..className = 'input'
                                        ..id = 'timeStart-input'
                                        ..type = 'time'
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
                                            ..id = 'timeEnd-label'
                                            ..children = [
                                              new VLabelElement()
                                                ..className = 'label'
                                                ..text = "End Time Renewal"
                                            ],
                                          new VDivElement()
                                            ..className = 'field'
                                            ..children = [
                                              new VParagraphElement()
                                                ..className = 'control is-expanded'
                                                ..children = [
                                                  new VInputElement()
                                                    ..className = 'input'
                                                    ..id = 'timeEnd-input'
                                                    ..type = 'time'
                                                ]
                                            ]
                                        ]
                                    ]
                                ]
                            ],
                        ]
                    ],
                  //TODO: possibly find a way for admin to add a picture to the database and allow activities to access and utilize them

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
                            // ..onClick = _submitClick
                        ]
                    ]
                ]
            ]
        ]
    ];

  //method used for the submit click
  //will need to send fName-input, lName-input, email-input,
  //cellNum-input, phoneNum-input, address-input, diet-input,
  //disabilities-input, medicalIssue-input, memStart-input , and memRenew-input, and role type to database
  // _submitClick(_) {
  //   InputElement first = querySelector('#fName-input');
  //   InputElement last = querySelector('#lName-input');
  //   InputElement email = querySelector('#email-input');
  //   InputElement cell = querySelector('#cellNum-input');
  //   InputElement phone = querySelector('#phoneNum-input');
  //   InputElement address = querySelector('#address-input');
  //   InputElement diet = querySelector('#diet-input');
  //   InputElement disability = querySelector('#disabilities-input');
  //   InputElement medical = querySelector('#medicalIssue-input');
  //   InputElement memStart = querySelector('#memStart-input');
  //   InputElement memRenew = querySelector('#memRenew-input');

  //   //create a new user object
  //   User newUser = (new UserBuilder()
  //         ..firstName = first.value
  //         ..lastName = last.value
  //         ..email = email.value
  //         ..mobileNumber = cell.value
  //         ..phoneNumber = phone.value
  //         ..address = address.value
  //         ..dietaryRestrictions = diet.value
  //         ..disabilities = disability.value
  //         ..medicalIssues = medical.value
  //         ..membershipStart = DateTime.parse(memStart.value)
  //         ..membershipRenewal = DateTime.parse(memRenew.value)
  //         ..emergencyContacts = new ListBuilder<EmergencyContact>()
  //         ..services = new ListBuilder<String>()
  //         ..role = "NULL"
  //         ..position = "NULL"
  //         ..forms = new ListBuilder<String>())
  //       .build();

  //   props.actions.server.updateOrCreateUser(newUser);
  //   props.actions.server.fetchAllMembers();

  //   history.push(Routes.dashboard);
  // }
}
