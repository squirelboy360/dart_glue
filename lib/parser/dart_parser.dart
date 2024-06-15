import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';

class DartParser {
  CompilationUnit parse(String code) {
    return parseString(content: code).unit;
  }
}