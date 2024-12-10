import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformText implements Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createText(id, props);
  }
}
