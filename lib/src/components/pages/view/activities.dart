import 'dart:html' hide History;
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../core/pageRepeats.dart';
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
  List<String> title = ["Name", "Date and Time", "Location", ""];
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
                      _renderHeader(),
                      new VTableElement()
                        ..className = 'table is-narrow is-striped is-fullwidth'
                        ..children = _createRows(),
                    ],
                ],
            ],
        ],
    ];

  /// [_renderHeader] header with search bar etc
  VNode _renderHeader() => new VDivElement()
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
            ..text = " as of: ${formatTime(DateTime.now())}",
        ],
      renderSearch(_searchListener),
      renderExport(_onExportCsvClick),
      renderRefresh(_onRefreshClick),
    ];

  /// [_createRows] Scaling function to make rows based on amount of information available
  List<VNode> _createRows() {
    List<Activity> activities;
    List<VNode> nodeList = new List();
    if (!state.searching) {
      activities = props.activityMap.values.toList();
    } else {
      activities = state.found;
    }
    activities = _sort(activities, 0, activities.length - 1);
    nodeList.addAll(titleRow(title));
    for (Activity act in activities) {
      nodeList.add(new VTableRowElement()
        ..className = 'tr'
        ..children = [
          new VTableCellElement()
            ..className = tdClass(act.name)
            ..text = _capView(act.name),
          new VTableCellElement()
            ..className = tdClass(act.startTime.toString())
            ..text = _capView(formatTimeRange(act.startTime, act.endTime)),
          new VTableCellElement()
            ..className = tdClass(act.location)
            ..text = _capView(act.location),
          _renderButton(act.uid),
        ]);
    }
    return (nodeList);
  }

  /// [_sort] Merge sort by last name of user
  List<Activity> _sort(List<Activity> act, int left, int right) {
    if (left < right) {
      int mid = (left + right) ~/ 2;

      act = _sort(act, left, mid);
      act = _sort(act, mid + 1, right);
      act = _merge(act, left, mid, right);
    }
    return act;
  }

  /// [_merge] Helper for the sort function for merging the lists back together
  List<Activity> _merge(List<Activity> act, int left, int mid, int right) {
    List temp = new List();
    int curLeft = left, curRight = mid + 1, tempIndex = 0;
    while (curLeft <= mid && curRight <= right) {
      if (act.elementAt(curLeft).startTime.compareTo(act.elementAt(curRight).startTime) <= 0) {
        temp.insert(tempIndex, act.elementAt(curLeft));
        curLeft++;
      } else {
        temp.add(act.elementAt(curRight));
        curRight++;
      }
      tempIndex++;
    }
    while (curLeft <= mid) {
      temp.add(act.elementAt(curLeft));
      curLeft++;
      tempIndex++;
    }
    while (curRight <= right) {
      temp.add(act.elementAt(curRight));
      curRight++;
      tempIndex++;
    }
    act.replaceRange(left, right + 1, temp.getRange(0, tempIndex).whereType<Activity>());

    return act;
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

  ///[_capView] converts capacity from the stored number (or lack there of) to a pretty output
  String _capView(String text) {
    if (text != '') {
      if (text == '-1') {
        text = "Unlimited";
      }
    } else {
      text = "N/A";
    }
    return text;
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
        } else if (formatTimeRange(act.startTime, act.endTime).toLowerCase().contains(search.value)) {
          found.add(act);
        } else if (formatDate(act.startTime, [m, "/", d, "/", yyyy]).contains(search.value)) {
          found.add(act);
        } else if (formatDate(act.startTime, [mm, "/", dd, "/", yyyy]).contains(search.value)) {
          found.add(act);
        } else if (formatTime(act.startTime).contains(search.value)) {
          found.add(act);
        } else if (formatTime(act.endTime).contains(search.value)) {
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

  ///[_doneCheckinClick] returns to viewMembers page for the next check in
  _doneCheckinClick(_) {
    history.push(Routes.viewMembers);
  }
}
