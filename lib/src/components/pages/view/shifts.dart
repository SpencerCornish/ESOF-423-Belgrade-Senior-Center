import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../../model/user.dart';
import '../../../model/shift.dart';
import '../../../state/app.dart';
import '../../../constants.dart';

class ViewShiftProps {
  AppActions actions;
  User user;
  BuiltList<Shift> shiftList;
  bool allShifts;
}

/// [viewShift] class / page to show a visual representation of current stored data
class ViewShift extends PComponent<ViewShiftProps> {
  ViewShift(props) : super(props);
  List<String> title = ["User ID (Name coming soon)", "Start", "End"];
  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillMount() {
    if (props.user.role.toLowerCase() != "admin" && props.user.role.toLowerCase() != "volunteer") {
      history.push(Routes.dashboard);
    }
    if (props.allShifts && props.user.role == "admin") {
      props.actions.server.fetchAllShifts();
    } else {
      props.actions.server.fetchShiftsForUser(0);
    }
  }

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    List<VNode> nodeList = new List();
    nodeList.addAll(titleRow());
    for (Shift shift in props.shiftList) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(shift.inTime.toString())
            ..text = checkText("${shift.userID}"),
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
                                ..text = props.allShifts ? 'Volunteer Shift Data' : 'My Shifts',
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
                                          new VSpanElement()..text = 'Export',
                                        ],
                                    ],
                                ],
                            ],
                          _renderRefresh(),
                        ],
                      new VTableElement()
                        ..className = 'table is-narrow is-striped is-fullwidth'
                        ..children = createRows(),
                    ],
                ],
            ],
        ],
    ];

  _renderRefresh() => new VDivElement()
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
                ..onClick = _onRefreshClick
                ..children = [
                  new VSpanElement()
                    ..className = 'icon'
                    ..children = [new Vi()..className = 'fas fa-sync-alt'],
                  new VSpanElement()..text = 'Refresh',
                ],
            ],
        ],
    ];

  _onExportCsvClick(_) {
    // TODO: Add first and last name, fuh real
    List<String> lines = props.shiftList.map((meal) => meal.toCsv("FIRST", "LAST")).toList();

    // Add the header row
    lines.insert(0, ExportHeader.meal.join(',') + '\n');

    Blob data = new Blob(lines, "text/csv");

    AnchorElement downloadLink = new AnchorElement(href: Url.createObjectUrlFromBlob(data));
    downloadLink.rel = 'text/csv';
    downloadLink.download = 'shift-export-${new DateTime.now().toIso8601String()}.csv';

    var event = new MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }

  _onRefreshClick(_) {
    props.actions.server.fetchAllShifts();
  }
}
