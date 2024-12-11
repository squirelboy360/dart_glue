// lib/src/native/bridge.dart

import 'dart:convert' show jsonEncode;
import 'package:dartglue/dartglue.dart';
import 'package:dartglue/src/core/utils/view.dart';
import 'package:ffi/ffi.dart';

// lib/src/core/view.dart
class NativeView {
  final int _handle;
  final Map<String, dynamic> _properties = {};

  NativeView({
    double? width,
    double? height,
    String? backgroundColor,
  }) : _handle = NativeBridge.instance.createView(ViewType.view.index) {
    updateProps({
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
    });
  }

  void updateProps(Map<String, dynamic> props) {
    _properties.addAll(props);
    // Convert to native pointer that C can understand
    final propsStr = jsonEncode(_properties);
    final nativeStr = propsStr.toNativeUtf8();
    NativeBridge.instance.setViewProps(_handle, nativeStr.cast());
    malloc.free(nativeStr);
  }
}
