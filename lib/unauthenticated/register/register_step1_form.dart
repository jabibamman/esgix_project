import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/register_bloc/register_bloc.dart';
import '../../shared/blocs/register_bloc/register_state.dart';
import '../../shared/blocs/register_bloc/register_event.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/validators.dart';
import '../../theme/colors.dart';

import '../../theme/images.dart';
import '../../theme/text_styles.dart';

class RegisterStep1Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const RegisterStep1Form({
    required this.formKey,
    required this.emailController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
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
              kCreateAccount,
              style: TextStyles.headline1,
            ),
          ),
          const SizedBox(height: 24.0),
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              bool emailValid = true;
              if (state is RegisterStep1) {
                emailValid = state.emailValid ?? true;
              }

              return TextFormField(
                controller: emailController,
                decoration: _buildInputDecoration('Email').copyWith(
                  errorText: emailController.text.isEmpty
                      ? null
                      : (emailValid ? null : kInvalidEmailError),
                ),
                validator: (value) => validateEmail(value!) ? null : kInvalidEmailError,
                onChanged: (value) {
                  context.read<RegisterBloc>().add(EmailChanged(value, emailController.text));
                },
              );
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: usernameController,
            decoration: _buildInputDecoration('Username'),
            validator: (value) => value!.isEmpty ? kEmptyUsernameError : null,
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              String? passwordError;
              String? confirmPasswordError;

              if (state is RegisterStep1) {
                passwordError = state.passwordValid;
                if (!state.passwordsMatch) {
                  confirmPasswordError = kPasswordsDoNotMatchError;
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: passwordController,
                    decoration: _buildInputDecoration('Password').copyWith(
                      errorText: passwordError,
                    ),
                    obscureText: true,
                    validator: validatePassword,
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(
                        PasswordChanged(value, confirmPasswordController.text),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: confirmPasswordController,
                    decoration: _buildInputDecoration('Confirm Password').copyWith(
                      errorText: confirmPasswordError,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      context.read<RegisterBloc>().add(
                        PasswordChanged(passwordController.text, value),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                context.read<RegisterBloc>().add(RegisterNextStep());
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
              kNext,
              style: TextStyle(color: AppColors.white, fontSize: 16.0),
            ),
          ),
          const SizedBox(height: 30.0),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Center(
              child: Text(
                kAlreadyHaveAnAccount,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: AppColors.primary),
      filled: true,
      fillColor: AppColors.lightGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }
}