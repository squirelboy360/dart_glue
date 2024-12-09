import 'core/platform_text.dart';

class Text extends PlatformText {
  final String text;
  
  Text(
    this.text, {
    Map<String, dynamic>? style,
  }) : super(style: style);

  @override
  Map<String, dynamic> get props => {
    'type': 'text',
    'text': text,
  };
}
