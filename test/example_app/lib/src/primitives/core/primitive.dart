import 'dart:convert';
import '../../bridge/platform_bridge.dart';

abstract class Primitive {
  final String id;
  final Map<String, dynamic>? style;
  final List<Primitive> children;
  
  const Primitive({
    required this.id,
    this.style,
    this.children = const [],
  });
    
  Map<String, dynamic> get props;
  
  void create() {
    final propsJson = {
      ...props,
      if (style != null) 'style': style,
      'children': children.map((child) => child.props).toList(),
    };
    createNative(propsJson);
    
    for (final child in children) {
      child.create();
    }
  }
  
  void createNative(Map<String, dynamic> props);
}
