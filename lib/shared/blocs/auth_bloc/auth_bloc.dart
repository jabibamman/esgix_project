import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/auth_exceptions.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(event.email, event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e is LoginException ? e.message : e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await authService.logout();
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthenticationStatus(
      CheckAuthenticationStatus event, Emitter<AuthState> emit) async {
    final isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      final user = await authService.getUserProfile();
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
