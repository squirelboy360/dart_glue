
import 'dart:io';
import 'project_template.dart';

class ExampleTemplate {
  final String projectName;
  final Directory projectDir;

  ExampleTemplate({
    required this.projectName,
    required this.projectDir,
  });

  Future<void> create() async {
    // Create base project first
    final creator = ProjectCreator(
      projectName: projectName,
      projectDir: projectDir,
    );
    await creator.createProject();

    // Override main.dart with example code
    await _createExampleMain();
  }

  Future<void> _createExampleMain() async {
    await File('${projectDir.path}/lib/main.dart').writeAsString('''
import 'package:${projectName}/src/primitives/view.dart';
import 'package:${projectName}/src/primitives/text.dart';
import 'package:${projectName}/src/primitives/button.dart';
import 'package:${projectName}/src/primitives/image.dart';

void main() {
  print('Dart Glue Example App Started');
  
  final rootView = View(
    style: {
      'backgroundColor': '#FFFFFF',
      'padding': 16,
    },
    children: [
      Text(
        'Dart Glue Example',
        style: {
          'fontSize': 24,
          'fontWeight': 'bold',
          'color': '#000000',
          'marginBottom': 24,
        },
      ),
      View(
        style: {
          'backgroundColor': '#F5F5F5',
          'padding': 16,
          'borderRadius': 8,
          'marginBottom': 16,
        },
        children: [
          Text(
            'This is a card view',
            style: {
              'fontSize': 18,
              'color': '#333333',
              'marginBottom': 8,
            },
          ),
          Image(
            'https://picsum.photos/200',
            style: {
              'width': 200,
              'height': 200,
              'borderRadius': 4,
              'marginBottom': 8,
            },
          ),
          Button(
            text: 'Tap Me',
            onPressed: () {
              print('Card button tapped!');
            },
            style: {
              'backgroundColor': '#007AFF',
              'padding': 12,
              'borderRadius': 4,
            },
          ),
        ],
      ),
      Button(
        text: 'Show Alert',
        onPressed: () {
          print('Alert button tapped!');
        },
        style: {
          'backgroundColor': '#FF3B30',
          'padding': 12,
          'borderRadius': 4,
        },
      ),
    ],
  );

  rootView.create();
}
''');
  }
}