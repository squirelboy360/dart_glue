import 'dart:io';
import '../platform/ios_platform.dart';
import '../platform/android_platform.dart';
import '../platform/platform_interface.dart';

class PlatformBridge {
  static final PlatformBridge instance = PlatformBridge._();
  late final PlatformImplementation _platform;

  PlatformBridge._() {
    if (Platform.isIOS) {
      _platform = IosPlatform();
    } else if (Platform.isAndroid) {
      _platform = AndroidPlatform();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  void createView(String viewId, Map<String, dynamic> props) {
    _platform.createView(viewId, props);
  }

  void createText(String viewId, Map<String, dynamic> props) {
    _platform.createText(viewId, props);
  }

  void createButton(String viewId, Map<String, dynamic> props) {
    _platform.createButton(viewId, props);
  }

  void createImage(String viewId, Map<String, dynamic> props) {
    _platform.createImage(viewId, props);
  }
}
