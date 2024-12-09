import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformView extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createView(id, props);
  }
}
