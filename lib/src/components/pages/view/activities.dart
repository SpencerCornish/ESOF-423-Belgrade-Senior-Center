import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../core/nav.dart';
import '../../../model/activity.dart';
import '../../../model/user.dart';
import '../../../state/app.dart';
import '../../../constants.dart';

class ViewActivityProps {
  AppActions actions;
  User user;
  bool signUp;
  BuiltMap<String, Activity> activityMap;
  String selectedMemberUID;
}

class ViewActivityState {
  bool searching;
  List<Activity> found;
}

/// [viewActivity] class / page to show a visual representation of current stored data
class ViewActivity extends Component<ViewActivityProps, ViewActivityState> {
  ViewActivity(props) : super(props);
  List<String> title = ["Name", "Start", "End", "Location", "Capacity", "Instructor"];
  History _history;

  @override
  ViewActivityState getInitialState() => ViewActivityState()
    ..found = <Activity>[]
    ..searching = false;

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
        ..onClick = ((_) => _onActClick(act.uid))
        ..children = [
          new VTableCellElement()
            ..className = tdClass(act.name)
            ..text = checkText(act.name),
          new VTableCellElement()
            ..className = tdClass(act.startTime.toString())
            ..text = checkText("${act.startTime.month}/${act.startTime.day}/${act.startTime.year}"),
          new VTableCellElement()
            ..className = tdClass(act.endTime.toString())
            ..text = checkText("${act.endTime.month}/${act.endTime.day}/${act.endTime.year}"),
          new VTableCellElement()
            ..className = tdClass(act.location)
            ..text = checkText(act.location),
          new VTableCellElement()
            ..className = tdClass(act.capacity.toString())
            ..text = checkText(act.capacity.toString()),
          new VTableCellElement()
            ..className = tdClass(act.instructor)
            ..text = checkText(act.instructor),
        ]);
    }
    return (nodeList);
  }

  _onActClick(String uid) {
    if (!props.signUp) {
      history.push(Routes.generateEditActivityURL(uid));
    } else {
      Activity act = props.activityMap[uid];
      ListBuilder<String> list = new ListBuilder();

      for (String id in act.users) {
        list.add(id);
      }

      list.add(props.selectedMemberUID);

      Activity update = act.rebuild((builder) => builder
        ..capacity = act.capacity
        ..endTime = act.endTime
        ..startTime = act.startTime
        ..instructor = act.instructor
        ..location = act.location
        ..name = act.name
        ..users = list);

      props.actions.server.updateOrCreateActivity(update);
      props.actions.server.fetchAllActivities();
      history.push(Routes.viewMembers);
    }
  }

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
        } else if (act.endTime.toString().contains(search.value)) {
          found.add(act);
        } else if ("${act.endTime.month}/${act.endTime.day}/${act.endTime.year}".contains(search.value)) {
          found.add(act);
        }

        setState((ViewActivityProps, ViewActivityState) => ViewActivityState
          ..found = found
          ..searching = true);
      }
    }
  }

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
}
