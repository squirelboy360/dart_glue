import 'core/platform_button.dart';

class Button extends PlatformButton {
  final String text;
  final void Function() onPressed;
  
  Button({
    required this.text,
    required this.onPressed,
    Map<String, dynamic>? style,
  }) : super(style: style);

  @override
  Map<String, dynamic> get props => {
    'type': 'button',
    'text': text,
    'onPressed': true,
  };
}
