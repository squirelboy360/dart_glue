import 'dart:convert';
import '../../bridge/platform_bridge.dart';

abstract class Primitive {
  final String id;
  final Map<String, dynamic> style;
  final List<Primitive> children;
  
  Primitive({
    Map<String, dynamic>? style,
    this.children = const [],
  }) : 
    id = 'primitive_${DateTime.now().microsecondsSinceEpoch}',
    style = style ?? {};
    
  Map<String, dynamic> get props;
  
  void create() {
    final propsJson = {
      ...props,
      'style': style,
      'children': children.map((child) => child.props).toList(),
    };
    createNative(propsJson);
    
    for (final child in children) {
      child.create();
    }
  }
  
  void createNative(Map<String, dynamic> props);
}
