import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../core/nav.dart';
import '../../constants.dart';

import '../../model/user.dart';

import '../../state/app.dart';
import '../../middleware/serverMiddleware.dart';

class StoredDataProps {
  AppActions actions;
  User user;
}

/// [StoredData] class / page to show a visual representation of current stored data
class StoredData extends PComponent<StoredDataProps> {
  StoredData(props) : super(props);
  // TODO : change to props of actual data
  List<String> items = ["bob", "57", "15589", 'this thing', "bob", "57", "15589", 'this thing', "15589"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [createCol] Scaling function for width based on number of types of info
  List<VNode> createCol() {
    List<VNode> nodeList = new List();
    for (var item in items) {
      nodeList.add(
        new VTableCellElement()
          ..className = 'td'
          ..text = item,
      );
    }
    return nodeList;
  }

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    List<VNode> nodeList = new List();
    nodeList.addAll(titleRow());
    for (var i = 0; i < 16; i++) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = createCol());
    }
    return nodeList;
  }

  /// [titleRow] helper function to create the title row
  List<VNode> titleRow() {
    List<VNode> nodeList = new List();
    int i = 0;
    //TODO: get prop attribute to set as title
    for (var item in items) {
      i++;
      nodeList.add(
        new VTableCellElement()
          ..className = 'title is-4'
          ..text = "Title " + i.toString(),
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
                    ..className = 'columns is-mobile'
                    ..children = [
                      new VDivElement()
                        ..className = 'column'
                        ..children = [
                          new Vh1()
                            ..className = 'title'
                            ..text = 'Stored Data as of: ' + DateTime.now().toString().split(" ")[0],
                        ],
                    ],
                  new VDivElement()
                    ..className = 'columns is-mobile is-centered'
                    ..children = [
                      new VDivElement()
                        ..className = 'buttons are-medium'
                        ..children = [
                          new VDivElement()
                            ..className = 'column'
                            ..children = [
                              new Va()
                                ..className = 'button'
                                ..text = 'Users'
                            ],
                          new VDivElement()
                            ..className = 'column'
                            ..children = [
                              new Va()
                                ..className = 'button'
                                ..text = 'Activity',
                            ],
                          new VDivElement()
                            ..className = 'column'
                            ..children = [
                              new Va()
                                ..className = 'button'
                                ..text = 'Meals',
                            ],
                        ],
                    ],
                  new VDivElement()
                    ..className = 'box'
                    ..children = [
                      new VDivElement()
                        ..className = 'field'
                        ..children = [
                          new VParagraphElement()
                            ..className = 'control has-icons-left'
                            ..children = [
                              new VInputElement()
                                ..className = 'input'
                                ..placeholder = 'Filter'
                                ..type = 'text',
                              new VSpanElement()
                                ..className = 'icon is-left'
                                ..children = [new Vi()..className = 'fas fa-search'],
                            ],
                        ],
                      new VTableElement()
                        ..className = 'table is-striped is-fullwidth'
                        ..children = createRows(),
                    ],
                ],
            ],
        ],
    ];
}
