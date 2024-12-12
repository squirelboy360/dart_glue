import 'package:dartglue/dartglue.dart';
import 'package:meta/meta.dart';
import '../native/bridge.dart';
import 'utils/view.dart';

class View {
  @protected
  final int _handle;
  final List<View> _children = [];
  
  @internal
  int get internalHandle => _handle;
  
  View({
    double? width,
    double? height,
    String? backgroundColor,
    List<View> children = const [],
    EdgeInsets padding = const EdgeInsets.all(0),
  }) : _handle = Bridge.instance.createView(ViewType.view.index) {
    Bridge.instance.updateViewProps(_handle, {
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      'padding': {
        'left': padding.left,
        'top': padding.top,
        'right': padding.right,
        'bottom': padding.bottom,
      },
    });
    addChildren(children);
  }

  void addChildren(List<View> children) {
    _children.addAll(children);
    Bridge.instance.updateViewProps(_handle, {
      'children': _children.map((v) => v.internalHandle).toList()
    });
  }
}
