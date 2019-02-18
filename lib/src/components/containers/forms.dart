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
                ..text = "User, Class, and Meal Creation",
              _userCreation(),
            ],
        ],
    ];

  ///create the text boxes that are used to create new users
  VNode _userCreation() => new VDivElement()
    ..className = 'field'
    ..children = [
      //field for first name
      new VDivElement()
        ..className = 'label'
        ..text = "First Name"
        ..children = [
          new VInputElement()
            ..className = 'input'
            ..type = "name"
            ..id = 'fName-input'
            ..placeholder = "First Name"
        ],
      //field field last name
      new VDivElement()
        ..className = 'label'
        ..text = "Last Name"
        ..children = [
          new VInputElement()
            ..className = 'input'
            ..type = "Last Name"
            ..id = 'lName-input'
            ..placeholder = "Last Name"
        ],
      //field for email
      new VDivElement()
        ..className = 'label'
        ..text = "Email"
        ..children = [
          new VInputElement()
            ..className = 'input'
            ..type = "Email"
            ..id = 'email-input'
            ..placeholder = "Email@email.email"
        ],
      //field for phone number
      new VDivElement()
        ..className = 'label'
        ..text = "Phone Number"
        ..children = [
          new VInputElement()
            ..className = 'input'
            ..type = "Phone Number"
            ..id = 'phoneNum-input'
            ..placeholder = "1234567891"
        ],
      //field for cell phone
      new VDivElement()
        ..className = 'label'
        ..text = "Cell Number"
        ..children = [
          new VInputElement()
            ..className = 'input'
            ..type = "Cell Number"
            ..id = 'cellNum-input'
            ..placeholder = "1234567891"
        ],
      //field for address
      new VDivElement()
        ..className = 'label'
        ..text = "Address"
        ..children = [
          new VInputElement()
            ..className = 'input'
            ..type = "Address"
            ..id = 'address-input'
            ..placeholder = "US Only"
        ],
      //used for the user type dropdown menu
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
                    ..text = "Dropdown Button"
                    ..children = [
                      new VSpanElement()
                        ..className = 'icon'
                        ..children = [new Vi()..className = "fas fa-angle-down"]
                    ],
                  new VDivElement()
                    ..className = 'dropdown-menu'
                    //..id = 'dropdown-menu'
                    ..children = [
                      new VDivElement()
                        ..className = 'dropdown-content'
                        ..children = [
                          new VDivElement()
                            ..className = 'dropdown-item'
                            ..text = "Member"
                        ],
                          new VDivElement()
                            ..className = 'dropdown-item'
                            ..text = "Volunteer"
                    ]
                ]
            ]
        ]
    ];
}
