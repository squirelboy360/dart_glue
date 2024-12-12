// example/lib/main.dart
import 'package:dartglue/dartglue.dart';

void main() {
  runApp(
    View(
      width: 300,
      height: 500,
      backgroundColor: '#FFFFFF',
      padding: EdgeInsets.all(16),
      children: [
        Text(
          'Hello from Glue!',
          fontSize: 24,
          textColor: '#000000',
        ),
      ],
    ),
  );
}
