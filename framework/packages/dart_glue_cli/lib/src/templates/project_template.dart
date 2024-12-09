// File: packages/dart_glue_cli/lib/src/templates/project_template.dart
import 'dart:io';
import 'package:path/path.dart' as path;
import 'ios_template.dart';
import 'android_template.dart';

class ProjectCreator {
  final String projectName;
  final Directory projectDir;

  ProjectCreator({
    required this.projectName,
    required this.projectDir,
  });

  Future<void> createProject() async {
    await _createProjectStructure();
    await _createDartProject();
    await _createPubspec();
    
    final iosTemplate = IosProjectTemplate();
    await iosTemplate.createXcodeProject(Directory('${projectDir.path}/ios'));
    
    final androidTemplate = AndroidProjectTemplate();
    await androidTemplate.createAndroidProject(projectName, projectDir);
  }

  Future<void> _createProjectStructure() async {
    await projectDir.create(recursive: true);
  }

  Future<void> _createDartProject() async {
    final libDir = Directory('${projectDir.path}/lib');
    await libDir.create();
    
    // Create directory structure
    final srcDir = Directory('${libDir.path}/src');
    await srcDir.create();
    
    final primitivesDir = Directory('${srcDir.path}/primitives');
    await primitivesDir.create();
    
    final bridgeDir = Directory('${srcDir.path}/bridge');
    await bridgeDir.create();
    
    final platformDir = Directory('${srcDir.path}/platform');
    await platformDir.create();

    // Create platform-specific implementations
    await _createPlatformFiles(platformDir);
    await _createBridgeFiles(bridgeDir);
    await _createPrimitiveFiles(primitivesDir);
    await _createMainFile(libDir);
  }

  Future<void> _createPlatformFiles(Directory platformDir) async {
    // Create iOS platform implementation
    await File('${platformDir.path}/ios_platform.dart').writeAsString('''
import '../primitives/core/platform_view.dart';
import '../primitives/core/platform_text.dart';
import '../primitives/core/platform_button.dart';
import '../primitives/core/platform_image.dart';

class IosPlatform implements PlatformImplementation {
  @override
  void createView(String viewId, Map<String, dynamic> props) {
    // iOS-specific view creation
  }
  
  @override
  void createText(String viewId, Map<String, dynamic> props) {
    // iOS-specific text creation
  }
  
  @override
  void createButton(String viewId, Map<String, dynamic> props) {
    // iOS-specific button creation
  }
  
  @override
  void createImage(String viewId, Map<String, dynamic> props) {
    // iOS-specific image creation
  }
}
''');

    // Create Android platform implementation
    await File('${platformDir.path}/android_platform.dart').writeAsString('''
import '../primitives/core/platform_view.dart';
import '../primitives/core/platform_text.dart';
import '../primitives/core/platform_button.dart';
import '../primitives/core/platform_image.dart';

class AndroidPlatform implements PlatformImplementation {
  @override
  void createView(String viewId, Map<String, dynamic> props) {
    // Android-specific view creation
  }
  
  @override
  void createText(String viewId, Map<String, dynamic> props) {
    // Android-specific text creation
  }
  
  @override
  void createButton(String viewId, Map<String, dynamic> props) {
    // Android-specific button creation
  }
  
  @override
  void createImage(String viewId, Map<String, dynamic> props) {
    // Android-specific image creation
  }
}
''');

    // Create platform interface
    await File('${platformDir.path}/platform_interface.dart').writeAsString('''
abstract class PlatformImplementation {
  void createView(String viewId, Map<String, dynamic> props);
  void createText(String viewId, Map<String, dynamic> props);
  void createButton(String viewId, Map<String, dynamic> props);
  void createImage(String viewId, Map<String, dynamic> props);
}
''');
  }

  Future<void> _createBridgeFiles(Directory bridgeDir) async {
    await File('${bridgeDir.path}/platform_bridge.dart').writeAsString('''
import 'dart:io';
import '../platform/ios_platform.dart';
import '../platform/android_platform.dart';
import '../platform/platform_interface.dart';

class PlatformBridge {
  static final PlatformBridge instance = PlatformBridge._();
  late final PlatformImplementation _platform;

  PlatformBridge._() {
    if (Platform.isIOS) {
      _platform = IosPlatform();
    } else if (Platform.isAndroid) {
      _platform = AndroidPlatform();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void createView(String viewId, Map<String, dynamic> props) {
    _platform.createView(viewId, props);
  }

  void createText(String viewId, Map<String, dynamic> props) {
    _platform.createText(viewId, props);
  }

  void createButton(String viewId, Map<String, dynamic> props) {
    _platform.createButton(viewId, props);
  }

  void createImage(String viewId, Map<String, dynamic> props) {
    _platform.createImage(viewId, props);
  }
}
''');
  }

  Future<void> _createPrimitiveFiles(Directory primitivesDir) async {
    // Create core primitives directory
    final coreDir = Directory('${primitivesDir.path}/core');
    await coreDir.create();

    // Create base primitive
    await File('${coreDir.path}/primitive.dart').writeAsString('''
import 'dart:convert';
import '../../bridge/platform_bridge.dart';

abstract class Primitive {
  final String id;
  final Map<String, dynamic> style;
  final List<Primitive> children;
  
  Primitive({
    Map<String, dynamic>? style,
    this.children = const [],
  }) : 
    id = 'primitive_\${DateTime.now().microsecondsSinceEpoch}',
    style = style ?? {};
    
  Map<String, dynamic> get props;
  
  void create() {
    final propsJson = {
      ...props,
      'style': style,
      'children': children.map((child) => child.props).toList(),
    };
    createNative(propsJson);
    
    for (final child in children) {
      child.create();
    }
  }
  
  void createNative(Map<String, dynamic> props);
}
''');

    // Create platform-specific primitive interfaces
    await File('${coreDir.path}/platform_view.dart').writeAsString('''
import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformView extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createView(id, props);
  }
}
''');

    await File('${coreDir.path}/platform_text.dart').writeAsString('''
import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformText extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createText(id, props);
  }
}
''');

    await File('${coreDir.path}/platform_button.dart').writeAsString('''
import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformButton extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createButton(id, props);
  }
}
''');

    await File('${coreDir.path}/platform_image.dart').writeAsString('''
import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformImage extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createImage(id, props);
  }
}
''');

    // Create concrete primitives
    await File('${primitivesDir.path}/view.dart').writeAsString('''
import 'core/platform_view.dart';

class View extends PlatformView {
  View({
    Map<String, dynamic>? style,
    List<Primitive> children = const [],
  }) : super(style: style, children: children);

  @override
  Map<String, dynamic> get props => {
    'type': 'view',
  };
}
''');

    await File('${primitivesDir.path}/text.dart').writeAsString('''
import 'core/platform_text.dart';

class Text extends PlatformText {
  final String text;
  
  Text(
    this.text, {
    Map<String, dynamic>? style,
  }) : super(style: style);

  @override
  Map<String, dynamic> get props => {
    'type': 'text',
    'text': text,
  };
}
''');

    await File('${primitivesDir.path}/button.dart').writeAsString('''
import 'core/platform_button.dart';

class Button extends PlatformButton {
  final String text;
  final void Function() onPressed;
  
  Button({
    required this.text,
    required this.onPressed,
    Map<String, dynamic>? style,
  }) : super(style: style);

  @override
  Map<String, dynamic> get props => {
    'type': 'button',
    'text': text,
    'onPressed': true,
  };
}
''');

    await File('${primitivesDir.path}/image.dart').writeAsString('''
import 'core/platform_image.dart';

class Image extends PlatformImage {
  final String source;
  
  Image(
    this.source, {
    Map<String, dynamic>? style,
  }) : super(style: style);

  @override
  Map<String, dynamic> get props => {
    'type': 'image',
    'source': source,
  };
}
''');
  }

  Future<void> _createMainFile(Directory libDir) async {
    await File('${libDir.path}/main.dart').writeAsString('''
import 'package:dart_glue/primitives/view.dart';
import 'package:dart_glue/primitives/text.dart';
import 'package:dart_glue/primitives/button.dart';
import 'package:dart_glue/primitives/image.dart';

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
''');
  }

  Future<void> _createPubspec() async {
    await File('${projectDir.path}/pubspec.yaml').writeAsString('''
name: $projectName
description: A new Dart Glue project
version: 1.0.0+1

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  dart_glue: ^1.0.0
  ffi: ^2.0.1

dev_dependencies:
  lints: ^2.0.0
  test: ^1.16.0
''');
  }
}
