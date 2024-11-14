import 'package:esgix_project/theme/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/auth_bloc/auth_bloc.dart';
import '../../shared/blocs/auth_bloc/auth_state.dart';
import '../../theme/colors.dart';
import '../../theme/text_styles.dart';

class RegisterForm extends StatelessWidget {
  final void Function(String email, String password, String username, String avatar) onRegister;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _avatarController = TextEditingController();
  bool _passwordsMatch = true;

  RegisterForm({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Image.asset(
              AppImages.logo,
              width: 70,
              height: 70,
            ),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Text(
              'Sign up for Twitter',
              style: TextStyles.headline1,
            ),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter an email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Please enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your password';
              if (value.length < 6) return 'Password must be at least 6 characters long';
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              errorText: !_passwordsMatch ? 'Passwords do not match' : null,
            ),
            obscureText: true,
            onChanged: (value) {
              _passwordsMatch = value == _passwordController.text;
              (context as Element).markNeedsBuild();
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter a username';
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: _avatarController,
            decoration: InputDecoration(
              labelText: 'Avatar URL',
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            ),
          ),
          const SizedBox(height: 24.0),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      onRegister(
                        _emailController.text,
                        _passwordController.text,
                        _usernameController.text,
                        _avatarController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyles.bodyText1.copyWith(color: AppColors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text(
                  'Already have an account? Log in',
                  style: TextStyles.bodyText2.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}