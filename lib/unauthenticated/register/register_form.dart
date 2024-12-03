import 'package:flutter/material.dart';
import '../../shared/blocs/register_bloc/register_state.dart';
import 'register_step1_form.dart';
import 'register_step2_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/register_bloc/register_bloc.dart';

class RegisterForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _avatarController = TextEditingController();
  final _descriptionController = TextEditingController();

  RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state is RegisterStep1)
                  RegisterStep1Form(
                    formKey: _formKey,
                    emailController: _emailController,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                if (state is RegisterStep2)
                  RegisterStep2Form(
                    formKey: _formKey,
                    avatarController: _avatarController,
                    descriptionController: _descriptionController,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}