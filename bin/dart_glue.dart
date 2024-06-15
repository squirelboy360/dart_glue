import 'dart:io';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    print('Usage: dart main.dart <file_path>');
    return;
  }

  var filePath = arguments[0];
  var file = File(filePath);

  if (!file.existsSync()) {
    print('File not found: $filePath');
    return;
  }

  var contents = file.readAsStringSync();
  print('File contents:');
  print(contents);
}
