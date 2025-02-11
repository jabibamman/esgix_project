// profile_event.dart
import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ProfileEvent {
  final String userId;
  FetchUserProfile(this.userId);
  @override
  List<Object> get props => [userId];
}

class FetchUserPosts extends ProfileEvent {
  final String userId;
  final int offset;
  FetchUserPosts({required this.userId, this.offset = 10});
  @override
  List<Object> get props => [userId, offset];
}

class LoadMoreUserPosts extends ProfileEvent {
  final String userId;
  final int offset;
  LoadMoreUserPosts({required this.userId, this.offset = 10});
  @override
  List<Object> get props => [userId, offset];
}

class FetchUserLikedPosts extends ProfileEvent {
  final String userId;
  final int offset;
  FetchUserLikedPosts({required this.userId, this.offset = 10});
  @override
  List<Object> get props => [userId, offset];
}

class LoadMoreUserLikedPosts extends ProfileEvent {
  final String userId;
  final int offset;
  LoadMoreUserLikedPosts({required this.userId, this.offset = 10});
  @override
  List<Object> get props => [userId, offset];
}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserModel updatedUser;
  UpdateUserProfileEvent(this.updatedUser);
  @override
  List<Object> get props => [updatedUser];
}
