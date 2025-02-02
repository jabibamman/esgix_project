import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/image_service.dart';

Widget buildImage({
  required String? imageUrl,
  double width = 50,
  double height = 50,
  double borderRadius = 25.0,
  Color placeholderColor = const Color(0xFFE0E0E0),
  IconData placeholderIcon = Icons.person,
  required BuildContext context,
}) {
  final imageService = RepositoryProvider.of<ImageService>(context);

  if (imageUrl == null || imageUrl.isEmpty) {
    return CircleAvatar(
      radius: borderRadius,
      backgroundColor: placeholderColor,
      child: Icon(placeholderIcon, color: Colors.grey),
    );
  } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
    return FutureBuilder<bool>(
      future: imageService.isImageAvailable(imageUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator(borderRadius);
        }
        if (snapshot.hasError || !(snapshot.data ?? false)) {
          return _buildPlaceholder(borderRadius, placeholderColor, Icons.broken_image);
        }
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(borderRadius, placeholderColor, Icons.broken_image),
          ),
        );
      },
    );
  } else if (imageUrl.startsWith('data:image')) {
    final base64String = imageUrl.split(',').last;
    final bytes = base64Decode(base64String);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.memory(
        bytes,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: borderRadius,
          backgroundColor: placeholderColor,
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      ),
    );
  } else {
    return CircleAvatar(
      radius: borderRadius,
      backgroundColor: placeholderColor,
      child: Icon(placeholderIcon, color: Colors.grey),
    );
  }
}

Widget _buildPlaceholder(double radius, Color color, IconData icon) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: color,
    child: Icon(icon, color: Colors.grey),
  );
}

Widget _buildLoadingIndicator(double radius) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: Colors.grey.shade200,
    child: CircularProgressIndicator(strokeWidth: 2),
  );
}
