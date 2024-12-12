import 'view.dart';
import '../../native/bridge.dart';

class Text extends View {
  Text(
    String text, {
    double? fontSize,
    String? textColor,
  }) : super() {
    Bridge.instance.updateViewProps(internalHandle, {
      // Using protected getter inherited from View
      'text': text,
      if (fontSize != null) 'fontSize': fontSize,
      if (textColor != null) 'textColor': textColor,
    });
  }
}
