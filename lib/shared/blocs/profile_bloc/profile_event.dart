import 'package:equatable/equatable.dart';

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