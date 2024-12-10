import 'core/platform_image.dart';

class Image extends PlatformImage {
  Map<String, dynamic>? style;
  final String source;

  Image(
    this.source, {
    Map<String, dynamic>? style,
  });

  @override
  Map<String, dynamic> get props => {
        'type': 'image',
        'source': source,
      };
}

