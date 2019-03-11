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
////////////////////////////////////////////////////////////////////////////
//..defaultValue
//button with onclick to change from paragraph element to prefilled text box
////////////////////////////////////////////////////////////////////////////

class EditMemberState {
  bool edit;
}

/// [EditMember] class / page to allow user information to be changed for a given user by uid
class EditMember extends Component<EditMemberProps, EditMemberState> {
  EditMember(props) : super(props);

  @override
  EditMemberState getInitialState() => EditMemberState()..edit = false;

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

  List<VNode> _pageElements(User user) {
    List<VNode> nodeList = <VNode>[];
    state.edit ? nodeList.addAll(_renderEditHeader(user)) : nodeList.add(_renderHeader(user));
    nodeList.add(_renderAddress(user));
    nodeList.addAll(_renderNumberHeaders(user));
    return nodeList;
  }

  List<VNode> _renderEditHeader(User user) {
    List<VNode> nodeList = <VNode>[];
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile is-offset-1'
      ..children = [
        new VDivElement()
          ..className = 'column is-narrow'
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
            new VLabelElement()
              ..className = "label"
              ..text = "Last Name: ",
            new VLabelElement()
              ..className = "label"
              ..text = "Preferred Name: ",
          ],
        new VDivElement()
          ..className = 'column is-half'
          ..children = [
            new VDivElement()
              ..className = "control"
              ..children = [
                new VInputElement()
                  ..className = "input"
                  ..defaultValue = _checkText(user.firstName),
                new VInputElement()
                  ..className = "input"
                  ..defaultValue = _checkText(user.lastName),
                new VInputElement()
                  ..className = "input"
                  ..defaultValue = _checkText(user.firstName),
              ],
          ],
        new VDivElement()..className = 'column',
        new VDivElement()
          ..className = 'column is-1'
          ..children = [
            state.edit ? _renderSubmit() : _renderEdit(),
          ],
      ]);
    return nodeList;
  }

  ///[_renderHeader] makes the title bar of the editMember page
  _renderHeader(User user) => new VDivElement()
    ..className = 'columns is-mobile'
    ..children = [
      new VDivElement()
        ..className = 'column is-narrow'
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
        ..className = 'column is-1'
        ..children = [
          state.edit ? _renderSubmit() : _renderEdit(),
        ],
    ];

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
                ..defaultValue = _checkText(user.address)
                ..readOnly = !state.edit,
            ],
        ],
    ];

  List<VNode> _renderNumberHeaders(User user) {
    List<VNode> nodeList = <VNode>[];
    nodeList.add(new VDivElement()
      ..className = 'columns is-mobile is-centered is-vcentered'
      ..children = [
        new VDivElement()
          ..className = 'column'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Home Phone",
          ],
        new VDivElement()
          ..className = 'column'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Cell or Messsage Phone",
          ],
        new VDivElement()
          ..className = 'column'
          ..children = [
            new VLabelElement()
              ..className = 'label'
              ..text = "Email Address",
          ],
      ]);
    nodeList.add(_renderNumbers(user));
    return nodeList;
  }

  _renderNumbers(User user) => new VDivElement()
    ..className = 'columns is-mobile is-centered is-vcentered'
    ..children = [
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..defaultValue = _checkText(user.phoneNumber)
                ..readOnly = !state.edit,
            ],
        ],
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..defaultValue = _checkText(user.mobileNumber)
                ..readOnly = !state.edit,
            ],
        ],
      new VDivElement()
        ..className = 'column'
        ..children = [
          new VDivElement()
            ..className = "control"
            ..children = [
              new VInputElement()
                ..className = "input ${state.edit ? '' : 'is-static'}"
                ..defaultValue = _checkText(user.email)
                ..readOnly = !state.edit,
            ],
        ],
    ];

//   List<VNode> _renderRefsHeader(User user) {
//     List<VNode> nodeList = <VNode>[];
//     for (EmergencyContact ref in user.emergencyContacts) {
//       nodeList.add(new VDivElement()
//         ..className = 'columns is-mobile is-centered is-vcentered'
//         ..children = [
//           new VDivElement()
//             ..className = 'column'
//             ..children = [
//               new VDivElement()
//                 ..className = "control"
//                 ..children = [
//                   new VInputElement()
//                     ..className = "input" + _inputClass()
//                     ..defaultValue = _checkText(ref.toString()),
//                 ],
//             ],
//         ]);
//     }
//     return nodeList;
//   }
//   //not quite, columns wrong
//   List<VNode> _renderRefs(User user) {
//     List<VNode> nodeList = <VNode>[];
//     for (EmergencyContact ref in user.emergencyContacts) {
//       nodeList.add(new VDivElement()
//         ..className = 'columns is-mobile is-centered is-vcentered'
//         ..children = [
//           new VDivElement()
//             ..className = 'column'
//             ..children = [
//               new VDivElement()
//                 ..className = "control"
//                 ..children = [
//                   new VInputElement()
//                     ..className = "input" + _inputClass()
//                     ..defaultValue = _checkText(ref.toString()),
//                 ],
//             ],
//         ]);
//     }
//     return nodeList;
//   }

  String _checkText(String text) => text != '' ? text : "N/A";

  // String _inputClass() => edit ? 'is_static' : "";

  _renderEdit() => new VDivElement()
    ..className = 'control'
    ..children = [
      new VAnchorElement()
        ..className = 'button is-link'
        ..text = "Edit"
        ..onClick = _editClick
    ];

  _editClick(_) {
    setState((props, state) => state..edit = !state.edit);
  }

  // create the submit button
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
  }

  _renderUserNotFound() => new VDivElement()..text = 'not found!';
}
