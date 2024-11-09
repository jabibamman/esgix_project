class PostModel {
  final String id;
  final String content;
  final String? imageUrl;
  final String createdAt;
  final String updatedAt;
  final int likeCount;
  final int commentCount;

  PostModel({
    required this.id,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    required this.commentCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}