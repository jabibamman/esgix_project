import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/blocs/profile_bloc/profile_bloc.dart';
import '../../shared/blocs/profile_bloc/profile_event.dart';
import '../../shared/blocs/profile_bloc/profile_state.dart';
import '../../shared/models/user_model.dart';

class UpdateProfileWidget extends StatefulWidget {
  final UserModel currentUser;
  const UpdateProfileWidget({Key? key, required this.currentUser}) : super(key: key);

  @override
  _UpdateProfileWidgetState createState() => _UpdateProfileWidgetState();
}

class _UpdateProfileWidgetState extends State<UpdateProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _avatarController;
  late TextEditingController _descriptionController;

  late String _initialUsername;
  late String _initialAvatar;
  late String _initialDescription;

  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _initialUsername = widget.currentUser.username;
    _initialAvatar = widget.currentUser.avatar ?? '';
    _initialDescription = widget.currentUser.description;

    _usernameController = TextEditingController(text: _initialUsername);
    _avatarController = TextEditingController(text: _initialAvatar);
    _descriptionController = TextEditingController(text: _initialDescription);

    _usernameController.addListener(_checkChanges);
    _avatarController.addListener(_checkChanges);
    _descriptionController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final usernameChanged = _usernameController.text.trim() != _initialUsername;
    final avatarChanged = _avatarController.text.trim() != _initialAvatar;
    final descriptionChanged = _descriptionController.text.trim() != _initialDescription;
    final hasChanged = usernameChanged || avatarChanged || descriptionChanged;
    if (hasChanged != _hasChanged) {
      setState(() {
        _hasChanged = hasChanged;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _avatarController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitUpdate() {
    final updatedUser = widget.currentUser.copyWith(
      username: _usernameController.text.trim(),
      avatar: _avatarController.text.trim(),
      description: _descriptionController.text.trim(),
    );

    context.read<ProfileBloc>().add(UpdateUserProfileEvent(updatedUser));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mettre à jour votre profil"),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            Navigator.pop(context, true);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Mettre à jour votre profil", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: "Nom d'utilisateur"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _avatarController,
                    decoration: const InputDecoration(labelText: "Avatar (URL)"),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _hasChanged ? _submitUpdate : null,
                    child: const Text("Mettre à jour"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
