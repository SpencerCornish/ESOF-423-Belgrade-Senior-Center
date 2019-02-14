import 'dart:html' hide History;

import 'package:wui_builder/components.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

import '../../constants.dart';

import '../../state/app.dart';
import '../../middleware/serverMiddleware.dart';

class HomeProps {
  AppActions actions;
}

class Home extends PComponent<HomeProps> {
  Home(props) : super(props);

  History _history;

  /// Browser history entrypoint, to control page navigation
  History get history => _history ?? findHistoryInContext(context);

  @override
  VNode render() => new VDivElement()
    ..className = 'container'
    ..children = [
      new VDivElement()
        ..className = 'columns is-centered margin-top'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow'
            ..children = [
              new VDivElement()
                ..className = 'box'
                ..children = [
                  new Vh1()
                    ..className = 'title is-4 has-text-centered'
                    ..text = 'Belgrade Senior Center',
                  new Vh1()
                    ..className = 'subtitle has-text-centered'
                    ..text = 'Member Management Portal',
                  _renderSignIn(),
                  // Form Here
                ],
            ],
        ],
      new VDivElement()
        ..className = 'columns is-centered margin-top'
        ..children = [
          new VDivElement()
            ..className = 'column is-narrow has-text-centered'
            ..children = [
              new VAnchorElement()
                ..className = 'button is-text has-text-grey'
                ..href = "https://github.com/SpencerCornish/belgrade-senior-center/blob/master/README.md"
                ..text = "Development Documentation",
            ],
          new VDivElement()
            ..className = 'column is-narrow has-text-centered'
            ..children = [
              new VAnchorElement()
                ..className = 'button is-text has-text-grey'
                ..href = "https://github.com/SpencerCornish/belgrade-senior-center/blob/master/USERREADME.md"
                ..text = "User Documentation",
            ],
        ],
    ];

  VNode _renderSignIn() => new VDivElement()
    ..children = [
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Email",
          new VDivElement()
            ..className = 'control has-icons-left'
            ..children = [
              new VInputElement()
                ..className = 'input'
                ..type = "email"
                ..id = 'email-input'
                ..placeholder = "me@email.net",
              new VSpanElement()
                ..className = 'icon is-small is-left'
                ..children = [new Vi()..className = "fas fa-user"],
            ],
        ],
      new VDivElement()
        ..className = 'field'
        ..children = [
          new VLabelElement()
            ..className = 'label'
            ..text = "Password",
          new VDivElement()
            ..className = 'control has-icons-left'
            ..children = [
              new VInputElement()
                ..className = 'input'
                ..type = "password"
                ..id = 'pass-input'
                ..placeholder = "Password",
              new VSpanElement()
                ..className = 'icon is-small is-left'
                ..children = [new Vi()..className = "fas fa-lock"],
            ],
        ],
      new VDivElement()
        ..className = 'field is-grouped'
        ..children = [
          new VDivElement()
            ..className = 'control'
            ..children = [
              new VButtonElement()
                ..className = 'button is-text'
                ..onClick = _onResetPasswordClick
                ..text = 'Reset Password',
            ],
          new VDivElement()
            ..className = 'control'
            ..children = [
              new VButtonElement()
                ..className = 'button'
                ..onClick = _onCancelClick
                ..text = 'Cancel',
            ],
          new VDivElement()
            ..className = 'control'
            ..children = [
              new VButtonElement()
                ..className = 'button is-link'
                ..onClick = _onSubmitClick
                ..text = 'Submit',
            ],
        ],
      new VAnchorElement()
        ..onClick = ((_) => history.push(Routes.dashboard))
        ..text = "Click Me",
    ];

  _onSubmitClick(_) {
    InputElement email = querySelector('#email-input');
    InputElement pass = querySelector('#pass-input');
    if (!emailIsValid(email.value) || pass.value.length < 8) {
      return;
    }
    props.actions.serverActions.signInAdmin(new AdminSignInPayload(email.value, pass.value));
  }

  _onCancelClick(_) {
    //TODO: implement form cancellation
    throw ("Implement form cancellation");
  }

  _onResetPasswordClick(_) {
    //TODO: implement password reset
    throw ("Implement password reset");
  }
}
