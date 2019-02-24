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

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [createCol] Scaling function for width based on number of types of info
  List<VNode> createCol() {
    List<VNode> nodeList = new List();
    // TODO : for each collection item in current row make a colomn element
    List<String> items = ["bob", "57"];
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
    nodeList.add(titleRow());
    // TODO for each user/meal/activity create a row
    for (var i = 0; i < 2; i++) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = createCol());
    }
    return nodeList;
  }

  /// [titleRow] helper function to create the title row
  VNode titleRow() {
    // TODO : for each collection item in current row make a colomn element by collection type
    return (new VTableRowElement()
      ..className = 'tr'
      ..children = [
        new VTableCellElement()
          ..className = 'title is-5'
          ..text = "ID",
        new VTableCellElement()
          ..className = 'title is-5'
          ..text = "Name",
      ]);
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
            ..className = 'columns'
            ..children = [
              new VDivElement()
                ..className = 'column is-full is centered'
                ..children = [
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      new VDivElement()
                        ..className = 'column is-3 is-offset-8'
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
                      new VDivElement()..className = 'column is-1',
                    ],
                  new VDivElement()
                    ..className = 'columns is-mobile'
                    ..children = [
                      new VDivElement()
                        ..className = 'column is-offset-1-mobile is-offset-1-tablet'
                        ..children = [
                          new VTableElement()
                            ..className = 'table is-striped is-fullwidth'
                            ..children = createRows(),
                        ],
                      new VDivElement()..className = 'column is-1',
                    ],
                ],
            ],
        ],
    ];
}
