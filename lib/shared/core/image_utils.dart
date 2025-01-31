import 'dart:convert';
import 'package:flutter/material.dart';

Widget buildImage({
  required String? imageUrl,
  double width = 50,
  double height = 50,
  double borderRadius = 25.0,
  Color placeholderColor = const Color(0xFFE0E0E0),
  IconData placeholderIcon = Icons.person,
}) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return CircleAvatar(
      radius: borderRadius,
      backgroundColor: placeholderColor,
      child: Icon(placeholderIcon, color: Colors.grey),
    );
  } else if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
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
