import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../core/nav.dart';
import '../../constants.dart';

import '../../model/user.dart';
import '../../model/meal.dart';

import '../../state/app.dart';
import '../../middleware/serverMiddleware.dart';

class viewMealProps {
  AppActions actions;
  User user;
  BuiltMap<String, Meal> mealMap;
}

/// [viewMeal] class / page to show a visual representation of current stored data
class viewMeal extends PComponent<viewMealProps> {
  viewMeal(props) : super(props);
  List<String> title = ["Start", "End"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    List<VNode> nodeList = new List();
    nodeList.addAll(titleRow());
    for (Meal meal in props.mealMap.values) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(meal.startTime.toString())
            ..text = checkText("${meal.startTime.month}/${meal.startTime.day}/${meal.startTime.year}"),
          new VTableCellElement()
            ..className = tdClass(meal.endTime.toString())
            ..text = checkText("${meal.endTime.month}/${meal.endTime.day}/${meal.endTime.year}"),
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
                                ..text = 'Meal Data',
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
