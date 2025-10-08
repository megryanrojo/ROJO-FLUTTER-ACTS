import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double? width;
  final double? height;

  const PlaceholderImage({
    super.key,
    required this.text,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 50,
              color: textColor.withOpacity(0.7),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
