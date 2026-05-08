import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:where_u_drink/features/connection/presentation/notifiers/register/register_form_state.dart';

final registerFormProvider =
    NotifierProvider<RegisterFormNotifier, RegisterFormState>(
      RegisterFormNotifier.new,
    );

class RegisterFormNotifier extends Notifier<RegisterFormState> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  RegisterFormState build() {
    return const RegisterFormState();
  }

  void reset() {
    state = const RegisterFormState();
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName, clearErrorMessage: true);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName, clearErrorMessage: true);
  }

  void updateBirthDate(DateTime birthDate) {
    state = state.copyWith(birthDate: birthDate, clearErrorMessage: true);
  }

  Future<void> pickAvatar() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    state = state.copyWith(
      avatarPath: image.path,
      clearErrorMessage: true,
    );
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username, clearErrorMessage: true);
  }

  void updateBio(String bio) {
    state = state.copyWith(bio: bio, clearErrorMessage: true);
  }

  void previousStep() {
    if (state.currentStep == 0) {
      return;
    }

    state = state.copyWith(
      currentStep: state.currentStep - 1,
      clearErrorMessage: true,
    );
  }

  void nextStep() {
    final errorMessage = _validateCurrentStep();
    if (errorMessage != null) {
      state = state.copyWith(errorMessage: errorMessage);
      return;
    }

    state = state.copyWith(
      currentStep: state.currentStep + 1,
      clearErrorMessage: true,
    );
  }

  Future<void> submit() async {
    state = state.copyWith(
      isLoading: true,
      clearErrorMessage: true,
    );

    final errorMessage = _validateCurrentStep(validateAll: true);
    if (errorMessage != null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: errorMessage,
      );
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(isLoading: false);
  }

  String? _validateCurrentStep({bool validateAll = false}) {
    if (state.currentStep == 0 || validateAll) {
      if (state.lastName.trim().isEmpty || state.firstName.trim().isEmpty) {
        return 'Merci de renseigner le nom et le prénom.';
      }

      if (state.birthDate == null) {
        return 'Merci de sélectionner une date d\'anniversaire.';
      }

      if (!validateAll) {
        return null;
      }
    }

    if (state.currentStep == 1 || validateAll) {
      if (state.avatarPath == null || state.avatarPath!.trim().isEmpty) {
        return 'Merci d\'importer un avatar.';
      }

      if (state.username.trim().isEmpty) {
        return 'Merci de choisir un username.';
      }
    }

    return null;
  }
}
