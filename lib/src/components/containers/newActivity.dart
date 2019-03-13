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

//TODO: Make is so when the logout button is pressed, it takes you back to the main page

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
                                            ..className = 'input'
                                            ..id = 'act-input'
                                            ..placeholder = "e.g. Yoga"
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
                                            ..className = 'input'
                                            ..id = 'instructorName-input'
                                            ..placeholder = "First and Last Name"
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
                                            ..className = 'input'
                                            ..id = 'location-input'
                                            ..placeholder = "Where is the activity taking place?"
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
                                            ..className = 'input'
                                            ..id = 'capacity-input'
                                            ..type = 'number'
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
                                            ..className = 'input'
                                            ..id = 'timeStart-input'
                                            ..type = 'time'
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
                                            ..className = 'input'
                                            ..id = 'timeEnd-input'
                                            ..type = 'time'
                                        ]
                                      ]
                                    ]
                                ]
                            ]
                          ]
                    ],
                  //TODO: possibly find a way for admin to add a picture to the database and allow activities to access and utilize them

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