import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:where_u_drink/features/connection/presentation/notifiers/connection/auth_form_state.dart';

final authFormProvider = NotifierProvider<AuthFormNotifier, AuthFormState>(
  AuthFormNotifier.new,
);

class AuthFormNotifier extends Notifier<AuthFormState> {
  @override
  AuthFormState build() {
    return const AuthFormState();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email, clearErrorMessage: true);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password, clearErrorMessage: true);
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void updateErrorMessage(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  Future<bool> submit({bool skipValidation = false}) async {
    if (!skipValidation) {
      final errorMessage = _validate();
      if (errorMessage != null) {
        state = state.copyWith(errorMessage: errorMessage);
        return false;
      }
    }

    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(isLoading: false);
    return true;
  }

  String? _validate() {
    if (state.email.trim().isEmpty && state.password.trim().isEmpty) {
      return 'Merci de renseigner ton email et ton mot de passe.';
    }

    if (state.email.trim().isEmpty) {
      return 'Merci de renseigner ton email.';
    }

    if (state.password.trim().isEmpty) {
      return 'Merci de renseigner ton mot de passe.';
    }

    return null;
  }
}
