import 'package:esgix_project/shared/models/user_model.dart';

class UserUpdateDto {
  final String? username;
  final String? description;
  final String? avatar;

  UserUpdateDto({
    this.username,
    this.description,
    this.avatar,
  });

  factory UserUpdateDto.fromJson(Map<String, dynamic> json) {
    return UserUpdateDto(
      username: json['username'],
      description: json['description'],
      avatar: json['avatar'],
    );
  }

  factory UserUpdateDto.fromUser(UserModel user) {
    return UserUpdateDto(
      username: user.username,
      description: user.description,
      avatar: user.avatar,
    );
  }
}
