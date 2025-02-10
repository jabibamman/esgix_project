import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/post_model.dart';
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
  bool disableOpenDetail = false,
  required BuildContext context,
}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return _buildPlaceholder(borderRadius, placeholderColor, placeholderIcon);
  }
  
  if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
    return GestureDetector(
      onTap: disableOpenDetail
          ? null
          : () {
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildLoadingIndicator(borderRadius),
          errorWidget: (context, url, error) {
            return _buildPlaceholder(borderRadius, placeholderColor, Icons.broken_image);
          },
        )
      ),
    );
  }

  if (imageUrl.startsWith('data:image')) {
    try {
      final base64String = imageUrl.split(',').last;
      final bytes = base64Decode(base64String);
      return GestureDetector(
        onTap: disableOpenDetail
            ? null
            : () {
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
    } catch (e) {
      return _buildPlaceholder(borderRadius, placeholderColor, Icons.broken_image);
    }
  }

  return _buildPlaceholder(borderRadius, placeholderColor, placeholderIcon);
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
