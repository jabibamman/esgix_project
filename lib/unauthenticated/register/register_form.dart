import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/blocs/register_bloc/register_bloc.dart';
import '../../shared/blocs/register_bloc/register_event.dart';
import '../../shared/blocs/register_bloc/register_state.dart';
import '../../shared/utils/constants.dart';
import '../../shared/utils/validators.dart';
import '../../theme/colors.dart';
import '../../theme/images.dart';
import '../../theme/text_styles.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _avatarController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(state, context),
                  const SizedBox(height: 32.0),
                  if (state is RegisterStep1) ..._buildStep1(context),
                  if (state is RegisterStep2) ..._buildStep2(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildStep1(BuildContext context) {
    return [
      BlocBuilder(
        bloc: context.read<RegisterBloc>(),
        builder: (context, state) {
          bool emailValid = true;
          if (state is RegisterStep1) {
            emailValid = state.emailValid ?? true;
          }

          return TextFormField(
            controller: _emailController,
            decoration: _buildInputDecoration('Email').copyWith(
              errorText: _emailController.text.isEmpty
                  ? null
                  : (emailValid ? null : kInvalidEmailError),
            ),
            validator: (value) => _validateEmail(value),
            onChanged: (value) {
              context.read<RegisterBloc>().add(
                EmailChanged(value, _emailController.text),
              );
            },
          );
        },
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        controller: _usernameController,
        decoration: _buildInputDecoration('Username'),
        validator: (value) => value!.isEmpty ? kEmptyUsernameError : null,
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        controller: _passwordController,
        decoration: _buildInputDecoration('Password'),
        obscureText: true,
        validator: (value) => validatePassword(value),
        onChanged: (value) {
          context.read<RegisterBloc>().add(
            PasswordChanged(value, _confirmPasswordController.text),
          );
        },
      ),
      const SizedBox(height: 16.0),
      BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          bool passwordsMatch = true;
          if (state is RegisterStep1) {
            passwordsMatch = state.passwordsMatch;
          }

          return TextFormField(
            controller: _confirmPasswordController,
            decoration: _buildInputDecoration('Confirm Password').copyWith(
              errorText: passwordsMatch ? null : kPasswordsDoNotMatchError,
            ),
            obscureText: true,
            onChanged: (value) {
              context.read<RegisterBloc>().add(
                PasswordChanged(_passwordController.text, value),
              );
            },
          );
        },
      ),
      const SizedBox(height: 24.0),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
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
          style: TextStyles.bodyText1.copyWith(color: AppColors.white),
        ),
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
              kAlreadyHaveAnAccount,
              style:
              TextStyles.bodyText2.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildStep2(BuildContext context) {
    return [
      TextFormField(
        controller: _descriptionController,
        decoration: _buildInputDecoration('Description'),
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        controller: _avatarController,
        decoration: _buildInputDecoration('Avatar URL'),
      ),
      const SizedBox(height: 24.0),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() ?? false) {
            context.read<RegisterBloc>().add(
              SubmitRegistration(
                email: _emailController.text,
                password: _passwordController.text,
                username: _usernameController.text,
                avatar: _avatarController.text,
                description: _descriptionController.text,
              ),
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
          'Sign Up',
          style: TextStyles.bodyText1.copyWith(color: AppColors.white),
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
            style: TextStyles.bodyText2.copyWith(color: AppColors.primary),
          ),
        ),
      ),
    ];
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
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return kEmptyEmailError;
    }

    if (!validateEmail(value)) {
      return kInvalidEmailError;
    }
    return null;
  }

  Widget _buildHeader(RegisterState state, BuildContext context) {
    String headerText;

    if (state is RegisterStep1) {
      headerText = kSignUp;
    } else if (state is RegisterStep2) {
      headerText = kAlmostDone;
    } else {
      headerText = '';
    }

    return Column(
      children: [
        if (state is RegisterStep2)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () {
                context.read<RegisterBloc>().add(RegisterPreviousStep());
              },
            ),
          ),
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
            headerText,
            style: TextStyles.headline1,
          ),
        ),
      ],
    );
  }
}