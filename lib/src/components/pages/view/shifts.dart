import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../core/pageRepeats.dart';
import '../../../model/user.dart';
import '../../../model/shift.dart';
import '../../../state/app.dart';
import '../../../constants.dart';

class ViewShiftProps {
  AppActions actions;
  User user;
  BuiltList<Shift> shiftList;
  bool allShifts;
  BuiltMap<String, User> userMap;
}

class ViewShiftState {
  bool searching;
  List<Shift> found;
}

/// [viewShift] class / page to show a visual representation of current stored data
class ViewShift extends Component<ViewShiftProps, ViewShiftState> {
  ViewShift(props) : super(props);
  List<String> title = ["First Name", "Last Name", "Start", "End"];
  History _history;

  @override
  ViewShiftState getInitialState() => ViewShiftState()
    ..found = <Shift>[]
    ..searching = false;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillMount() {
    if (props.user.role.toLowerCase() != "admin" && props.user.role.toLowerCase() != "volunteer") {
      history.push(Routes.dashboard);
    }
    _requestData(props.allShifts);
  }

  @override
  void componentWillUpdate(ViewShiftProps newProps, ViewShiftState newState) {
    // We have transitioned between page types
    if (props.allShifts != newProps.allShifts) {
      _requestData(newProps.allShifts);
    }
    super.componentWillUpdate(newProps, newState);
  }

  ///[_requestData] re-fetches data when it is needed
  void _requestData(bool allShifts) {
    if (allShifts && props.user.role == "admin") {
      props.actions.server.fetchAllShifts();
    } else {
      props.actions.server.fetchShiftsForUser(0);
    }
    props.actions.server.fetchAllMembers();
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
                                ..text = props.allShifts ? 'Volunteer Shift Data' : 'My Shifts',
                              new Vh1()
                                ..className = 'subtitle is-7'
                                ..text = " as of: ${formatTime(DateTime.now())}",
                            ],
                          renderSearch(_searchListener),
                          renderExport(_onExportCsvClick),
                          renderRefresh(_onRefreshClick),
                        ],
                      new VTableElement()
                        ..className = 'table is-narrow is-striped is-fullwidth'
                        ..children = _createRows(),
                    ],
                ],
            ],
        ],
    ];

  /// [_createRows] Scaling function to make rows based on amount of information available
  List<VNode> _createRows() {
    List<VNode> nodeList = new List();
    List<Shift> list;
    if (state.searching) {
      list = state.found;
    } else {
      list = props.shiftList.toList();
    }

    nodeList.addAll(titleRow(title));
    for (Shift shift in list) {
      User user = props.userMap[shift.userID];
      if (user == null) continue;
      nodeList.add(new VTableRowElement()
        ..className = 'tr tr-hoverable'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(shift.inTime.toString())
            ..text = checkText("${user?.firstName ?? 'Deleted'}"),
          new VTableCellElement()
            ..className = tdClass(shift.inTime.toString())
            ..text = checkText("${user?.lastName ?? 'Deleted'}"),
          new VTableCellElement()
            ..className = tdClass(shift.inTime.toString())
            ..text = checkText("${formatTime(shift.inTime)}"),
          new VTableCellElement()
            ..className = tdClass(shift.outTime.toString())
            ..text = checkText("${formatTime(shift.outTime)}"),
        ]);
    }
    return nodeList;
  }

  ///[_searchListener] function to ensure the table is showing data that matches the search criteria
  _searchListener() {
    InputElement search = querySelector('#Search');
    if (search.value.isEmpty) {
      setState((ViewShiftProps, ViewShiftState) => ViewShiftState
        ..found = <Shift>[]
        ..searching = false);
    } else {
      List found = <Shift>[];

      for (Shift shift in props.shiftList) {
        User user = props.userMap[shift.userID];
        if (user.firstName.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(shift);
        } else if (user.lastName.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(shift);
        } else if (shift.inTime.toString().contains(search.value)) {
          found.add(shift);
        } else if (shift.outTime.toString().contains(search.value)) {
          found.add(shift);
        } else if ("${formatTime(shift.inTime).toLowerCase()}".contains(search.value.toLowerCase())) {
          found.add(shift);
        } else if ("${formatTime(shift.outTime).toLowerCase()}".contains(search.value.toLowerCase())) {
          found.add(shift);
        }
      }

      setState((ViewShiftProps, ViewShiftState) => ViewShiftState
        ..found = found
        ..searching = true);
    }
  }

  ///[_onExportCsvClick] exports the currently shown data to a csv file
  _onExportCsvClick() {
    List<Shift> list;
    if (state.searching) {
      list = state.found;
    } else {
      list = props.shiftList.toList();
    }

    List<String> lines = list
        .map((shift) =>
            shift.toCsv(props.userMap[shift.userID].firstName ?? '', props.userMap[shift.userID].lastName ?? ''))
        .toList();

    // Add the header row
    lines.insert(0, ExportHeader.shift.join(',') + '\n');

    Blob data = new Blob(lines, "text/csv");

    AnchorElement downloadLink = new AnchorElement(href: Url.createObjectUrlFromBlob(data));
    downloadLink.rel = 'text/csv';
    downloadLink.download = 'shift-export-${new DateTime.now().toIso8601String()}.csv';

    var event = new MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }

  ///[_onRefreshClick] reloads the data for the page
  _onRefreshClick() {
    props.actions.server.fetchAllShifts();
  }
}
