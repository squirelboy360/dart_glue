import 'package:dartglue/dartglue.dart';
import 'package:dartglue/src/native/bridge.dart';

void runApp(View root) {
  Bridge.instance.mount(root);
}