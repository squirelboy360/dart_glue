
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dartglue <command>');
    exit(1);
  }

  switch (args[0]) {
    case 'create':
      if (args.length < 2) {
        print('Usage: dartglue create <project_name>');
        exit(1);
      }
      createProject(args[1]);
      break;
    case 'run':
      runProject();
      break;
    default:
      print('Unknown command: ${args[0]}');
      exit(1);
  }
}

void createProject(String name) {
  print('Creating new DartGlue project: $name');
  // Project creation logic will go here
}

void runProject() {
  print('Running DartGlue project');
  // Run logic will go here
}
// Project creation logic
class ProjectCreator {
  static Future<void> create(String name, String platform) async {
    final result = await Process.run(
      'dart',
      ['run', 'tool/create_project.dart', name, platform],
    );

    if (result.exitCode != 0) {
      print('Failed to create project: ${result.stderr}');
      exit(1);
    }

    print('Project $name created successfully!');
  }
}
