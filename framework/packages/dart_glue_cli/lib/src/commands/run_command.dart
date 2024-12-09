import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;

class RunCommand extends Command {
  @override
  String get name => 'run';

  @override
  String get description => 'Run the Dart Glue app on a specific platform';

  RunCommand() {
    argParser.addOption(
      'platform',
      abbr: 'p',
      help: 'Platform to run on (ios/android)',
      allowed: ['ios', 'android'],
      mandatory: true,
    );
  }

  @override
  Future<void> run() async {
    final platform = argResults!['platform'];
    final currentDir = Directory.current;
    
    // Verify this is a Dart Glue project
    final pubspecFile = File(path.join(currentDir.path, 'pubspec.yaml'));
    if (!await pubspecFile.exists()) {
      print('Error: Not a Dart Glue project directory (pubspec.yaml not found)');
      exit(1);
    }

    switch (platform) {
      case 'ios':
        await _runIos(currentDir);
        break;
      case 'android':
        await _runAndroid(currentDir);
        break;
    }
  }

  Future<void> _runIos(Directory projectDir) async {
    final iosDir = Directory(path.join(projectDir.path, 'ios'));
    if (!await iosDir.exists()) {
      print('Error: iOS project not found');
      exit(1);
    }

    // Create Podfile if it doesn't exist
    final podfile = File(path.join(iosDir.path, 'Podfile'));
    if (!await podfile.exists()) {
      await podfile.writeAsString('''
platform :ios, '13.0'

target 'MyApp' do
  use_frameworks!
end
''');
    }

    // Run pod install
    print('Installing CocoaPods dependencies...');
    final podResult = await Process.run('pod', ['install'], workingDirectory: iosDir.path);
    if (podResult.exitCode != 0) {
      print('Error running pod install: \${podResult.stderr}');
      exit(1);
    }

    // Open Xcode workspace
    print('Opening Xcode...');
    final workspaceName = '\${path.basename(projectDir.path)}.xcworkspace';
    final openResult = await Process.run('open', [workspaceName], workingDirectory: iosDir.path);
    if (openResult.exitCode != 0) {
      print('Error opening Xcode workspace: \${openResult.stderr}');
      exit(1);
    }
  }

  Future<void> _runAndroid(Directory projectDir) async {
    final androidDir = Directory(path.join(projectDir.path, 'android'));
    if (!await androidDir.exists()) {
      print('Error: Android project not found');
      exit(1);
    }

    // Create gradle wrapper if it doesn't exist
    final gradleWrapperProps = File(path.join(androidDir.path, 'gradle/wrapper/gradle-wrapper.properties'));
    if (!await gradleWrapperProps.exists()) {
      await Directory(path.join(androidDir.path, 'gradle/wrapper')).create(recursive: true);
      await gradleWrapperProps.writeAsString('''
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\\://services.gradle.org/distributions/gradle-7.2-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
''');

      // Download gradle-wrapper.jar
      final wrapperJar = File(path.join(androidDir.path, 'gradle/wrapper/gradle-wrapper.jar'));
      final response = await HttpClient().getUrl(Uri.parse(
        'https://raw.githubusercontent.com/gradle/gradle/v7.2.0/gradle/wrapper/gradle-wrapper.jar'
      ));
      final download = await response.close();
      await download.pipe(wrapperJar.openWrite());

      // Create gradlew script
      final gradlew = File(path.join(androidDir.path, 'gradlew'));
      await gradlew.writeAsString('''
#!/bin/sh
exec "\$(dirname "\$0")"/gradlew "\$@"
''');
      await Process.run('chmod', ['+x', gradlew.path]);
    }

    // Build and run
    print('Building Android app...');
    final buildResult = await Process.run(
      './gradlew', 
      ['assembleDebug'], 
      workingDirectory: androidDir.path
    );
    
    if (buildResult.exitCode != 0) {
      print('Error building Android app: \${buildResult.stderr}');
      exit(1);
    }

    // Install on device/emulator
    print('Installing on device...');
    final installResult = await Process.run(
      'adb', 
      ['install', 'app/build/outputs/apk/debug/app-debug.apk'],
      workingDirectory: androidDir.path
    );

    if (installResult.exitCode != 0) {
      print('Error installing app: \${installResult.stderr}');
      exit(1);
    }

    print('App installed successfully!');
  }
}
