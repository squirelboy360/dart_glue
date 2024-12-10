import 'package:example_app/src/primitives/view.dart';
import 'package:example_app/src/primitives/text.dart';
import 'package:example_app/src/primitives/button.dart';
import 'package:example_app/src/primitives/image.dart';

void main() {
  print('Dart Glue App Started');
  final rootView = View(
    style: {
      'backgroundColor': '#FFFFFF',
      'width': 'match_parent',
      'height': 'match_parent',
    },
    children: [
      Text(
        'Welcome to Dart Glue!',
        style: {
          'fontSize': 24,
          'fontWeight': 'bold',
          'color': '#000000',
          'marginBottom': 16,
        },
      ),
      Image(
        'assets/logo.png',
        style: {
          'width': 100,
          'height': 100,
          'marginBottom': 16,
        },
      ),
      Button(
        text: 'Click Me',
        onPressed: () {
          print('Button pressed!');
        },
        style: {
          'backgroundColor': '#007AFF',
          'padding': 12,
          'borderRadius': 8,
        },
      ),
    ],
  );

  rootView.create();
}
