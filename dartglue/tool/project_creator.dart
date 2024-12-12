// tool/project_creator.dart
import 'dart:io';

class ProjectCreator {
  static Future<void> createProject(String name) async {
    print('Creating DartGlue project: $name');
    
    final dir = Directory(name);
    if (await dir.exists()) {
      throw Exception('Directory already exists: $name');
    }
    
    await dir.create();
    await Future.wait([
      _createPubspec(name),
      _createMainDart(name),
      _createGitignore(name),
      _createVsCodeLaunch(name),
    ]);
  }

  static Future<void> _createPubspec(String name) async {
    final file = File('$name/pubspec.yaml');
    await file.writeAsString('''
name: $name
description: A new DartGlue project
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  dartglue: ^0.1.0
  vm_service: ^11.0.0
  path: ^1.8.0
  meta: ^1.9.0

dev_dependencies:
  lints: ^2.0.0
''');
  }

  static Future<void> _createMainDart(String name) async {
    await Directory('$name/lib').create(recursive: true);
    final file = File('$name/lib/main.dart');
    await file.writeAsString('''
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
''');
  }

  static Future<void> _createGitignore(String name) async {
    final file = File('$name/.gitignore');
    await file.writeAsString('''
.dart_tool/
.packages
build/
.DS_Store
*.iml
.idea/
*.log
''');
  }

  static Future<void> _createVsCodeLaunch(String name) async {
    final vscodeDir = Directory('$name/.vscode');
    await vscodeDir.create();
    
    final launchFile = File('$name/.vscode/launch.json');
    await launchFile.writeAsString('''
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "DartGlue",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": ["--enable-vm-service"]
    }
  ]
}
''');
  }
}