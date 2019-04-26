import 'package:built_collection/built_collection.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../core/nav.dart';

import '../../../constants.dart';
import '../../../model/user.dart';
import '../../../model/shift.dart';
import '../../../state/app.dart';

class DashboardProps {
  AppActions actions;
  User user;
  BuiltList<Shift> userShiftList;
}

class Dashboard extends PComponent<DashboardProps> {
  Dashboard(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  VNode emailInputNode;
  VNode passwordInputNode;

  @override
  void componentWillMount() {
    super.componentWillMount();
    final len = props.userShiftList.length;
    props.actions.server.fetchShiftsForUser(len == 0 ? 3 : len);
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
            ..className = 'columns is-centered margin-top'
            ..children = [
              _renderCard(
                size: 6,
                title: 'Time Entry',
                content: _renderTimeEntry(),
                footerContent: [
                  _renderFooterItem('View Timecard', (_) => history.push(Routes.viewShifts)),
                ],
              ),
            ],
        ],
    ];

  VNode _renderCard({int size: 2, String title: 'title', List<VNode> content, List<VNode> footerContent}) =>
      new VDivElement()
        ..className = 'column is-$size'
        ..children = [
          new VDivElement()
            ..className = 'card animated fadeIn fastest'
            ..children = [
              new VDivElement()
                ..className = 'card-header'
                ..children = [
                  new VParagraphElement()
                    ..className = 'card-header-title'
                    ..text = title,
                ],
              new VDivElement()
                ..className = 'card-content'
                ..children = [
                  new VDivElement()
                    ..className = 'content'
                    ..children = content
                ],
              new Vfooter()
                ..className = 'card-footer'
                ..children = footerContent,
            ],
        ];

  _renderFooterItem(String linkText, Function onClick) => new VAnchorElement()
    ..className = 'card-footer-item'
    ..onClick = onClick
    ..children = [
      new VSpanElement()..text = linkText,
      new VSpanElement()
        ..className = 'icon'
        ..children = [new Vi()..className = 'fas fa-chevron-circle-right']
    ];

  _renderTimeEntry() => [
        new VDivElement()
          ..children = [
            new VDivElement()
              ..className = 'columns'
              ..children = [
                new VDivElement()
                  ..className = 'column'
                  ..children = [
                    new VParagraphElement()
                      ..className = 'subtitle has-text-weight-semibold'
                      ..text = 'Recent shifts',
                    new VDivElement()..children = _renderRecentShifts()
                  ],
              ],
            new VParagraphElement()
              ..className = 'has-text-centered'
              ..children = [
                new VSpanElement()
                  ..className = 'has-text-weight-bold'
                  ..text = "Status:",
                new VSpanElement()
                  ..className = ''
                  ..text = " Clocked ${_isUserClockedIn() ? 'in' : 'out'}",
              ],
            new VDivElement()
              ..className = 'columns is-mobile'
              ..children = [
                new VDivElement()
                  ..className = 'column'
                  ..children = [
                    new VDivElement()
                      ..className = 'buttons has-addons is-centered'
                      ..children = [
                        new VAnchorElement()
                          ..className = 'button is-rounded'
                          ..key = (_isUserClockedIn() ? 'is-disabled-clock-in' : 'clock-in')
                          ..attributes = _isUserClockedIn() ? {'disabled': 'true'} : {}
                          ..children = [
                            new VSpanElement()
                              ..className = 'icon'
                              ..children = [
                                new Vi()..className = 'fas fa-hourglass-start',
                              ],
                            new VSpanElement()..text = 'Clock In',
                          ]
                          ..onClick = _onClockInClick,
                        new VAnchorElement()
                          ..className = 'button is-rounded'
                          ..key = (_isUserClockedIn() ? 'clock-out' : 'is-disabled-clock-out')
                          ..attributes = _isUserClockedIn() ? {} : {'disabled': 'true'}
                          ..children = [
                            new VSpanElement()
                              ..className = 'icon'
                              ..children = [
                                new Vi()..className = 'fas fa-hourglass-end',
                              ],
                            new VSpanElement()..text = 'Clock Out',
                          ]
                          ..onClick = _onClockOutClick,
                      ],
                  ],
              ],
          ],
      ];

  _isUserClockedIn() {
    if (props.userShiftList.length == 0) {
      return false;
    }
    return props.userShiftList.first.outTime == null;
  }

  _onClockInClick(_) {
    if (_isUserClockedIn()) {
      return;
    }
    props.actions.server.registerClockEvent(true);
  }

  _onClockOutClick(_) {
    if (!_isUserClockedIn()) {
      return;
    }
    props.actions.server.registerClockEvent(false);
  }

  _renderRecentShifts() => props.userShiftList
      .map((shift) => new VParagraphElement()..text = '${formatTime(shift.inTime)} - ${formatTime(shift.outTime)}')
      .take(3);
}
