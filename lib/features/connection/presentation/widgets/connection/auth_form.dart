import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:where_u_drink/core/widgets/custom_elevated_button.dart';
import 'package:where_u_drink/core/widgets/custom_gesture_detector.dart';
import 'package:where_u_drink/core/widgets/custom_text_field.dart';
import 'package:where_u_drink/features/connection/presentation/notifiers/connection/auth_form_notifier.dart';

class AuthForm extends ConsumerWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authFormProvider);
    final notifier = ref.read(authFormProvider.notifier);

    return Column(
      children: [
        CustomTextField(
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email),
          label: 'Email',
          onChanged: notifier.updateEmail,
        ),
        const SizedBox(height: 12),
        CustomTextField(
          obscureText: true,
          prefixIcon: const Icon(Icons.lock),
          label: 'Mot de passe',
          onChanged: notifier.updatePassword,
        ),
        const SizedBox(height: 12),
        _forgetPassword(),
        const SizedBox(height: 4),
        CustomElevatedButton(
          text: state.isLoading ? 'Chargement...' : 'Se connecter',
          onPressed: state.isLoading ? null : () => notifier.submit(),
        ),
        const SizedBox(height: 16),
        if (state.errorMessage != null) ...[
          Text(
            state.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 12),
        ],
        _orDivider(),
        _otherConnections(),
        const SizedBox(height: 12),
      ],
    );
  }
}

Widget _forgetPassword() => Align(
  alignment: Alignment.center,
  child: TextButton(
    onPressed: () {},
    child: const Text('Mot de passe oublié ?'),
  ),
);

Widget _orDivider() => Row(
  children: const [
    Expanded(child: Divider()),
    Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('ou')),
    Expanded(child: Divider()),
  ],
);

Widget _otherConnections() => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    CustomGestureDetector(
      onTap: () {},
      radius: 22,
      backgroundColor: Colors.white,
      icon: Icons.g_mobiledata,
      iconColor: Colors.red,
    ),

    const SizedBox(width: 16),

    CustomGestureDetector(
      onTap: () {},
      radius: 22,
      backgroundColor: Colors.white,
      icon: Icons.apple,
      iconColor: Colors.black,
    ),
  ],
);
