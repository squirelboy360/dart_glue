import 'primitive.dart';
import '../../bridge/platform_bridge.dart';

abstract class PlatformView implements Primitive {
  const PlatformView({
    super.style,
    super.children,
  });

  @override
  void createNative(Map<String, dynamic> props) {
    PlatformBridge.instance.createView(id, props);
  }
}
