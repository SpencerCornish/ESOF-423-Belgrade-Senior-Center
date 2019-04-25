import 'dart:html' hide History;

import 'package:bsc/src/constants.dart';
import 'package:date_format/date_format.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../../state/app.dart';
import '../../core/modal.dart';
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
  bool timeIsValid;
  bool mealIsValid;
  bool edit;
  bool promptForMealDelete;
}

///[EditMeal] class to create the edit meal page
class EditMeal extends Component<EditMealProps, EditMealState> {
  EditMeal(props) : super(props);

  @override
  EditMealState getInitialState() => EditMealState()
    ..edit = false
    ..timeIsValid = true
    ..mealIsValid = true
    ..promptForMealDelete = false;

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
        _renderDeleteModal(),
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
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      new VDivElement()
                        ..className = 'column is-narrow'
                        ..children = [
                          new Vh1()
                            ..className = 'title'
                            ..text = "Meal Edit"
                        ],
                      new VDivElement()..className = 'column',
                      new VDivElement()
                        ..className = 'column is-narrow'
                        ..children = [
                          renderEditSubmitButton(
                              edit: state.edit,
                              onEditClick: _editClick,
                              onSubmitClick: _submitClick,
                              onDeleteClick: _promptForRemoveMealClick,
                              submitIsDisabled: Validator.canActivateSubmit(state.mealIsValid, state.timeIsValid)),
                        ],
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
                            ..onInput = _timeValidator
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.timeIsValid ? '' : 'is-danger'}'
                            ..id = 'serveDate-input'
                            ..type = 'date'
                            ..readOnly = !state.edit
                            ..value = formatDate(meal.startTime, [yyyy, "-", mm, "-", dd]),
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Meal needs a date and time'
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
                            ..onInput = _timeValidator
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.timeIsValid ? '' : 'is-danger'}'
                            ..id = 'mealStart-input'
                            ..type = 'time'
                            ..readOnly = !state.edit
                            ..value = formatDate(meal.startTime, [hh, ":", mm]),
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Meal ends before it begins, please correct.'
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
                            ..onInput = _timeValidator
                            ..className =
                                'input ${state.edit ? '' : 'is-static'} ${state.timeIsValid ? '' : 'is-danger'}'
                            ..id = 'mealEnd-input'
                            ..type = 'time'
                            ..readOnly = !state.edit
                            ..value = formatDate(meal.endTime, [hh, ":", mm]),
                          new VParagraphElement()
                            ..className = 'help is-danger ${state.timeIsValid ? 'is-invisible' : ''}'
                            ..text = 'Meal ends before it begins, please correct.'
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
                    ..onInput = _mealValidator
                    ..className = 'textarea ${state.mealIsValid ? '' : 'is-danger'}'
                    ..id = 'meal-input'
                    ..text = _listHelper(meal)
                    ..readOnly = !state.edit,
                  new VParagraphElement()
                    ..className = 'help is-danger ${state.mealIsValid ? 'is-invisible' : ''}'
                    ..text = 'Meal needs a menu.'
                ]
            ]
        ]
    ];

  VNode _renderDeleteModal() => new ConfirmModal(ConfirmModalProps()
    ..isOpen = state.promptForMealDelete
    ..cancelButtonStyle = ""
    ..cancelButtonText = "Cancel"
    ..submitButtonStyle = "is-danger"
    ..submitButtonText = "Remove"
    ..message = "Are you sure you want to remove this activity? This cannot be undone."
    ..onCancel = _cancelRemoveMealClick
    ..onConfirm = _removeMealClick);

  ///[_listHelper] helper function to display each item in a menu to the text area
  String _listHelper(Meal meal) {
    String menu = "";

    for (String menuItem in meal.menu.toList()) {
      menu = menu + menuItem;
    }

    return menu;
  }

  /// [_mealValidator] validator function to ensure menu is input correctly
  _mealValidator(_) {
    TextAreaElement meal = querySelector('#meal-input');
    String menu = meal.value;
    bool isValid = Validator.name(menu);
    setState((NewMealProps, NewMealState) => NewMealState..mealIsValid = isValid);
  }

  //Checks that the meal does not start before it ends
  /// [_timeValidator] validator function to ensure time is input correctly
  _timeValidator(_) {
    //Gets the 3 date time inputs
    InputElement date = querySelector('#serveDate-input');
    InputElement time_start = querySelector('#mealStart-input');
    InputElement time_end = querySelector('#mealEnd-input');
    try {
      DateTime serveDay = DateTime.parse(date.value);

      String startTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${time_start.value}:00.000"]);
      String endTime = formatDate(serveDay, [yyyy, "-", mm, "-", dd, " ${time_end.value}:00.000"]);

      DateTime start = DateTime.parse(startTime);
      DateTime end = DateTime.parse(endTime);

      bool isValid = Validator.time(start, end);

      setState((NewMealProps, NewMealState) => NewMealState..timeIsValid = isValid);
    } catch (_) {
      setState((NewMealProps, NewMealState) => NewMealState..timeIsValid = false);
    }
  }

  //method used for the submit click
  //variable names serveDate-input, mealStart-input, mealEnd-input, meal-input
  _submitClick() {
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

  _promptForRemoveMealClick() {
    setState((props, state) => state..promptForMealDelete = true);
  }

  _cancelRemoveMealClick() {
    setState((props, state) => state..promptForMealDelete = false);
  }

  _removeMealClick() {
    final meal = props.mealMap[props.selectedMealUID];
    if (meal == null) return;
    props.actions.server.removeMeal(meal);
    history.push(Routes.viewMeal);
  }

  ///[_editClick] listener for the click action of the edit button to put page into an edit state
  _editClick() {
    setState((props, state) => state..edit = !state.edit);
  }

  ///[_renderUserNotFound] if the UID is bad this page will simply say the user was not found
  _renderMealNotFound() => new VDivElement()..text = 'not found!';
}
