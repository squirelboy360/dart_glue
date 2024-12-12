import 'dart:io';
import 'package:path/path.dart' as path;

class PlatformAdder {
  static final _templateDir =
      path.join(Directory.current.path, 'tool', 'templates');

  static Future<void> _copyTemplate(
      String templatePath, String destinationPath) async {
    final sourceFile = File(path.join(_templateDir, templatePath));
    final destFile = File(destinationPath);

    // Create parent directories if they don't exist
    await destFile.parent.create(recursive: true);

    // Copy the template file
    if (await sourceFile.exists()) {
      await sourceFile.copy(destinationPath);
    } else {
      throw Exception('Template file not found: $templatePath');
    }
  }

  static Future<void> addAndroid(String projectPath) async {
    final androidDir = Directory('$projectPath/android');
    await androidDir.create();

    // Copy template files
    await _copyTemplate('android/MainActivity.kt',
        '$projectPath/android/app/src/main/kotlin/MainActivity.kt');
    await _copyTemplate('android/NativeViewManager.kt',
        '$projectPath/android/app/src/main/kotlin/NativeViewManager.kt');
  }

  static Future<void> addIos(String projectPath) async {
    final iosDir = Directory('$projectPath/ios');
    await iosDir.create();

    // Copy template files
    await _copyTemplate(
        'ios/AppDelegate.swift', '$projectPath/ios/AppDelegate.swift');
    await _copyTemplate('ios/NativeViewManager.swift',
        '$projectPath/ios/NativeViewManager.swift');
  }
}
