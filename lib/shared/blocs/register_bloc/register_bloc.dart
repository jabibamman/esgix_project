import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(RegisterStep1()) {
    on<RegisterNextStep>((event, emit) {
      if (state is RegisterStep1) {
        final step1State = state as RegisterStep1;
        emit(RegisterStep2(
          email: step1State.email,
          username: step1State.username,
          password: step1State.password,
        ));
      }
    });

    on<RegisterPreviousStep>((event, emit) {
      if (state is RegisterStep2) {
        final step2State = state as RegisterStep2;
        emit(RegisterStep1(
          email: step2State.email,
          username: step2State.username,
          password: step2State.password,
          confirmPassword: step2State.password,
        ));
      }
    });

    on<PasswordChanged>((event, emit) {
      if (state is RegisterStep1) {
        final step1State = state as RegisterStep1;
        emit(RegisterStep1(
          email: step1State.email,
          username: step1State.username,
          password: event.password,
          confirmPassword: event.confirmPassword,
          passwordsMatch: event.password == event.confirmPassword,
          passwordValid: validatePassword(event.password),
        ));
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

    on<EmailChanged>((event, emit) {
      if (state is RegisterStep1) {
        final step1State = state as RegisterStep1;
        emit(RegisterStep1(
          email: event.email,
          emailValid: validateEmail(event.email),
          username: step1State.username,
          password: step1State.password,
          confirmPassword: step1State.confirmPassword,
        ));
      }
    }
    );
  }
}