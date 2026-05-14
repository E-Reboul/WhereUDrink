import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:where_u_drink/core/widgets/custom_elevated_button.dart';
import 'package:where_u_drink/features/connection/presentation/notifiers/register/register_form_notifier.dart';
import 'package:where_u_drink/features/connection/presentation/widgets/register/register_step_one_form.dart';
import 'package:where_u_drink/features/connection/presentation/widgets/register/register_step_two_form.dart';
import 'package:where_u_drink/features/home/presentation/screens/home_screen.dart';

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerFormProvider);
    final notifier = ref.read(registerFormProvider.notifier);
    final isLastStep = state.currentStep == 1;

    return Column(
      children: [
        _StepIndicator(currentStep: state.currentStep),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: state.currentStep == 0
              ? const RegisterStepOneForm(key: ValueKey('step1'))
              : const RegisterStepTwoForm(key: ValueKey('step2')),
        ),
        const SizedBox(height: 16),
        if (state.errorMessage != null) ...[
          Text(
            state.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            if (state.currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: state.isLoading ? null : notifier.previousStep,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Précédent'),
                  ),
                ),
              ),
            if (state.currentStep > 0) const SizedBox(width: 12),
            Expanded(
              child: CustomElevatedButton(
                text: state.isLoading
                    ? 'Chargement...'
                    : isLastStep
                        ? 'Terminer'
                        : 'Continuer',
                onPressed: state.isLoading
                    ? null
                    : () async {
                        if (!isLastStep) {
                          notifier.nextStep();
                          return;
                        }

                        final isSubmitted = await notifier.submit();
                        if (!context.mounted || !isSubmitted) {
                          return;
                        }

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<void>(
                            builder: (_) => const HomeScreen(),
                          ),
                          (_) => false,
                        );
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StepDot(
          isActive: currentStep == 0,
          isCompleted: currentStep > 0,
          label: 'Identité',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: currentStep > 0
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 8),
        _StepDot(
          isActive: currentStep == 1,
          isCompleted: false,
          label: 'Profil',
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final String label;

  const _StepDot({
    required this.isActive,
    required this.isCompleted,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive || isCompleted
        ? Theme.of(context).colorScheme.primary
        : Colors.grey.shade400;

    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            size: isCompleted ? 18 : 12,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
