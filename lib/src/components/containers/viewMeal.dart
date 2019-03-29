import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../core/nav.dart';

import '../../model/user.dart';
import '../../model/meal.dart';

import '../../state/app.dart';
import '../../constants.dart';

class ViewMealProps {
  AppActions actions;
  User user;
  BuiltMap<String, Meal> mealMap;
}

class ViewMealState {
  bool searching;
  List<Meal> found;
}

/// [viewMeal] class / page to show a visual representation of current stored data
class ViewMeal extends Component<ViewMealProps, ViewMealState> {
  ViewMeal(props) : super(props);
  List<String> title = ["Date", "Start Time", "End Time"];
  History _history;

  @override
  ViewMealState getInitialState() => ViewMealState()
    ..found = <Meal>[]
    ..searching = false;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillMount() {
    props.actions.server.fetchAllMeals();
  }

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    List<Meal> meals;
    List<VNode> nodeList = new List();
    if (!state.searching) {
      meals = props.mealMap.values.toList();
    } else {
      meals = state.found;
    }
    nodeList.addAll(titleRow());
    for (Meal meal in meals) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..onClick = ((_) => _onMealClick(meal.uid))
        ..children = [
          new VTableCellElement()
            ..className = tdClass(meal.startTime.toString())
            ..text = checkText("${meal.startTime.month}/${meal.startTime.day}/${meal.startTime.year}"),
          new VTableCellElement()
            ..className = "time"
            ..text = _showTime(meal.startTime.hour.toString(), meal.startTime.minute.toString()),
          //checkText("${meal.startTime.hour}:${meal.startTime.minute}"),
          new VTableCellElement()
            ..className = tdClass(meal.endTime.toString())
            ..text = _showTime(meal.endTime.hour.toString(), meal.endTime.minute.toString()),
        ]);
    }
    return nodeList;
  }

  ///[_showTime] helper function to put a time into a proper format to view in a time type input box
  String _showTime(String hour, String min) {
    if (hour.length == 1) {
      hour = "0${hour}";
    }

    if (min.length == 1) {
      min = "0${min}";
    }
    return hour + ":" + min;
  }

  _onMealClick(String uid) {
    history.push(Routes.generateEditMealURL(uid));
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
                            ..className = 'column'
                            ..children = [
                              new Vh4()
                                ..className = 'title is-4'
                                ..text = 'Meal Data',
                              new Vh1()
                                ..className = 'subtitle is-7'
                                ..text = " as of: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
                            ],
                          new VDivElement()
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
                            ],
                          new VDivElement()
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

  _searchListener(_) {
    InputElement search = querySelector('#Search');
    if (search.value.isEmpty) {
      setState((ViewMealProps, ViewMealState) => ViewMealState
        ..found = <Meal>[]
        ..searching = false);
    } else {
      List found = <Meal>[];

      for (Meal meal in props.mealMap.values) {
        for (String menuItem in meal.menu) {
          if (menuItem.toLowerCase().contains(search.value.toLowerCase())) {
            found.add(meal);
            break;
          }
        }
        if (meal.endTime.toString().contains(search.value)) {
          found.add(meal);
        } else if ("${meal.endTime.month}/${meal.endTime.day}/${meal.endTime.year}".contains(search.value)) {
          found.add(meal);
        } else if (meal.startTime.toString().contains(search.value)) {
          found.add(meal);
        } else if ("${meal.startTime.month}/${meal.startTime.day}/${meal.startTime.year}".contains(search.value)) {
          found.add(meal);
        }

        setState((ViewMealProps, ViewMealState) => ViewMealState
          ..found = found
          ..searching = true);
      }
    }
  }

  _onExportCsvClick(_) {
    List<String> lines;
    if (!state.searching) {
      lines = props.mealMap.values.map((meal) => meal.toCsv()).toList();
    } else {
      lines = state.found.map((meal) => meal.toCsv()).toList();
    }

    // Add the header row
    lines.insert(0, ExportHeader.meal.join(',') + '\n');

    Blob data = new Blob(lines, "text/csv");

    AnchorElement downloadLink = new AnchorElement(href: Url.createObjectUrlFromBlob(data));
    downloadLink.rel = 'text/csv';
    downloadLink.download = 'meal-export-${new DateTime.now().toIso8601String()}.csv';

    var event = new MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }
}
