import 'package:wui_builder/vhtml.dart';
import 'package:wui_builder/wui_builder.dart';

/// identical render methods for the various pages

/// [renderSearch] render search bar
renderSearch(Function _searchListener) => new VDivElement()
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
              ..type = 'text'
              ..onKeyUp = (_) => _searchListener(),
            new VSpanElement()
              ..className = 'icon is-left'
              ..children = [new Vi()..className = 'fas fa-search'],
          ],
      ],
  ];

/// [renderExport] render the export csv button
renderExport(Function _onExportCsvClick) => new VDivElement()
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
              ..children = [
                new VSpanElement()
                  ..className = 'icon'
                  ..children = [new Vi()..className = 'fas fa-file-csv'],
                new VSpanElement()..text = 'Export',
              ]
              ..onClick = (_) => _onExportCsvClick(),
          ],
      ],
  ];

///[renderRefresh] a refresh button to ensure the data is up-to-date
renderRefresh(Function _onRefreshClick) => new VDivElement()
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
              ..children = [
                new VSpanElement()
                  ..className = 'icon'
                  ..children = [new Vi()..className = 'fas fa-sync-alt'],
                new VSpanElement()..text = 'Refresh',
              ]
              ..onClick = (_) => _onRefreshClick(),
          ],
      ],
  ];

/// [titleRow] helper function to create the title row
List<VNode> titleRow(List<String> title) {
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

///[renderEditSubmitButton] button selector method to show either submit or edit button based on state
VNode renderEditSubmitButton(
    {bool edit, Function onEditClick, Function onSubmitClick, Function onDeleteClick, bool submitIsDisabled}) {
  if (edit) {
    return renderSubmit(onSubmitClick, submitIsDisabled);
  }
  return _renderEdit(onEditClick, onDeleteClick);
}

///[_renderEdit] creates a button to toggle from a view page to increase the number of input fields
_renderEdit(Function onEditClick, Function onDeleteClick) => new VDivElement()
  ..className = 'field is-grouped is-grouped-right'
  ..children = [
    new VDivElement()
      ..className = 'control'
      ..children = [
        new VAnchorElement()
          ..className = 'button is-link is-rounded'
          ..text = "Edit"
          ..onClick = (_) => onEditClick()
      ],
    new VDivElement()
      ..className = 'control'
      ..children = [
        new VAnchorElement()
          ..className = 'button is-danger is-rounded'
          ..text = "Delete"
          ..onClick = (_) => onDeleteClick()
      ],
  ];

///[renderSubmit] create the submit button to collect the data
renderSubmit(Function onSubmitClick, bool disable) => new VDivElement()
  ..className = 'field is-grouped is-grouped-right'
  ..children = [
    new VDivElement()
      ..className = 'control'
      ..children = [
        new VButtonElement()
          ..className = 'button is-link is-rounded'
          ..text = "Submit"
          ..disabled = disable
          ..onClick = (_) => onSubmitClick()
      ]
  ];
