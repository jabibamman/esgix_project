import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/auth_exceptions.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  bool _hasChecked = false;

  AuthBloc(this.authService) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthenticationStatus>(_onCheckAuthenticationStatus);
    on<FetchStoredUser>(_onFetchStoredUser);
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
    if (await authService.logout()) {
      emit(AuthUnauthenticated());
      return;
    }
    emit(AuthError('Erreur lors de la déconnexion'));
  }

  Future<void> _onCheckAuthenticationStatus(
      CheckAuthenticationStatus event, Emitter<AuthState> emit) async {
    if (_hasChecked) return;
    _hasChecked = true;

    final isLoggedIn = await authService.isLoggedIn();
    if (isLoggedIn) {
      final userId = await authService.getId();
      final user = await authService.getUserById(userId);
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onFetchStoredUser(
      FetchStoredUser event, Emitter<AuthState> emit) async {
    try {
      final userId = await authService.getId(); // Récupère l'ID stocké
      if (userId.isNotEmpty) {
        final user = await authService.getUserById(userId);
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError("Impossible de récupérer l'utilisateur depuis la session."));
    }
  }
}