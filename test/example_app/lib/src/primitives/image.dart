import 'core/platform_image.dart';

class Image extends PlatformImage {
  final String source;
  
  Image(
    this.source, {
    Map<String, dynamic>? style,
  }) : super(style: style);

  @override
  Map<String, dynamic> get props => {
    'type': 'image',
    'source': source,
  };
}
