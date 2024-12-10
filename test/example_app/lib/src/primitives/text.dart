import 'core/primitive.dart';
import 'core/platform_text.dart';

class Text extends PlatformText {
  final String text;
  
  Text(
    this.text, {
    super.style,
  });

  @override
  Map<String, dynamic> get props => {
    'type': 'text',
    'text': text,
  };
}
