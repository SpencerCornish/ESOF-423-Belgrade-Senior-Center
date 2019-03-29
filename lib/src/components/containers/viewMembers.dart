import 'dart:html' hide History;

import 'dart:math';

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../core/nav.dart';
import '../../constants.dart';

import '../../model/user.dart';
import '../../model/activity.dart';

import '../../state/app.dart';

class ViewMembersProps {
  AppActions actions;
  User user;
  BuiltMap<String, Activity> activityMap;
  BuiltMap<String, User> userMap;
}

class ViewMembersState {
  bool showMod;
  Map<User, int> checkedIn;
  bool searching;
  List found;
  String modMem;
}

/// [viewMember] class / page to show a visual representation of current stored data
class ViewMembers extends Component<ViewMembersProps, ViewMembersState> {
  ViewMembers(props) : super(props);

  @override
  void componentWillMount() {
    props.actions.server.fetchAllMembers();
    props.actions.server.fetchAllActivities();
  }

  @override
  ViewMembersState getInitialState() => ViewMembersState()
    ..showMod = false
    ..checkedIn = new Map()
    ..found = <User>[]
    ..searching = false
    ..modMem = null;

  List<String> title = ["Last", "First"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [_createRows] Scaling function to make rows based on amount of information available
  List<VNode> _createRows() {
    List<User> users;
    List<VNode> nodeList = <VNode>[];

    if (!state.searching) {
      users = props.userMap.values.toList();

      //merge sort function by last name
      users = _sort(users, 0, users.length - 1);
      state.found = users;
      nodeList.addAll(_titleRow());
    }
    for (User user in state.found) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = [
          new VTableCellElement()
            ..className = _tdClass(user.lastName)
            ..onClick = ((_) => _onUserClick(user.docUID))
            ..text = _checkText(user.lastName),
          new VTableCellElement()
            ..className = _tdClass(user.firstName)
            ..onClick = ((_) => _onUserClick(user.docUID))
            ..text = _checkText(user.firstName),
          new VTableCellElement(),
          new VTableCellElement()
            ..children = [
              new VButtonElement()
                ..className = "button is-success"
                ..text = state.checkedIn.containsKey(user)
                    ? "Try ${props.activityMap.values.toList()[state.checkedIn[user]].name}"
                    : "CHECK-IN"
                ..onClick = ((_) => _checkInClick(user)),
            ]
        ]);
    }
    return nodeList;
  }

  int _recommend() {
    int index = new Random().nextInt(props.activityMap.length);

    return index;
  }

  _onUserClick(String uid) {
    history.push(Routes.generateEditMemberURL(uid));
  }

  /// [sort] Merge sort by last name of user
  List<User> _sort(List<User> users, int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;

      users = _sort(users, left, mid);
      users = _sort(users, mid + 1, right);
      users = _merge(users, left, mid, right);
    }
    return users;
  }

  /// [_merge] Helper for the sort function for merging the lists back together
  List<User> _merge(List<User> users, int left, int mid, int right) {
    List temp = new List();
    int curLeft = left, curRight = mid + 1, tempIndex = 0;
    while (curLeft <= mid && curRight <= right) {
      if (users.elementAt(curLeft).lastName.compareTo(users.elementAt(curRight).lastName) <= 0) {
        temp.insert(tempIndex, users.elementAt(curLeft));
        curLeft++;
      } else {
        temp.add(users.elementAt(curRight));
        curRight++;
      }
      tempIndex++;
    }
    while (curLeft <= mid) {
      temp.add(users.elementAt(curLeft));
      curLeft++;
      tempIndex++;
    }
    while (curRight <= right) {
      temp.add(users.elementAt(curRight));
      curRight++;
      tempIndex++;
    }
    users.replaceRange(left, right + 1, temp.getRange(0, tempIndex).whereType<User>());

    return users;
  }

  String _checkText(String text) => text != '' ? text : "N/A";

  String _tdClass(String text) => text != '' ? 'td' : "td has-text-grey";

  /// [_titleRow] helper function to create the title row
  List<VNode> _titleRow() {
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
                      _renderHeader(),
                      new VTableElement()
                        ..className = 'table is-striped is-fullwidth'
                        ..children = _createRows(),
                    ],
                ],
            ],
          //_modView(),
        ],
    ];

  ///[_renderHeader] makes the title bar of the viewMembers page
  _renderHeader() => new VDivElement()
    ..className = 'columns is-mobile'
    ..children = [
      new VDivElement()
        ..className = 'column'
        ..children = [
          new Vh4()
            ..className = 'title is-4'
            ..text = 'Member Data',
          new Vh1()
            ..className = 'subtitle is-7'
            ..text = "as of: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
        ],
      _renderSearch(),
      _renderExport(),
    ];

  ///[_renderSearch] adds the seach layout to the tile bar
  _renderSearch() => new VDivElement()
    ..className = 'column is-narrow'
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
                ..id = 'Search'
                ..onKeyUp = _searchListener
                ..type = 'text',
              new VSpanElement()
                ..className = 'icon is-left'
                ..children = [new Vi()..className = 'fas fa-search'],
            ],
        ],
    ];

  _renderExport() => new VDivElement()
    ..className = 'column is-narrow'
    ..children = [
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VDivElement()
            ..className = 'control'
            ..children = [
              new VParagraphElement()
                ..className = 'button is-rounded'
                ..onClick = _onExportCsvClick
                ..children = [
                  new VSpanElement()
                    ..className = 'icon'
                    ..children = [new Vi()..className = 'fas fa-file-csv'],
                  new VSpanElement()..text = 'CSV',
                ],
            ],
        ],
    ];

  // VNode _modView() {
  //   if (state.showMod) {
  //     User selectedUser = props.userMap[state.modMem];

  //     return (new VDivElement()
  //       ..className = "modal ${state.showMod ? 'is-active' : ''}"
  //       ..children = [
  //         new VDataListElement()..className = "modal-background",
  //         new VDivElement()
  //           ..className = "modal-card"
  //           ..children = [
  //             new VHeadElement()
  //               ..className = "modal-card-head"
  //               ..children = [
  //                 new VParagraphElement()
  //                   ..className = "modal-card-title"
  //                   ..text = "Welcome ${selectedUser.firstName} ${selectedUser.lastName}",
  //                 new VButtonElement()
  //                   ..className = 'delete'
  //                   ..onClick = _modOff,
  //               ],
  //             new Vsection()
  //               ..className = "modal-card-body"
  //               ..children = [
  //                 new VButtonElement()
  //                   ..className = "button is-success"
  //                   ..text = state.checkedIn ? "DONE" : "CHECK-IN"
  //                   ..onClick = ((_) => _checkInClick(selectedUser)),
  //               ],
  //           ],
  //       ]);
  //   }
  //   return new VDivElement();
  // }

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
        } else if ("${user.membershipRenewal.month}/${user.membershipRenewal.day}/${user.membershipRenewal.year}"
            .contains(search.value)) {
          found.add(user);
        } else if ("${user.membershipStart.month}/${user.membershipStart.day}/${user.membershipStart.year}"
            .contains(search.value)) {
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

  _checkInClick(User user) {
    if (!state.checkedIn.containsKey(user)) {
      print("${user.firstName} ${user.lastName} has checked in!");
      setState((props, state) => state..checkedIn.putIfAbsent(user, () => _recommend()));
    } else {
      setState((props, state) => state
        ..showMod = false
        ..modMem = null);
    }
  }

  _modOn(String uid) {
    setState((props, state) => state
      ..showMod = true
      ..modMem = uid);
  }

  _modOff(_) {
    setState((props, state) => state
      ..showMod = false
      ..modMem = null);
  }

  _onExportCsvClick(_) {
    List<String> lines = props.userMap.values.map((user) => user.toCsv()).toList();

    // Add the header row
    lines.insert(0, ExportHeader.user.join(',') + '\n');

    Blob data = new Blob(lines, "text/csv");

    AnchorElement downloadLink = new AnchorElement(href: Url.createObjectUrlFromBlob(data));
    downloadLink.rel = 'text/csv';
    downloadLink.download = 'member-export-${new DateTime.now().toIso8601String()}.csv';

    var event = new MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }
}
