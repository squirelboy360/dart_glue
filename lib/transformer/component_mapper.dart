// lib/transformer/component_mapper.dart
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

class ComponentMapper {
  final Map<String, Map<String, dynamic>> _componentsMap;

  ComponentMapper(this._componentsMap);

  String mapComponent(String component, String platform) {
    return _componentsMap[component]?[platform]?['component'] ?? component;
  }

  String mapProps(String component, String platform, String props) {
    var propsMap = _componentsMap[component]?[platform]?['props'] as Map<String, String>;
    var propList = _parseProps(props);
    var mappedProps = propList.map((prop) {
      var propName = prop['name'] ?? '';
      var propValue = prop['value'] ?? '';
      var mappedPropName = propsMap[propName] ?? propName;
      return '$mappedPropName: $propValue';
    }).join(', ');
    return mappedProps;
  }

  List<Map<String, String>> _parseProps(String props) {
    var propList = props.split(',');
    return propList.map((prop) {
      var propParts = prop.split(':');
      var propName = propParts[0].trim();
      var propValue = propParts[1].trim();
      return {'name': propName, 'value': propValue};
    }).toList();
  }

  static Future<ComponentMapper> loadFromFile(String filePath) async {
    var configPath = path.join(Directory.current.path, filePath);
    var configFile = File(configPath);
    var jsonString = await configFile.readAsString();
    var jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    var componentsMap = jsonMap.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value)));
    return ComponentMapper(componentsMap);
  }
}
