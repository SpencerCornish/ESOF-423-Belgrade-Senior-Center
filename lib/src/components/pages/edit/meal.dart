import 'dart:html' hide History;

import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../state/app.dart';
import '../../core/nav.dart';
import '../../core/pageRepeats.dart';
import '../../../model/meal.dart';
import '../../../model/user.dart';

///[EditMealProps] class to hold passed in properties of edit meal page
class EditMealProps {
  AppActions actions;
  User user;
  BuiltMap<String, Meal> mealMap;
  String selectedMealUID;
}

///[EditMealState] class to hold state of edit meal page
class EditMealState {
  bool edit;
}

///[EditMeal] class to create the edit meal page
class EditMeal extends Component<EditMealProps, EditMealState> {
  EditMeal(props) : super(props);

  @override
  EditMealState getInitialState() => EditMealState()..edit = false;

  @override
  void componentWillUpdate(EditMealProps nextProps, EditMealState nextState) {
    super.componentWillUpdate(nextProps, nextState);
  }

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() {
    Meal meal = props.mealMap[props.selectedMealUID];
    if (meal == null) return _renderMealNotFound();
    return new VDivElement()
      ..children = [
        new Nav(new NavProps()
          ..actions = props.actions
          ..user = props.user),
        _mealCreation(meal),
      ];
  }

  /// [_mealCreation] create the text boxes that are used to create new users
  VNode _mealCreation(Meal meal) => new VDivElement()
    ..className = 'container'
    ..children = [
      new VDivElement()
        ..className = 'columns is-centered margin-top'
        ..children = [
          new VDivElement()
            ..className = 'column is-three-quarters'
            ..children = [
              new VDivElement()
                ..className = 'box'
                ..children = [
                  //create the Title of Box
                  new VDivElement()
                    ..className = 'field is-grouped is-grouped-left'
                    ..children = [
                      new VDivElement()
                        ..className = 'cloumn has-text-centered'
                        ..children = [
                          new Vh1()
                            ..className = 'title'
                            ..text = "Meal Edit"
                        ]
                    ],
                  //create the input fields for meal start and end times, and date
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      _renderDate(meal),
                      _renderStart(meal),
                      _renderEnd(meal),
                    ],

                  //create the input box for what the meal is
                  _renderMenu(meal),
                  //create the submit or edit button
                  renderEditSubmitButton(state.edit, _editClick, _submitClick)
                ]
            ]
        ]
    ];

  /// [_renderDate] label and input for date
  _renderDate(Meal meal) => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-body'
                ..children = [
                  new VDivElement()
                    ..className = 'field'
                    ..id = 'date-lab'
                    ..children = [
                      new VLabelElement()
                        ..className = 'label'
                        ..text = "Serving Date"
                    ],
                  new VDivElement()
                    ..className = 'field is-horizontal'
                    ..children = [
                      new VParagraphElement()
                        ..className = 'control'
                        ..children = [
                          new VInputElement()
                            ..className = 'input ${state.edit ? '' : 'is-static'}'
                            ..id = 'serveDate-input'
                            ..type = 'date'
                            ..readOnly = !state.edit
                            ..value = formatDate(meal.startTime, [yyyy, "-", mm, "-", dd])
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderMenu] label and input for start time
  _renderStart(Meal meal) => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-body'
                ..children = [
                  new VDivElement()
                    ..className = 'field'
                    ..id = 'mealStart-lab'
                    ..children = [
                      new VLabelElement()
                        ..className = 'label'
                        ..text = "Start Time"
                    ],
                  new VDivElement()
                    ..className = 'field is-horizontal'
                    ..children = [
                      new VParagraphElement()
                        ..className = 'control'
                        ..children = [
                          new VInputElement()
                            ..className = 'input ${state.edit ? '' : 'is-static'}'
                            ..id = 'mealStart-input'
                            ..type = 'time'
                            ..readOnly = !state.edit
                            ..value = formatDate(meal.startTime, [hh, ":", mm])
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderMenu] label and input for end time
  _renderEnd(Meal meal) => new VDivElement()
    ..className = 'column'
    ..children = [
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-body'
                ..children = [
                  new VDivElement()
                    ..className = 'field'
                    ..id = 'mealEnd-lab'
                    ..children = [
                      new VLabelElement()
                        ..className = 'label'
                        ..text = "End Time"
                    ],
                  new VDivElement()
                    ..className = 'field is-horizontal'
                    ..children = [
                      new VParagraphElement()
                        ..className = 'control'
                        ..children = [
                          new VInputElement()
                            ..className = 'input ${state.edit ? '' : 'is-static'}'
                            ..id = 'mealEnd-input'
                            ..type = 'time'
                            ..readOnly = !state.edit
                            ..value = formatDate(meal.endTime, [hh, ":", mm])
                        ]
                    ]
                ]
            ]
        ]
    ];

  /// [_renderMenu] label and input for menu
  _renderMenu(Meal meal) => new VDivElement()
    ..className = 'columns'
    ..children = [
      new VDivElement()
        ..className = 'column is-narrow'
        ..children = [
          new VDivElement()
            ..className = 'field is-horizontal'
            ..children = [
              new VDivElement()
                ..className = 'field-label is-normal'
                ..children = [
                  new VLabelElement()
                    ..className = 'label'
                    ..text = "Meal",
                ]
            ]
        ],
      new VDivElement()
        ..className = 'field-body'
        ..children = [
          new VDivElement()
            ..className = 'field'
            ..children = [
              new VDivElement()
                ..className = 'control'
                ..children = [
                  new VTextAreaElement()
                    ..className = 'textarea'
                    ..id = 'meal-input'
                    ..text = _listHelper(meal)
                    ..readOnly = !state.edit
                ]
            ]
        ]
    ];

  ///[_listHelper] helper function to display each item in a menu to the text area
  String _listHelper(Meal meal) {
    String menu = "";

    for (String menuItem in meal.menu.toList()) {
      menu = menu + menuItem;
    }

    return menu;
  }

  //method used for the submit click
  //variable names serveDate-input, mealStart-input, mealEnd-input, meal-input
  _submitClick(_) {
    InputElement date = querySelector('#serveDate-input');
    InputElement start = querySelector('#mealStart-input');
    InputElement end = querySelector('#mealEnd-input');
    TextAreaElement meal = querySelector('#meal-input');
    DateTime serveDay = DateTime.parse(date.value);
    String tempStart = start.value; //make the start time a string for use in _parseDate
    String tempEnd = end.value; //make the end time a string for use in _parseDate
    String menu = meal.value;
    String startTime, endTime;
    startTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${tempStart}:00.000"]);
    endTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${tempEnd}:00.000"]);

    ListBuilder<String> temp = new ListBuilder();
    temp.add(menu);

    Meal update = props.mealMap[props.selectedMealUID].rebuild((builder) => builder
      ..startTime = DateTime.parse(startTime)
      ..endTime = DateTime.parse(endTime)
      ..menu = temp);

    props.actions.server.updateOrCreateMeal(update);
    props.actions.server.fetchAllMeals();

    setState((props, state) => state..edit = !state.edit);
  }

  ///[_editClick] listener for the click action of the edit button to put page into an edit state
  _editClick(_) {
    setState((props, state) => state..edit = !state.edit);
  }

  ///[_renderUserNotFound] if the UID is bad this page will simply say the user was not found
  _renderMealNotFound() => new VDivElement()..text = 'not found!';
}
