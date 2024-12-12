import 'package:dartglue/dartglue.dart';

void main() {
  runApp(
    View(
      width: 300,
      height: 500,
      backgroundColor: '#FFFFFF',
      children: [
        Text(
          'Hello from DartGlue!',
          fontSize: 24,
          textColor: '#000000',
        ),
      ],
    ),
  );
}
