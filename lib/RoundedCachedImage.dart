import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RoundedCachedImage extends StatelessWidget {
  final String imageUrl;

  const RoundedCachedImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey,
          child: const Icon(Icons.broken_image, color: Colors.white),
        ),
      ),
    );
  }
}