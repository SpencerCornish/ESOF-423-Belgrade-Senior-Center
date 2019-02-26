import 'dart:async';

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../constants.dart';

import '../../state/app.dart';
import '../../store.dart';

class FormsProps {
  AppActions actions;
}

class Forms extends PComponent<FormsProps> {
  Forms(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..className = 'container'
    ..children = [
      new VDivElement()
        ..className = 'columns is-centered'
        ..children = [
          new VDivElement()
            ..className = 'column has-text-centered'
            ..children = [
              new Vh1()
                ..className = 'title'
                ..text = "User Creation",
              _userCreation(),
            ],
        ],
    ];

  //create the text boxes that are used to create new users
  VNode _userCreation() => new VDivElement()
    ..className = 'box'
    ..children = [
      //create the First Name Input field
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
                                    //..id = 'lName-lab'
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

      // new VDivElement()
      //   ..className = 'field is-grouped'
      //   ..children = [
      //     new VDivElement()
      //       ..className = 'field is-horizontal'
      //       ..children = [
      //         new VDivElement()
      //           ..className = 'field-body'
      //           ..children = [
      //             new VDivElement()
      //               ..className = 'field-label is-normal'
      //               ..children = [
      //                 new VLabelElement()
      //                   ..className = 'label'
      //                   ..text = "First Name"
      //               ],

      //             new VParagraphElement()
      //               ..className = 'control'
      //               ..children = [
      //                 new VDivElement()
      //                   ..className = 'field-label'
      //                   ..children = [
      //                     new VInputElement()
      //                       ..className = 'input'
      //                       ..id = 'fName-input'
      //                       ..placeholder = "First Name"
      //                   ],
      //               ],
      //             //creat the Last Name Input Field
      //             new VDivElement()
      //               ..className = 'field-label is-normal'
      //               ..children = [
      //                 new VLabelElement()
      //                   ..className = 'label'
      //                   ..text = "Last Name"
      //               ],
      //             new VParagraphElement()
      //               ..className = 'control is-expanded'
      //               ..children = [
      //                 new VDivElement()
      //                   ..className = 'field-label is-expanded'
      //                   ..children = [
      //                     new VInputElement()
      //                       ..className = 'input'
      //                       ..id = 'lName-input'
      //                       ..placeholder = "Last Name"
      //                   ],
      //               ]
      //           ],
      //       ],
      //   ],

      //create the Email Input field
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Email",
          new VInputElement()
            ..className = 'input'
            ..id = 'email-input'
            ..placeholder = "Email@email.email"
            ..type = 'email'
        ],
      //create the Phone Number Input field
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Phone Number",
          new VInputElement()
            ..className = 'input'
            ..id = 'phoneNum-input'
            ..placeholder = "1234567891"
            ..type = 'tel'
        ],
      //create the Cell Phone Number Input field
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Cell Number",
          new VInputElement()
            ..className = 'input'
            ..id = 'cellNum-input'
            ..placeholder = "1234567891"
            ..type = 'tel'
        ],
      //create the Address Input field
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Address",
          new VInputElement()
            ..className = 'input'
            ..id = 'address-input'
            ..placeholder = "US Only"
        ],

      //TODO: Add a field for profile picture

      //create the drop down menu for establishing the time of user
      new VDivElement()
        ..className = 'dropdown is-active'
        ..children = [
          new VDivElement()
            ..className = 'dropdown-trigger'
            ..children = [
              new VAnchorElement()
                ..className = 'button is-dropdown-menu'
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
    ];
}
