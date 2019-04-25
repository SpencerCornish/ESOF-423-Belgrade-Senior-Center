import 'dart:html' hide History;

import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../core/pageRepeats.dart';
import '../../../model/user.dart';
import '../../../model/meal.dart';
import '../../../state/app.dart';
import '../../../constants.dart';

///[ViewMealProps] class of passed in variables for the view meals page
class ViewMealProps {
  AppActions actions;
  User user;
  BuiltMap<String, Meal> mealMap;
}

///[ViewMealSate] variable class to hold state change variables for the viewMeals page
class ViewMealState {
  bool searching;
  List<Meal> found;
}

/// [viewMeal] class / page to show a visual representation of current stored data
class ViewMeal extends Component<ViewMealProps, ViewMealState> {
  ViewMeal(props) : super(props);
  List<String> title = ["Serving", "Date and Time", " "];
  History _history;

  //set states on page load
  @override
  ViewMealState getInitialState() => ViewMealState()
    ..found = <Meal>[]
    ..searching = false;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  //fetch meal data on page load
  @override
  void componentWillMount() {
    props.actions.server.fetchAllMeals();
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
                        ..className = 'table is-narrow is-striped is-fullwidth'
                        ..children = _createRows(),
                    ],
                ],
            ],
        ],
    ];

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> _createRows() {
    List<Meal> meals;
    List<VNode> nodeList = new List();
    if (!state.searching) {
      meals = props.mealMap.values.toList();
    } else {
      meals = state.found;
    }
    meals = _sort(meals, 0, meals.length - 1);
    nodeList.addAll(titleRow(title));
    for (Meal meal in meals) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr tr-hoverable'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(_menuSubstring(meal.menu.toString()))
            ..text = checkText(_menuSubstring(meal.menu.toString())),
          new VTableCellElement()
            ..className = tdClass(meal.startTime.toString())
            ..text = formatTimeRange(meal.startTime, meal.endTime),
          new VTableCellElement()
            ..children = [
              new VButtonElement()
                ..className = "button is-rounded is-small"
                ..onClick = ((_) => _onMealClick(meal.uid))
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
  List<Meal> _sort(List<Meal> meal, int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;

      meal = _sort(meal, left, mid);
      meal = _sort(meal, mid + 1, right);
      meal = _merge(meal, left, mid, right);
    }
    return meal;
  }

  /// [_merge] Helper for the sort function for merging the lists back together
  List<Meal> _merge(List<Meal> meal, int left, int mid, int right) {
    List temp = new List();
    int curLeft = left, curRight = mid + 1, tempIndex = 0;
    while (curLeft <= mid && curRight <= right) {
      if (meal.elementAt(curLeft).startTime.compareTo(meal.elementAt(curRight).startTime) <= 0) {
        temp.insert(tempIndex, meal.elementAt(curLeft));
        curLeft++;
      } else {
        temp.add(meal.elementAt(curRight));
        curRight++;
      }
      tempIndex++;
    }
    while (curLeft <= mid) {
      temp.add(meal.elementAt(curLeft));
      curLeft++;
      tempIndex++;
    }
    while (curRight <= right) {
      temp.add(meal.elementAt(curRight));
      curRight++;
      tempIndex++;
    }
    meal.replaceRange(left, right + 1, temp.getRange(0, tempIndex).whereType<Meal>());

    return meal;
  }

  ///[_menuSubstring] helper function to display the menu list item as a short string for table view
  String _menuSubstring(String menu) {
    if (menu.length <= 15) {
      return menu.substring(1, menu.length - 1);
    } else {
      return menu.substring(1, 15);
    }
  }

  ///[_renderHeader] makes the title bar of the viewMeals page
  _renderHeader() => new VDivElement()
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
            ..text = " as of: ${formatTime(DateTime.now())}",
        ],
      renderSearch(_searchListener),
      renderExport(_onExportCsvClick),
      renderRefresh(_onRefreshClick),
    ];

  ///[_searchListener] function to ensure the table is showing data that matches the search criteria
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
        } else if (formatDate(meal.startTime, [m, "/", d, "/", yyyy]).contains(search.value)) {
          found.add(meal);
        } else if (meal.startTime.toString().contains(search.value)) {
          found.add(meal);
        } else if (formatDate(meal.endTime, [m, "/", d, "/", yyyy]).contains(search.value)) {
          found.add(meal);
        } else if (formatTimeRange(meal.startTime, meal.endTime).toLowerCase().contains(search.value)) {
          found.add(meal);
        }

        setState((ViewMealProps, ViewMealState) => ViewMealState
          ..found = found
          ..searching = true);
      }
    }
  }

  ///[_onExportCsvClick] exports the currently shown data to a csv file
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

  ///[_onRefreshClick] reloads the data for the page
  _onRefreshClick(_) {
    props.actions.server.fetchAllMeals();
  }

  ///[_onUserClick] view page for specific meal
  _onMealClick(String uid) {
    history.push(Routes.generateEditMealURL(uid));
  }
}
