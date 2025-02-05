import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/post_model.dart';
import '../services/image_service.dart';
import '../widgets/image_previewer.dart';

Widget buildImage({
  required String? imageUrl,
  PostModel? post,
  double width = 50,
  double height = 50,
  double borderRadius = 25.0,
  Color placeholderColor = const Color(0xFFE0E0E0),
  IconData placeholderIcon = Icons.person,
  bool disableActions = false,
  required BuildContext context,
}) {
  final imageService = RepositoryProvider.of<ImageService>(context);

  if (imageUrl == null || imageUrl.isEmpty) {
    return _buildPlaceholder(borderRadius, placeholderColor, placeholderIcon);
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

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImagePreviewer(
                  imageUrl: imageUrl,
                  post: post,
                  disableActions: disableActions,
                ),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(
              imageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _buildPlaceholder(borderRadius, placeholderColor, Icons.broken_image),
            ),
          ),
        );
      },
    );
  } else if (imageUrl.startsWith('data:image')) {
    final base64String = imageUrl.split(',').last;
    final bytes = base64Decode(base64String);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewer(
              imageUrl: imageUrl,
              post: post,
              disableActions: disableActions,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.memory(
          bytes,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholder(borderRadius, placeholderColor, Icons.broken_image),
        ),
      ),
    );
  } else {
    return _buildPlaceholder(borderRadius, placeholderColor, placeholderIcon);
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
    child: const CircularProgressIndicator(strokeWidth: 2),
  );
}