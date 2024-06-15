// test/transpiler_test.dart
import 'package:test/test.dart';
import 'package:dart_glue/parser/dart_parser.dart';
import 'package:dart_glue/transformer/dart_to_swift_transformer.dart';
import 'package:dart_glue/generator/swift_generator.dart';
import 'package:dart_glue/transformer/dart_to_kotlin_transformer.dart';
import 'package:dart_glue/generator/kotlin_generator.dart';
import 'package:dart_glue/transformer/component_mapper.dart';

void main() async {
  var componentMapper = await ComponentMapper.loadFromFile('config/components_map.json');

  test('Transpile Dart Text with properties to Swift', () {
    var dartCode = '''
      Text(
        'Hello, World!',
        style: TextStyle(fontSize: 20, color: Colors.blue),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis
      );
    ''';

    var parser = DartParser();
    var unit = parser.parse(dartCode);
    
    var transformer = DartToSwiftTransformer(componentMapper);
    var transformedCode = transformer.transform(unit);
    
    var generator = SwiftGenerator();
    var swiftCode = generator.generate(transformedCode);
    
    var expectedSwiftCode = '''
Text("Hello, World!")
  .font(.system(size: 20))
  .foregroundColor(.blue)
  .multilineTextAlignment(.center)
  .lineLimit(2)
  .truncationMode(.tail)
''';
    
    expect(swiftCode.trim(), expectedSwiftCode.trim());
  });

  test('Transpile Dart Text with properties to Kotlin', () {
    var dartCode = '''
      Text(
        'Hello, World!',
        style: TextStyle(fontSize: 20, color: Colors.blue),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis
      );
    ''';

    var parser = DartParser();
    var unit = parser.parse(dartCode);
    
    var transformer = DartToKotlinTransformer(componentMapper);
    var transformedCode = transformer.transform(unit);
    
    var generator = KotlinGenerator();
    var kotlinCode = generator.generate(transformedCode);
    
    var expectedKotlinCode = '''
Text(
  text = "Hello, World!",
  style = TextStyle(fontSize = 20.sp, color = Color.Blue),
  textAlign = TextAlign.Center,
  maxLines = 2,
  overflow = TextOverflow.Ellipsis
)
''';
    
    expect(kotlinCode.trim(), expectedKotlinCode.trim());
  });

  test('Transpile Dart Container with properties to Swift', () {
    var dartCode = '''
      Container(
        width: 100,
        height: 50,
        color: Colors.red,
        borderRadius: BorderRadius.circular(10)
      );
    ''';

    var parser = DartParser();
    var unit = parser.parse(dartCode);
    
    var transformer = DartToSwiftTransformer(componentMapper);
    var transformedCode = transformer.transform(unit);
    
    var generator = SwiftGenerator();
    var swiftCode = generator.generate(transformedCode);
    
    var expectedSwiftCode = '''
ZStack {
  Rectangle()
    .frame(width: 100, height: 50)
    .background(Color.red)
    .cornerRadius(10)
}
''';
    
    expect(swiftCode.trim(), expectedSwiftCode.trim());
  });

  test('Transpile Dart Container with properties to Kotlin', () {
    var dartCode = '''
      Container(
        width: 100,
        height: 50,
        color: Colors.red,
        borderRadius: BorderRadius.circular(10)
      );
    ''';

    var parser = DartParser();
    var unit = parser.parse(dartCode);
    
    var transformer = DartToKotlinTransformer(componentMapper);
    var transformedCode = transformer.transform(unit);
    
    var generator = KotlinGenerator();
    var kotlinCode = generator.generate(transformedCode);
    
    var expectedKotlinCode = '''
Box(
  modifier = Modifier
    .size(width = 100.dp, height = 50.dp)
    .background(color = Color.Red, shape = RoundedCornerShape(10.dp))
)
''';
    
    expect(kotlinCode.trim(), expectedKotlinCode.trim());
  });
}
