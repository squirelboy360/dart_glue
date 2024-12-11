import 'dart:io';

void main(List<String> args) {
  if (args.length < 2) {
    print('Usage: dart create_project.dart <name> <platform>');
    exit(1);
  }

  final name = args[0];
  final platform = args[1];

  createProject(name, platform);
}

void createProject(String name, String platform) {
  // Create project structure
  Directory(name).createSync();
  Directory('$name/lib').createSync(recursive: true);

  // Copy platform-specific templates
  if (platform == 'android') {
    setupAndroidProject(name);
  } else if (platform == 'ios') {
    setupIOSProject(name);
  }

  // Create main.dart
  File('$name/lib/main.dart').writeAsStringSync('''
import 'package:dartglue/dartglue.dart';

void main() {
  final app = NativeView(
    width: 300,
    height: 500,
    backgroundColor: '#FFFFFF',
    children: [
      NativeText(
        'Hello from DartGlue!',
        fontSize: 24,
        textColor: '#000000',
      ),
    ],
  );
}
''');
}

void setupAndroidProject(String name) {
  // Android setup implementation
}

void setupIOSProject(String name) {
  // iOS setup implementation
}
