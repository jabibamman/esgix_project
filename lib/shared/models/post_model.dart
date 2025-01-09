import 'author_model.dart';

class PostModel {
  final String id;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final int commentCount;
  final AuthorModel author;
  final String? parent;
  final bool isLiked;

  PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.author,
    this.parent,
    required this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl']?.isEmpty ?? true ? null : json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      likeCount: int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,
      commentCount: int.tryParse(json['commentsCount']?.toString() ?? '0') ?? 0,
      author: AuthorModel.fromJson(json['author']),
      parent: json['parent']?.isEmpty ?? true ? null : json['parent'],
      isLiked: json['isLiked'] ?? false,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'likeCount': likeCount,
      'commentCount': commentCount,
      'author': author.toJson(),
      'parent': parent,
      'isLiked': isLiked,
    };
  }
}
