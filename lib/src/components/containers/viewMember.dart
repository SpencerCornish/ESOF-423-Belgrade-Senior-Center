import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../core/nav.dart';
import '../../constants.dart';

import '../../model/user.dart';

import '../../state/app.dart';
import '../../middleware/serverMiddleware.dart';

class ViewMemberProps {
  AppActions actions;
  User user;
  BuiltMap<String, User> userMap;
}

class ViewMembersState {
  bool showMod;
  bool checkedIn;
  bool searching;
  List found;
  String modMem;
}

/// [viewMember] class / page to show a visual representation of current stored data
class viewMember extends Component<ViewMemberProps, ViewMembersState> {
  viewMember(props) : super(props);
  List<String> title = ["Last", "First", "Address", "Phone", "Start"];
  History _history;

  @override
  void componentWillUpdate(ViewMemberProps nextProps, ViewMembersState nextState) {
    super.componentWillUpdate(nextProps, nextState);
  }

  @override
  ViewMembersState getInitialState() => ViewMembersState()
    ..showMod = false
    ..checkedIn = false
    ..searching = false
    ..found = <User>[]
    ..modMem = null;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    if (!state.searching) {
      // List<User> users = props.userMap.values.toList();

      //merge sort function by last name
      // users = _sort(users, 0, users.length - 1);
      List<VNode> nodeList = <VNode>[];
      nodeList.addAll(titleRow());
      for (User user in props.userMap.values) {
        nodeList.add(new VTableRowElement()
          ..className = 'tr'
          ..children = [
            new VTableCellElement()
              ..className = tdClass(user.lastName)
              ..text = checkText(user.lastName),
            new VTableCellElement()
              ..className = tdClass(user.firstName)
              ..text = checkText(user.firstName),
            new VTableCellElement()
              ..className = tdClass(user.address)
              ..text = checkText(user.address),
            new VTableCellElement()
              ..className = tdClass(user.phoneNumber)
              ..text = checkText(user.phoneNumber),
            new VTableCellElement()
              ..className = tdClass(user.membershipStart.toString())
              ..text =
                  checkText("${user.membershipStart.month}/${user.membershipStart.day}/${user.membershipStart.year}"),
          ]);
      }
      return nodeList;
    } else {
      return _renderSearch();
    }
  }

  String checkText(String text) => text != '' ? text : "N/A";

  String tdClass(String text) => text != '' ? 'td' : "td has-text-grey";

  /// [titleRow] helper function to create the title row
  List<VNode> titleRow() {
    List<VNode> nodeList = new List();
    for (String title in title) {
      nodeList.add(
        new VTableCellElement()
          ..className = 'title is-5'
          ..text = title,
      );
    }
    return nodeList;
  }

  @override
  VNode render() => new VDivElement()
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
                    ..children = [
                      new VDivElement()
                        ..className = 'columns is-mobile'
                        ..children = [
                          new VDivElement()
                            ..className = 'column is-narrow'
                            ..children = [
                              new Vh4()
                                ..className = 'title is-4'
                                ..text = 'Member Data',
                              new Vh1()
                                ..className = 'subtitle is-7'
                                ..text = " as of: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
                            ],
                          new VDivElement()..className = 'column',
                          new VDivElement()
                            ..className = 'column is-4'
                            ..children = [
                              new VDivElement()
                                ..className = 'field'
                                ..children = [
                                  new VParagraphElement()
                                    ..className = 'control has-icons-left'
                                    ..children = [
                                      new VInputElement()
                                        ..className = 'input'
                                        ..placeholder = 'Search'
                                        ..type = 'submit'
                                        ..id = 'Search'
                                        ..onKeyUp = _searchListener
                                        ..type = 'text',
                                      new VSpanElement()
                                        ..className = 'icon is-left'
                                        ..children = [new Vi()..className = 'fas fa-search'],
                                    ],
                                ],
                            ],
                        ],
                      new VTableElement()
                        ..className = 'table is-narrow is-striped is-fullwidth'
                        ..children = createRows(),
                    ],
                ],
            ],
        ],
    ];

  List<VNode> _renderSearch() {
    List<VNode> nodeList = <VNode>[];
    nodeList.addAll(titleRow());
    for (User user in state.found) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(user.lastName)
            ..text = checkText(user.lastName),
          new VTableCellElement()
            ..className = tdClass(user.firstName)
            ..text = checkText(user.firstName),
        ]);
    }
    return nodeList;
  }

  _searchListener(_) {
    InputElement search = querySelector('#Search');
    if (search.value.isEmpty) {
      setState((ViewMemberProps, ViewMembersState) => ViewMembersState
        ..found = <User>[]
        ..searching = false);
    } else {
      List found = <User>[];

      for (User user in props.userMap.values) {
        if (user.firstName.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.lastName.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.address.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.dietaryRestrictions.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.disabilities.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.email.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.medicalIssues.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.mobileNumber.contains(search.value)) {
          found.add(user);
        } else if (user.phoneNumber.contains(search.value)) {
          found.add(user);
        } else if (user.position.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.role.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.services.contains(search.value)) {
          found.add(user);
        } else if (user.membershipRenewal.toString().contains(search.value)) {
          found.add(user);
        } else if (user.membershipStart.toString().contains(search.value)) {
          found.add(user);
        }
      }

      setState((ViewMemberProps, ViewMembersState) => ViewMembersState
        ..found = found
        ..searching = true);
    }
  }
}
