class AuthorModel {
  final String id;
  final String username;
  final String avatar;

  AuthorModel({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}
