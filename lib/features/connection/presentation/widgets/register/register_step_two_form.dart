import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:where_u_drink/core/widgets/custom_text_field.dart';
import 'package:where_u_drink/features/connection/presentation/notifiers/register/register_form_notifier.dart';

class RegisterStepTwoForm extends ConsumerWidget {
  const RegisterStepTwoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Importe un avatar *',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: notifier.pickAvatar,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    width: 84,
                    height: 84,
                    color: Colors.grey.shade200,
                    child: state.avatarPath == null
                        ? const Icon(Icons.add_a_photo_outlined, size: 30)
                        : _AvatarImage(path: state.avatarPath!),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.avatarPath == null
                      ? 'Choisir une image depuis le téléphone'
                      : 'Modifier l\'avatar sélectionné',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          prefixIcon: const Icon(Icons.alternate_email),
          label: 'Username *',
          onChanged: notifier.updateUsername,
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: state.bio,
          maxLines: 4,
          onChanged: notifier.updateBio,
          decoration: InputDecoration(
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 64),
              child: Icon(Icons.edit_note),
            ),
            labelText: 'Bio',
            alignLabelWithHint: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String path;

  const _AvatarImage({required this.path});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: 84,
        height: 84,
      );
    }

    return Image.file(
      File(path),
      fit: BoxFit.cover,
      width: 84,
      height: 84,
    );
  }
}
