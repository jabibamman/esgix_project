import 'author_model.dart';

class PostModel {
  final String id;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  bool likedByUser;
  final int commentCount;
  final AuthorModel author;
  final String? parent;

  PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.likedByUser,
    required this.commentCount,
    required this.author,
    this.parent,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl']?.isEmpty ?? true ? null : json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      likeCount: int.tryParse(json['likesCount']?.toString() ?? '0') ?? 0,
      likedByUser: json['likedByUser'] ?? true,
      commentCount: int.tryParse(json['commentsCount']?.toString() ?? '0') ?? 0,
      author: AuthorModel.fromJson(json['author']),
      parent: json['parent']?.isEmpty ?? true ? null : json['parent'],
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
      'likedByUser': likedByUser,
      'commentCount': commentCount,
      'author': author.toJson(),
      'parent': parent,
    };
  }
}