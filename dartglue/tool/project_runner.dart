// tool/project_runner.dart
import 'dart:io';

class ProjectRunner {
  static Future<void> run() async {
    final projectDir = Directory.current;

    // First check if we're in a DartGlue project
    if (!File('pubspec.yaml').existsSync()) {
      throw Exception('Not in a DartGlue project directory');
    }

    // Check for platform-specific projects
    final hasAndroid = Directory('${projectDir.path}/android').existsSync();
    final hasIos = Directory('${projectDir.path}/ios').existsSync();

    if (!hasAndroid && !hasIos) {
      print('No platform projects found. Add one with:');
      print('  dartglue add android');
      print('  dartglue add ios');
      exit(1);
    }

    // Start the Dart VM for hot reload support
    final vmProcess = await Process.start(
      'dart',
      ['run', '--enable-vm-service', 'lib/main.dart'],
      mode: ProcessStartMode.inheritStdio,
    );

    // Run platform-specific build
    if (hasAndroid) {
      await _runAndroid();
    } else if (hasIos) {
      await _runIos();
    }

    // Wait for the VM process to complete
    await vmProcess.exitCode;
  }

  static Future<void> _runAndroid() async {
    print('Building Android project...');
    final result = await Process.run('gradle', ['installDebug'],
        workingDirectory: 'android');
        
    if (result.exitCode != 0) {
      print('Build failed: ${result.stderr}');
      exit(1);
    }

    print('Installing on device...');
    await Process.run('adb',
        ['install', 'android/app/build/outputs/apk/debug/app-debug.apk']);
  }

  static Future<void> _runIos() async {
    print('Building iOS project...');
    final result = await Process.run('xcodebuild',
        ['-workspace', 'ios/Runner.xcworkspace', '-scheme', 'Runner'],
        workingDirectory: 'ios');
        
    if (result.exitCode != 0) {
      print('Build failed: ${result.stderr}');
      exit(1);
    }
  }
}