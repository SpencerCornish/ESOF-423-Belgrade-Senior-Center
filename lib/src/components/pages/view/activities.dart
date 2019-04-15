import 'dart:html' hide History;
import 'dart:math';

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../../model/activity.dart';
import '../../../model/user.dart';
import '../../../state/app.dart';
import '../../../constants.dart';

///[ViewActivityProps] class of passed in values
class ViewActivityProps {
  AppActions actions;
  User user;
  bool signUp;
  BuiltMap<String, Activity> activityMap;
  String selectedMemberUID;
}

///[ViewActivityState] class of page state values
class ViewActivityState {
  bool searching;
  List<Activity> found;
  bool showMod;
  bool repeatFound;
}

/// [viewActivity] class / page to show a visual representation of current stored data
class ViewActivity extends Component<ViewActivityProps, ViewActivityState> {
  ViewActivity(props) : super(props);
  List<String> title = ["Name", "Date", "Time", "Location", ""];
  History _history;

  @override
  ViewActivityState getInitialState() => ViewActivityState()
    ..found = <Activity>[]
    ..searching = false
    ..repeatFound = false
    ..showMod = false;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  void componentWillMount() {
    props.actions.server.fetchAllActivities();
  }

  VNode emailInputNode;
  VNode passwordInputNode;

  /// [createRows] Scaling function to make rows based on amount of information available
  List<VNode> createRows() {
    List<Activity> activities;
    List<VNode> nodeList = new List();
    if (!state.searching) {
      activities = props.activityMap.values.toList();
    } else {
      activities = state.found;
    }
    nodeList.addAll(titleRow());
    for (Activity act in activities) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        //..onClick = ((_) => _onActClick(act.uid))
        ..children = [
          new VTableCellElement()
            ..className = tdClass(act.name)
            ..text = checkText(act.name),
          new VTableCellElement()
            ..className = tdClass(act.startTime.toString())
            ..text = checkText("${act.startTime.month}/${act.startTime.day}/${act.startTime.year}"),
          new VTableCellElement()
            ..className = tdClass(act.endTime.toString())
            ..text =
                "${_showTime(act.startTime.hour, act.startTime.minute.toString())} - ${_showTime(act.endTime.hour, act.endTime.minute.toString())}",
          new VTableCellElement()
            ..className = tdClass(act.location)
            ..text = checkText(act.location),
          _renderButton(act.uid),
        ]);
    }
    return (nodeList);
  }

  ///[_renderButton] choice function to render either the view or check in button on sign up state
  _renderButton(String uid) {
    if (props.signUp) {
      return (new VTableCellElement()
        ..children = [
          new VButtonElement()
            ..className = "button is-success is-rounded"
            ..onClick = ((_) => _onCheckClick(uid))
            ..children = [
              new VSpanElement()
                ..className = 'icon'
                ..children = [
                  new Vi()..className = 'far fa-check-circle',
                ],
              new VSpanElement()..text = 'Check In',
            ],
        ]);
    } else {
      return (new VTableCellElement()
        ..children = [
          new VButtonElement()
            ..className = "button is-rounded"
            ..onClick = ((_) => _onActClick(uid))
            ..children = [
              new VSpanElement()
                ..className = 'icon'
                ..children = [
                  new Vi()..className = 'far fa-eye',
                ],
              new VSpanElement()..text = 'View',
            ],
        ]);
    }
  }

  ///[_onActClick] button listener to view a class through redirect
  _onActClick(String uid) {
    history.push(Routes.generateEditActivityURL(uid));
  }

  ///[_onCheckClick] button listener to check into a class and show the modal
  _onCheckClick(String uid) {
    Activity act = props.activityMap[uid];

    state.repeatFound = false;

    for (String id in act.users) {
      if (props.selectedMemberUID.compareTo(id) == 0) {
        setState((ViewActivityProps, ViewActivityState) => ViewActivityState..repeatFound = true);
        break;
      }
    }

    if (!state.repeatFound) {
      props.actions.server
          .updateOrCreateActivity(act.rebuild((builder) => builder..users.add(props.selectedMemberUID)));
      props.actions.server.fetchAllActivities();
    }

    setState((ViewActivityProps, ViewActivityState) => ViewActivityState..showMod = true);
  }

  ///[_renderAddInfoMod] modal to tell user the outcome of class sign up and suggest additional classes
  VNode _renderAddInfoMod() {
    if (props.signUp) {
      return (new VDivElement()
        ..className = "modal ${state.showMod ? 'is-active' : ''}"
        ..children = [
          new VDivElement()..className = 'modal-background',
          new VDivElement()
            ..className = 'modal-card'
            ..children = [
              new Vsection()
                ..className = 'modal-card-head'
                ..children = [
                  new VParagraphElement()
                    ..className = 'title is-4'
                    ..text = '${state.repeatFound ? 'Already Checked-in' : 'Checked-in Successfully!'}'
                ],
              new Vsection()
                ..className = 'modal-card-body'
                ..children = [_trySomething()],
              new Vfooter()
                ..className = 'modal-card-foot'
                ..children = [
                  new VButtonElement()
                    ..className = 'button is-rounded'
                    ..text = 'Done'
                    ..onClick = _doneCheckinClick
                ],
            ],
        ]);
    }
    return new VParagraphElement();
  }

  ///[_doneCheckinClick] returns to viewMembers page for the next check in
  _doneCheckinClick(_) {
    history.push(Routes.viewMembers);
  }

  ///[_trySomething] suggestion function to prompt the members to check in for a diffferent class in addition
  VNode _trySomething() {
    //all posible activities
    List<Activity> actList = props.activityMap.values.toList();
    //get a random index up to the length of the list - 1 to get a random activity
    int tryIndex = new Random().nextInt(actList.length - 1);

    return new VTableElement()
      ..className = 'table is-fullwidth'
      ..children = [
        new VTableRowElement()
          ..children = [
            new VTableCellElement()..children = [new VParagraphElement()..text = 'While you\'re at it, why not try '],
            new VTableCellElement()
              ..children = [
                new VDivElement()
                  ..className = 'field'
                  ..children = [
                    new VDivElement()
                      ..className = 'control'
                      ..children = [
                        new VParagraphElement()
                          ..className = 'button is-rounded is-success'
                          ..onClick = ((_) => _onActClick(actList[tryIndex].uid))
                          ..children = [
                            new VSpanElement()..text = actList[tryIndex].name,
                          ],
                      ],
                  ],
              ],
          ],
      ];
  }

  ///[checkText] converts capacity from the stored number (or lack there of) to a pretty output
  String checkText(String text) {
    if (text != '') {
      if (text == '-1') {
        text = "Unlimited";
      }
    } else {
      text = "N/A";
    }
    return text;
  }

  ///[tdClass] will grey out a text field if the field is empty
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
                      _renderAddInfoMod(),
                      new VDivElement()
                        ..className = 'columns is-mobile'
                        ..children = [
                          new VDivElement()
                            ..className = 'column'
                            ..children = [
                              new Vh4()
                                ..className = 'title is-4'
                                ..text = 'Activity Data',
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
                                        ..type = 'submit'
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

  ///[_renderRefresh] a refresh button to ensure the data is up-to-date
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

  ///[_showTime] helper function to put a time into a proper format to view in a time type input box
  String _showTime(int hour, String min) {
    String ampm = "A.M.";
    if (hour > 12) {
      hour = hour - 12;
      ampm = "P.M.";
    }

    if (min.length == 1) {
      min = "0${min}";
    }
    return hour.toString() + ":" + min + " " + ampm;
  }

  ///[_searchListener] function to ensure the table is showing data that matches the search criteria
  _searchListener(_) {
    InputElement search = querySelector('#Search');
    if (search.value.isEmpty) {
      setState((ViewActivityProps, ViewActivityState) => ViewActivityState
        ..found = <Activity>[]
        ..searching = false);
    } else {
      List found = <Activity>[];

      for (Activity act in props.activityMap.values) {
        if (act.name.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(act);
        } else if (act.instructor.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(act);
        } else if (act.location.toLowerCase().contains(search.value.toLowerCase())) {
          found.add(act);
        } else if (act.capacity.toString().contains(search.value.toLowerCase())) {
          found.add(act);
        } else if (act.startTime.toString().contains(search.value)) {
          found.add(act);
        } else if ("${act.startTime.month}/${act.startTime.day}/${act.startTime.year}".contains(search.value)) {
          found.add(act);
        } else if (_showTime(act.startTime.hour, act.startTime.minute.toString()).contains(search.value)) {
          found.add(act);
        } else if (_showTime(act.endTime.hour, act.endTime.minute.toString()).contains(search.value)) {
          found.add(act);
        }

        setState((ViewActivityProps, ViewActivityState) => ViewActivityState
          ..found = found
          ..searching = true);
      }
    }
  }

  ///[_onExportCsvClick] exports the currently shown data to a csv file
  _onExportCsvClick(_) {
    List<String> lines;
    if (!state.searching) {
      lines = props.activityMap.values.map((activity) => activity.toCsv()).toList();
    } else {
      lines = state.found.map((activity) => activity.toCsv()).toList();
    }

    // Add the header row
    lines.insert(0, ExportHeader.activity.join(',') + '\n');

    Blob data = new Blob(lines, "text/csv");

    AnchorElement downloadLink = new AnchorElement(href: Url.createObjectUrlFromBlob(data));
    downloadLink.rel = 'text/csv';
    downloadLink.download = 'activity-export-${new DateTime.now().toIso8601String()}.csv';

    var event = new MouseEvent("click", view: window, cancelable: false);
    downloadLink.dispatchEvent(event);
  }

  ///[_onRefreshClick] reloads the data for the page
  _onRefreshClick(_) {
    props.actions.server.fetchAllActivities();
  }
}
