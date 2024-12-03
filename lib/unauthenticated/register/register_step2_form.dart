import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/register_bloc/register_bloc.dart';
import '../../shared/blocs/register_bloc/register_event.dart';
import '../../shared/utils/constants.dart';
import '../../theme/colors.dart';
import '../../theme/images.dart';
import '../../theme/text_styles.dart';

class RegisterStep2Form extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController avatarController;
  final TextEditingController descriptionController;

  const RegisterStep2Form({
    required this.formKey,
    required this.avatarController,
    required this.descriptionController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primary),
              tooltip: kArrowBackTooltip,
              onPressed: () {
                context.read<RegisterBloc>().add(RegisterPreviousStep());
              },
            ),
          ),
          const SizedBox(height: 16.0),
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
              kAlmostDoneText,
              style: TextStyles.headline1,
            ),
          ),
          const SizedBox(height: 24.0),
          TextFormField(
            controller: descriptionController,
            decoration: _buildInputDecoration(kDescriptionLabel),
          ),
          const SizedBox(height: 16.0),


          TextFormField(
            controller: avatarController,
            decoration: _buildInputDecoration(kAvatarURLLabel),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                context.read<RegisterBloc>().add(
                  SubmitRegistration(
                    email: context.read<RegisterBloc>().state.email ?? '',
                    username: context.read<RegisterBloc>().state.username ?? '',
                    password: context.read<RegisterBloc>().state.password ?? '',
                    avatar: avatarController.text,
                    description: descriptionController.text,
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
              kRegisterButtonText,
              style: TextStyle(color: AppColors.white, fontSize: 16.0),
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