import 'package:dartglue/dartglue.dart';

class NativeText extends NativeView {
  NativeText(
    String text, {
    double? fontSize,
    String? textColor,
  }) : super() {
    updateProps({
      'text': text,
      if (fontSize != null) 'fontSize': fontSize,
      if (textColor != null) 'textColor': textColor,
    });
  }
}
