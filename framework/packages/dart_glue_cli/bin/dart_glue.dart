import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:dart_glue_cli/src/commands/create_command.dart';
import 'package:dart_glue_cli/src/commands/run_command.dart';


void main(List<String> args) {
  final runner = CommandRunner('dg', 'Dart Glue framework CLI')
    ..addCommand(CreateCommand())
    ..addCommand(RunCommand());

  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });
}