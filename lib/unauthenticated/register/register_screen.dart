import 'package:esgix_project/unauthenticated/register/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/blocs/auth_bloc/auth_bloc.dart';
import '../../shared/blocs/auth_bloc/auth_event.dart';
import '../../shared/blocs/auth_bloc/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void _handleRegister(BuildContext context, String email, String password, String username, String avatar) {
    context.read<AuthBloc>().add(RegisterRequested(email, password, username, avatar));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: RegisterForm(
              onRegister: (email, password, username, avatar) =>
                  _handleRegister(context, email, password, username, avatar),
            ),
          ),
        ),
      ),
    );
  }
}