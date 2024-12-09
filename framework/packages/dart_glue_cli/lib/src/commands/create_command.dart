import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dart_glue_cli/src/templates/project_template.dart';


class CreateCommand extends Command {
  @override
  final name = 'create';
  
  @override
  final description = 'Create a new Dart Glue project';
  
  CreateCommand() {
    argParser.addOption(
      'project-name',
      abbr: 'n',
      help: 'Name of the project to create',
      mandatory: true
    );
  }
  
  @override
  Future<void> run() async {
    final projectName = argResults!['project-name'];
    print('Creating Dart Glue project: $projectName');
    
    final projectDir = Directory(projectName);
    final creator = ProjectCreator(
      projectName: projectName,
      projectDir: projectDir
    );
    
    await creator.createProject();
  }
}

void main(List<String> args) {
  final runner = CommandRunner('dart_glue', 'Dart Glue framework CLI')
    ..addCommand(CreateCommand());
    
  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}