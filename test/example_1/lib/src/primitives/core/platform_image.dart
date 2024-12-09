import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformImage extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createImage(id, props);
  }
}
