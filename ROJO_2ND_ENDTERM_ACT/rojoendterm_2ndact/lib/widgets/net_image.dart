import 'package:flutter/material.dart';

class NetImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadiusGeometry? borderRadius;

  const NetImage(this.url, {super.key, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final img = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Theme.of(context).colorScheme.surfaceVariant,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image_outlined),
      ),
      loadingBuilder: (c, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Theme.of(context).colorScheme.surfaceVariant,
          alignment: Alignment.center,
          child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
        );
      },
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}


