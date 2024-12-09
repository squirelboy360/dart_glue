import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformButton extends Primitive {
  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createButton(id, props);
  }
}
