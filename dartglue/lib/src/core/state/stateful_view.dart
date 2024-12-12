// lib/src/core/stateful_view.dart
import 'package:dartglue/dartglue.dart';
import 'package:dartglue/src/core/types.dart';
import 'package:dartglue/src/native/bridge.dart';
import 'package:meta/meta.dart';

abstract class StatefulView extends View {
  StatefulView({super.width, super.height, super.backgroundColor}) {
    initState();
  }

  @protected
  void initState();

  @protected
  void onStateChanged();

  @protected
  void setState(VoidCallback fn) {
    fn();
    onStateChanged();
    Bridge.instance.updateViewProps(internalHandle, buildProperties());
  }

  @protected
  Map<String, dynamic> buildProperties();
}
