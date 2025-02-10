import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService;

  ProfileBloc({required this.userService}) : super(ProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await userService.getUserById(event.userId);
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}