
import 'dart:io';
import 'package:args/command_runner.dart';
import '../templates/example_template.dart';

class ExampleCommand extends Command {
  @override
  String get description => 'Create a new example Dart Glue app';

  @override
  String get name => 'create-example';

  ExampleCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      help: 'Name of the example app',
      defaultsTo: 'dart_glue_example',
    );
  }

  @override
  Future<void> run() async {
    final projectName = argResults?['name'] as String;
    final projectDir = Directory('${Directory.current.path}/$projectName');
    
    print('Creating example app in ${projectDir.path}...');
    
    final creator = ExampleTemplate(
      projectName: projectName,
      projectDir: projectDir,
    );
    
    await creator.create();
    print('Example app created successfully!');
  }
}