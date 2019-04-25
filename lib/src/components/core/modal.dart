import 'package:wui_builder/components.dart';
import 'package:wui_builder/vhtml.dart';

class ConfirmModalProps {
  bool isOpen;

  String submitButtonText;
  String cancelButtonText;

  String submitButtonStyle;
  String cancelButtonStyle;

  String message;

  Function onConfirm;
  Function onCancel;
}

class ConfirmModal extends PComponent<ConfirmModalProps> {
  ConfirmModal(props) : super(props);

  @override
  render() => new VDivElement()
    ..className = "modal ${props.isOpen ? 'is-active' : ''}"
    ..children = [
      new VDivElement()..className = 'modal-background',
      new VDivElement()
        ..className = 'modal-card'
        ..children = [
          new Vsection()
            ..className = 'modal-card-body'
            ..children = [
              new VParagraphElement()..text = props.message,
            ],
          new Vfooter()
            ..className = 'modal-card-foot'
            ..children = [
              new VButtonElement()
                ..className = 'button ${props.submitButtonStyle} is-rounded'
                ..text = props.submitButtonText
                ..onClick = (_) => props.onConfirm(),
              new VButtonElement()
                ..className = 'button is-rounded ${props.cancelButtonStyle}'
                ..text = props.cancelButtonText
                ..onClick = (_) => props.onCancel(),
            ],
        ],
    ];
}
