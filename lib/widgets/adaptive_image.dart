import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A widget that displays either a network image or a local asset image
/// based on the image path/URL provided.
class AdaptiveImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AdaptiveImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isNetworkImage(imagePath)) {
      // Use CachedNetworkImage for network images
      return CachedNetworkImage(
        imageUrl: imagePath,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => placeholder ?? Container(
          width: width,
          height: height,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => errorWidget ?? Container(
          width: width,
          height: height,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_not_supported, size: 40),
        ),
      );
    } else {
      // Use Image.asset for local assets
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => errorWidget ?? Container(
          width: width,
          height: height,
          color: theme.colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.image_not_supported, size: 40),
        ),
      );
    }
  }
}

/// A provider for avatar images that can handle both network and local assets
class AdaptiveImageProvider extends ImageProvider<Object> {
  final String imagePath;
  
  late final ImageProvider _delegate;

  AdaptiveImageProvider(this.imagePath) {
    _delegate = _isNetworkImage(imagePath)
        ? CachedNetworkImageProvider(imagePath) as ImageProvider
        : AssetImage(imagePath);
  }

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Future<Object> obtainKey(ImageConfiguration configuration) {
    return _delegate.obtainKey(configuration);
  }

  @override
  ImageStreamCompleter loadImage(Object key, ImageDecoderCallback decode) {
    return _delegate.loadImage(key, decode);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is AdaptiveImageProvider && other.imagePath == imagePath;
  }

  @override
  int get hashCode => imagePath.hashCode;
}
