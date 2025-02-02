class UserWhoLikedDto {
  final String id;
  final String username;
  final String avatar;

  UserWhoLikedDto({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory UserWhoLikedDto.fromJson(Map<String, dynamic> json) {
    return UserWhoLikedDto(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
    );
  }
}