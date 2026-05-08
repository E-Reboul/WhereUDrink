import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:where_u_drink/core/widgets/custom_text_field.dart';
import 'package:where_u_drink/features/connection/presentation/notifiers/register/register_form_notifier.dart';

class RegisterStepOneForm extends ConsumerWidget {
  const RegisterStepOneForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(registerFormProvider.notifier);

    return Column(
      children: [
        CustomTextField(
          prefixIcon: const Icon(Icons.badge_outlined),
          label: 'Nom *',
          onChanged: notifier.updateLastName,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          prefixIcon: const Icon(Icons.person_outline),
          label: 'Prénom *',
          onChanged: notifier.updateFirstName,
        ),
        const SizedBox(height: 12),
        const _BirthdayField(),
      ],
    );
  }
}

class _BirthdayField extends ConsumerStatefulWidget {
  const _BirthdayField();

  @override
  ConsumerState<_BirthdayField> createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends ConsumerState<_BirthdayField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);

    _controller.text = state.birthDate == null
        ? ''
        : _formatDate(state.birthDate!);

    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: () async {
        final now = DateTime.now();
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: state.birthDate ?? DateTime(now.year - 18),
          firstDate: DateTime(1900),
          lastDate: now,
        );

        if (pickedDate != null) {
          notifier.updateBirthDate(pickedDate);
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.cake_outlined),
        labelText: 'Anniversaire *',
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
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
