import 'dart:html' hide History;
import 'dart:convert';


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

/// [ViewMember] class / page to show a visual representation of current stored data
class ViewMember extends PComponent<ViewMemberProps> {
  ViewMember(props) : super(props);
  List<String> title = ["Last", "First", "Address", "Phone", "Start"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    List<VNode> nodeList = new List();
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
                                  new VParagraphElement()
                                    ..className = 'button has-icons-left'
                                    ..onClick = _onExportClick
                                    ..children = [
                                      new VSpanElement()
                                        ..className = 'icon'
                                        ..children = [new Vi()..className = 'fas fa-search'],
                                      new VSpanElement()..text = 'export',
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

    _onExportClick(_) {
      final userList = props.userMap.values;
      List<String> lines = <String>[];
      // Add the header row
      lines.add(userList.first.toFirestore().keys.join(',') + '\n');

      // Add a row per user
      for (User user in userList) {
      
        lines.add(user.toFirestore().values.join(',') + '\n');
      }

      Blob data = new Blob(lines, "text/csv");


      AnchorElement downloadLink = new AnchorElement(
            href: Url.createObjectUrlFromBlob(data));
        downloadLink.rel = 'text/csv';
        downloadLink.download = 'member-export-${new DateTime.now().toIso8601String()}.csv';

        var event = new MouseEvent("click", view: window, cancelable: false);
        downloadLink.dispatchEvent(event);
    }
}
