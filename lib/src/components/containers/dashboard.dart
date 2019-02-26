import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../core/nav.dart';

import '../../model/user.dart';

import '../../state/app.dart';

class DashboardProps {
  AppActions actions;
  User user;
}

class Dashboard extends PComponent<DashboardProps> {
  Dashboard(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

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
            ..className = 'columns is-centered margin-top'
            ..children = [
              _renderCard(
                size: 4,
                title: 'Alerts',
                content: [
                  new VParagraphElement()..text = 'This is a card content!',
                ],
                footerContent: [
                  // _renderFooterItem('More', (_) => print("foo")),
                ],
              ),
              _renderCard(
                size: 4,
                title: 'Upcoming',
                content: [
                  new VParagraphElement()..text = 'This is a card content!',
                ],
                footerContent: [
                  _renderFooterItem('More', (_) => print("foo")),
                ],
              ),
              _renderCard(
                size: 4,
                title: 'Upcoming Membership Renewals',
                content: [
                  new VParagraphElement()..text = 'This is a card content!',
                ],
                footerContent: [
                  _renderFooterItem('Dismiss', (_) => print("foo")),
                  _renderFooterItem('More', (_) => print("foo")),
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
            ..className = 'card'
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
}
