import 'core/platform_text.dart';

class Text extends PlatformText {
  final String text;
  Map<String, dynamic>? style;
  Text(
    this.text, {
    this.style,
  });

  @override
  Map<String, dynamic> get props => {
        'type': 'text',
        'text': text,
      };
}

