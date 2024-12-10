
import 'core/platform_view.dart';

class View extends PlatformView {
  View({
    super.style,
    super.children = const [],
  });

  @override
  Map<String, dynamic> get props => {
    'type': 'view',
  };
}

