class RegisterFormState {
  final int currentStep;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final String? avatarPath;
  final String username;
  final String bio;
  final bool isLoading;
  final String? errorMessage;

  const RegisterFormState({
    this.currentStep = 0,
    this.firstName = '',
    this.lastName = '',
    this.birthDate,
    this.avatarPath,
    this.username = '',
    this.bio = '',
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterFormState copyWith({
    int? currentStep,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    bool clearBirthDate = false,
    String? avatarPath,
    bool clearAvatarPath = false,
    String? username,
    String? bio,
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RegisterFormState(
      currentStep: currentStep ?? this.currentStep,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      avatarPath: clearAvatarPath ? null : (avatarPath ?? this.avatarPath),
      username: username ?? this.username,
      bio: bio ?? this.bio,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
