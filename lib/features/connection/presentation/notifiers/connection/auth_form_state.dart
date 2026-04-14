class AuthFormState {
  final String email;
  final String password;
  final bool isLoading;
  final String? errorMessage;

  const AuthFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
  });

  AuthFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return AuthFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
