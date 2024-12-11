import 'package:dartglue/src/core/view.dart';
import 'package:dartglue/src/core/text.dart';

void main() {
  final root = NativeView(
    width: 300,
    height: 500,
    backgroundColor: '#FFFFFF',
  );

  final text = NativeText(
    'Hello from DartGlue!',
    fontSize: 24,
    textColor: '#000000',
  );
}
