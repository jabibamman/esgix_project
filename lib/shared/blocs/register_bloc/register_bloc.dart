import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(RegisterStep1()) {
    on<RegisterNextStep>((event, emit) {
      if (state is RegisterStep1) {
        emit(RegisterStep2());
      }
    });

    on<AvatarUrlChanged>((event, emit) {
      final isValidUrl = Uri.tryParse(event.avatarUrl)?.hasAbsolutePath ?? false;
      if (isValidUrl) {
        emit(RegisterFormState(avatarPreviewUrl: event.avatarUrl));
      } else {
        emit(RegisterFormState(avatarError: 'Invalid image URL'));
      }
    });

    on<PasswordChanged>((event, emit) {
      final doPasswordsMatch = event.password == event.confirmPassword;

      if (state is RegisterStep1 && (state as RegisterStep1).passwordsMatch != doPasswordsMatch) {
        emit(RegisterStep1(passwordsMatch: doPasswordsMatch));
      }
    });


    on<SubmitRegistration>((event, emit) async {
      emit(RegisterLoading());
      try {
        final user = UserModel(
          email: event.email,
          username: event.username,
          password: event.password,
          avatar: event.avatar,
          description: event.description,
        );
        await authService.register(user);
        emit(RegisterSuccess());
      } catch (e) {
        emit(RegisterFailure(e.toString()));
      }
    });
  }
}