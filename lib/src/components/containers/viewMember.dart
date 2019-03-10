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

class viewMemberProps {
  AppActions actions;
  User user;
  BuiltMap<String, User> userMap;
}

/// [viewMember] class / page to show a visual representation of current stored data
class viewMember extends PComponent<viewMemberProps> {
  viewMember(props) : super(props);
  List users;
  List<String> title = ["Last", "First", "Address", "Phone", "Start"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    users = props.userMap.values.toList();
    //merge sort function by last name
    sort(0, users.length - 1);
    List<VNode> nodeList = new List();
    nodeList.addAll(titleRow());
    for (User user in users) {
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
  }

  /// [sort] Merge sort by last name of user
  void sort(int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;

      sort(left, mid);
      sort(mid + 1, right);
      merge(left, mid, right);
      for (User user in users) {
        print(user.lastName);
      }
    }
  }

  /// [merge] Helper for the sort function for merging the lists back together
  void merge(int left, int mid, int right) {
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
}
