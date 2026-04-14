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
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateIsLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void updateErrorMessage(String? errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  Future<void> submit() async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    await Future<void>.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(isLoading: false);
  }
}
