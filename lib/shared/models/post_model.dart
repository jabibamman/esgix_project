class PostModel {
  final String id;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final int commentCount;
  final String authorUsername;
  final String? authorAvatar;
  final String? parent;

  PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
    required this.authorUsername,
    this.authorAvatar,
    this.parent,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl']?.isEmpty ?? true ? null : json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      likeCount: json['likesCount'] ?? 0,
      commentCount: json['commentsCount'] ?? 0,
      authorUsername: json['author']['username'],
      authorAvatar: json['author']['avatar']?.isEmpty ?? true ? null : json['author']['avatar'],
      parent: json['parent']?.isEmpty ?? true ? null : json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'author': {
        'username': authorUsername,
        'avatar': authorAvatar,
      },
      'parent': parent,
    };
  }
}
