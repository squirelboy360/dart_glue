import 'package:args/command_runner.dart';
import 'package:dart_glue_cli/dart_glue_cli.dart';

void main(List<String> args) {
  CommandRunner('dart_glue', 'Dart Glue CLI tool')
    ..addCommand(CreateCommand())
    ..addCommand(ExampleCommand())
    ..run(args);
}