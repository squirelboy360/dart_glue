import 'core/platform_view.dart';

class View extends PlatformView {
  View({
    Map<String, dynamic>? style,
    List<Primitive> children = const [],
  }) : super(style: style, children: children);

  @override
  Map<String, dynamic> get props => {
    'type': 'view',
  };
}
