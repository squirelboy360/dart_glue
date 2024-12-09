import 'dart:io';

class AndroidProjectTemplate {
  Future<void> createAndroidProject(String projectName, Directory projectDir) async {
    final androidDir = Directory('${projectDir.path}/android');
    await androidDir.create(recursive: true);
    
    // Use Android SDK tools to create base project
    final result = await Process.run('android', [
      'create', 
      'project',
      '--path', androidDir.path,
      '--package', 'com.${projectName.toLowerCase()}',
      '--activity', 'MainActivity',
      '--target', 'android-33'  // Latest stable Android API
    ]);

    if (result.exitCode != 0) {
      throw Exception('Failed to create Android project: ${result.stderr}');
    }

    // Add our bridge files to existing structure
    await _createBridgeFiles(androidDir, projectName);
    await _updateGradleFiles(androidDir, projectName);
  }

  Future<void> _createBridgeFiles(Directory androidDir, String projectName) async {
    final javaDir = Directory('${androidDir.path}/app/src/main/java/com/${projectName.toLowerCase()}/bridge');
    await javaDir.create(recursive: true);

    // Create bridge files
    await File('${javaDir.path}/DNBridge.java').writeAsString('''
package com.${projectName.toLowerCase()}.bridge;

// ...existing DNBridge implementation...
''');

    // Create native bridge C++ file
    final cppDir = Directory('${androidDir.path}/app/src/main/cpp');
    await cppDir.create(recursive: true);

    await File('${cppDir.path}/native_bridge.cpp').writeAsString('''
// ...existing native_bridge.cpp implementation...
''');
  }

  Future<void> _updateGradleFiles(Directory androidDir, String projectName) async {
    // Update app/build.gradle to add C++ support
    final buildGradle = File('${androidDir.path}/app/build.gradle');
    String content = await buildGradle.readAsString();
    
    content = content.replaceAll(
      'android {',
      '''android {
    externalNativeBuild {
        cmake {
            path "CMakeLists.txt"
        }
    }'''
    );

    await buildGradle.writeAsString(content);

    // Add CMakeLists.txt
    await File('${androidDir.path}/app/CMakeLists.txt').writeAsString('''
cmake_minimum_required(VERSION 3.4.1)

add_library(native_bridge SHARED
            src/main/cpp/native_bridge.cpp)

target_link_libraries(native_bridge
                     android
                     log)
''');
  }
}
