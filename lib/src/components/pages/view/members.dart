import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../core/pageRepeats.dart';
import '../../../constants.dart';
import '../../../model/user.dart';
import '../../../model/activity.dart';
import '../../../state/app.dart';

class ViewMembersProps {
  AppActions actions;
  User user;
  BuiltMap<String, Activity> activityMap;
  BuiltMap<String, User> userMap;
}

class ViewMembersState {
  bool searching;
  List<User> found;
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
    ..found = <User>[]
    ..searching = false;

  List<String> title = ["Last", "First", "", ""];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

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
        ],
    ];

  /// [_createRows] Scaling function to make rows based on amount of information available
  List<VNode> _createRows() {
    List<User> users;
    List<VNode> nodeList = <VNode>[];

    if (!state.searching) {
      users = props.userMap.values.toList();
    } else {
      users = state.found;
    }
    nodeList.addAll(titleRow(title));
    //merge sort function by last name
    users = _sort(users, 0, users.length - 1);
    for (User user in users) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr tr-hoverable'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(user.lastName)
            ..text = checkText(user.lastName),
          new VTableCellElement()
            ..className = tdClass(user.firstName)
            ..text = checkText(user.firstName),
          new VTableCellElement()
            ..children = [
              new VButtonElement()
                ..className = "button is-success is-rounded is-small"
                ..onClick = ((_) => _onActClick(user.docUID))
                ..children = [
                  new VSpanElement()
                    ..className = 'icon'
                    ..children = [
                      new Vi()..className = 'far fa-check-circle',
                    ],
                  new VSpanElement()..text = 'Check In',
                ],
            ],
          new VTableCellElement()
            ..children = [
              new VButtonElement()
                ..className = "button is-rounded is-small"
                ..onClick = ((_) => _onUserClick(user.docUID))
                ..children = [
                  new VSpanElement()
                    ..className = 'icon'
                    ..children = [
                      new Vi()..className = 'far fa-eye',
                    ],
                  new VSpanElement()..text = 'View',
                ],
            ]
        ]);
    }
    return nodeList;
  }

  /// [_sort] Merge sort by last name of user
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
      renderSearch(_searchListener),
      renderExport(_onExportCsvClick),
      renderRefresh(_onRefreshClick),
    ];

  ///[_searchListener] function to ensure the table is showing data that matches the search criteria
  _searchListener() {
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
        } else if (user.emergencyContactName.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.emergencyContactNumber.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.emergencyContactRelation.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.position.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.role.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(user);
        } else if (user.services.toString().contains(search.value)) {
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

  ///[_onExportCsvClick] exports the currently shown data to a csv file
  _onExportCsvClick() {
    List<String> lines;
    if (!state.searching) {
      lines = props.userMap.values.map((user) => user.toCsv()).toList();
    } else {
      lines = state.found.map((user) => user.toCsv()).toList();
    }

    // Add the header row
    lines.insert(0, ExportHeader.user.join(',') + '\n');

    Blob data = new Blob(lines, "text/csv");

    AnchorElement downloadLink = new AnchorElement(href: Url.createObjectUrlFromBlob(data));
    downloadLink.rel = 'text/csv';
    downloadLink.download = 'member-export-${new DateTime.now().toIso8601String()}.csv';

    var event = new MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }

  ///[_onRefreshClick] reloads the data for the page
  _onRefreshClick() {
    props.actions.server.fetchAllMembers();
  }

  ///[_onUserClick] view page for specific user
  _onUserClick(String uid) {
    history.push(Routes.generateEditMemberURL(uid));
  }

  ///[_onActClick] check in function for user to activity
  _onActClick(String uid) {
    history.push(Routes.generateActivitySignUpURL(uid));
  }
}
