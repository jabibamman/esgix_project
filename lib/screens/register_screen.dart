import 'package:esgix_project/screens/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import '../../theme/text_styles.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void _handleRegister(BuildContext context, String email, String password, String username, String avatar) {
    context.read<AuthBloc>().add(RegisterRequested(email, password, username, avatar));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register', style: TextStyles.appBarTitle),
      ),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: RegisterForm(
                      onRegister: (email, password, username, avatar) =>
                          _handleRegister(context, email, password, username, avatar),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}