import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_collection/built_collection.dart';

import '../../constants.dart';
import '../../model/emergencyContact.dart';
import '../../state/app.dart';
import '../../store.dart';
import '../core/nav.dart';
import '../../model/meal.dart';
import '../../model/user.dart';

class NewMealProps {
  AppActions actions;
  User user;
  Meal meal;
}

//TODO: Make is so when the logout button is pressed, it takes you back to the main page.

class NewMeal extends PComponent<NewMealProps> {
  NewMeal(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..children = [
      new Nav(new NavProps()
        ..actions = props.actions
        ..user = props.user),
      // new VDivElement()
      //   ..className = 'container'
      //   ..children = [
      _mealCreation(),
      //]
    ];

  //create the text boxes that are used to create new users
  VNode _mealCreation() => new VDivElement()
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
                            ..text = "Meal Creation"
                        ]
                    ],
                  //create the input fields for meal start and end times, and date
                  new VDivElement()
                    ..className = 'columns'
                    ..children = [
                      new VDivElement()
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
                                                ..className = 'input'
                                                ..id = 'serveDate-input'
                                                ..type = 'date'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ],
                      new VDivElement()
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
                                                ..className = 'input'
                                                ..id = 'mealStart-input'
                                                ..type = 'time'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ],
                      new VDivElement()
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
                                                ..className = 'input'
                                                ..id = 'mealEnd-input'
                                                ..type = 'time'
                                            ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ],

                  //create the input box for what the meal is
                  new VDivElement()
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
                                    ..placeholder = "Enter full meal"
                                ]
                            ]
                        ]
                    ],
                  //TODO: possibly find a way for admin to add a picture to the database and allow activities to access and utilize them.

                  //create the submit button
                  new VDivElement()
                    ..className = 'field is-grouped is-grouped-right'
                    ..children = [
                      new VDivElement()
                        ..className = 'control'
                        ..children = [
                          new VAnchorElement()
                            ..className = 'button is-link'
                            ..text = "Submit"
                           ..onClick = _submitClick
                        ]
                    ]
                ]
            ]
        ]
    ];

  //method used for the submit click
  //variable names serveDate-input, mealStart-input, mealEnd-input, meal-input
  _submitClick(_){
    InputElement date =querySelector('#serveDate-input');
    InputElement start =querySelector('#mealStart-input');
    InputElement end =querySelector('#mealEnd-input');
    TextAreaElement meal =querySelector('#meal-input');
    DateTime serveDay = DateTime.parse(date.value);
    String tempStart = start.value.toString(); //make the start time a string for use in _parseDate
    String tempEnd = end.value.toString(); //make the end time a string for use in _parseDate
    String menu = meal.toString();
    String startTime, endTime;
    startTime = _parseDate(serveDay, tempStart);
    endTime = _parseDate(serveDay, tempEnd);
    
    ListBuilder<String> temp = new ListBuilder();
    temp.add(menu);

    Meal newMeal = (new MealBuilder()
          ..startTime = DateTime.parse(startTime)
          ..endTime = DateTime.parse(endTime)
          ..menu = temp
          )
        .build();
    
    props.actions.server.updateOrCreateMeal(newMeal);
    props.actions.server.fetchAllMeals();
    
    history.push(Routes.dashboard);
  }

  ///[_parseDate] is a function adopted from the _showDate function that Josh wrote to make a string from a date and time input compatible with DateTime data types
  String _parseDate(DateTime date, String time){
    String tempDay, tempMonth, tempTime;

    if(date.day.toString().length == 1){
      tempDay = "0${date.day}";
    }else{
      tempDay = date.day.toString();
    }

    if(date.month.toString().length == 1){
      tempMonth = "0${date.month}";
    }else{
      tempMonth = date.month.toString();
    }

    print(time);
    tempTime = "${time}:00.000";

    return "${date.year}-${tempMonth}-${tempDay} ${tempTime}";
  }
}
