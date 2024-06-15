// lib/cli/main.dart
import '../parser/dart_parser.dart';
import '../transformer/dart_to_swift_transformer.dart';
import '../transformer/dart_to_kotlin_transformer.dart';
import '../generator/swift_generator.dart';
import '../generator/kotlin_generator.dart';
import '../transformer/component_mapper.dart';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 3) {
    print('Usage: dart main.dart <input_file.dart> <output_file> <platform>');
    return;
  }

  var inputFile = args[0];
  var outputFile = args[1];
  var platform = args[2];

  var code = File(inputFile).readAsStringSync();

  var parser = DartParser();
  var unit = parser.parse(code);

  String transformedCode;
  String outputCode = ''; // Initialize outputCode with an empty string

  // Load ComponentMapper
  var componentMapper =
      await ComponentMapper.loadFromFile('config/components_map.json');

  if (platform == 'swift') {
    var transformer = DartToSwiftTransformer(componentMapper);
    transformedCode = transformer.transform(unit);

    var generator = SwiftGenerator();
    outputCode = generator.generate(transformedCode);
  } else if (platform == 'kotlin') {
    var transformer = DartToKotlinTransformer(componentMapper);
    transformedCode = transformer.transform(unit);

    var generator = KotlinGenerator();
    outputCode = generator.generate(transformedCode);
  } else {
    print('Unsupported platform: $platform');
    return;
  }

  File(outputFile).writeAsStringSync(outputCode);
  print('Transpilation complete. Output written to $outputFile');
}
