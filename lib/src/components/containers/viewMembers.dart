import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../core/nav.dart';
import '../../constants.dart';

import '../../model/user.dart';
import './editMember.dart';

import '../../state/app.dart';
import '../../middleware/serverMiddleware.dart';

class ViewMembersProps {
  AppActions actions;
  User user;
  BuiltMap<String, User> userMap;
}

/// [viewMember] class / page to show a visual representation of current stored data
class ViewMembers extends PComponent<ViewMembersProps> {
  ViewMembers(props) : super(props);

  List<String> title = ["Last", "First"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [_createRows] Scaling function to make rows based on amount of information available
  List<VNode> _createRows() {
    List<User> users = props.userMap.values.toList();

    //merge sort function by last name
    users = _sort(users, 0, users.length - 1);
    List<VNode> nodeList = <VNode>[];
    nodeList.addAll(_titleRow());
    for (User user in users) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..onClick = ((_) => _onUserClick(user.docUID))
        ..children = [
          new VTableCellElement()
            ..className = _tdClass(user.lastName)
            ..text = _checkText(user.lastName),
          new VTableCellElement()
            ..className = _tdClass(user.firstName)
            ..text = _checkText(user.firstName),
        ]);
    }
    return nodeList;
  }

  _onUserClick(String uid) => history.push(Routes.generateEditMemberURL(uid));

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
        ],
    ];

  ///[_renderHeader] makes the title bar of the viewMembers page
  _renderHeader() => new VDivElement()
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
            ..text = "as of: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
        ],
      new VDivElement()..className = 'column',
      _renderSearch(),
    ];

  ///[_renderSearch] adds the seach layout to the tile bar
  _renderSearch() => new VDivElement()
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
                ..type = 'text',
              new VSpanElement()
                ..className = 'icon is-left'
                ..children = [new Vi()..className = 'fas fa-search'],
            ],
        ],
    ];
}
