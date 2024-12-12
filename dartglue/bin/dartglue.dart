import 'dart:io';
import '../tool/hot_reload.dart';
import '../tool/project_creator.dart';
import '../tool/project_runner.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dartglue <command>');
    exit(1);
  }

  try {
    switch (args[0]) {
      case 'create':
        if (args.length < 2) {
          print('Usage: dartglue create <project_name>');
          exit(1);
        }
        await ProjectCreator.createProject(args[1]);
        print(
            'Project created successfully!\nRun:\n  cd ${args[1]}\n  dart run');
        break;

      case 'run':
        final useHotReload = args.contains('--hot');
        if (useHotReload) {
          await HotReloader.startWatching();
        }
        // await runProject();
        if (Platform.isAndroid) {
          await ProjectRunner.runAndroid();
        } else if (Platform.isIOS) {
          await ProjectRunner.runIos();
        }
        break;

      default:
        print('Unknown command: ${args[0]}');
        exit(1);
    }
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
