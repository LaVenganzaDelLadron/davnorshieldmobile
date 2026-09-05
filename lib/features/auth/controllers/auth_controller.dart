import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return const AuthRepository();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

enum PasswordStrength { weak, medium, strong }

class AuthState {
  const AuthState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.rememberMe = false,
    this.termsAccepted = false,
    this.municipality,
    this.barangay,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.errorMessage,
  });

  final String email;
  final String password;
  final String confirmPassword;
  final bool rememberMe;
  final bool termsAccepted;
  final String? municipality;
  final String? barangay;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? errorMessage;

  AuthState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? rememberMe,
    bool? termsAccepted,
    String? municipality,
    String? barangay,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? errorMessage,
    bool clearMunicipality = false,
    bool clearBarangay = false,
    bool clearError = false,
  }) {
    return AuthState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      rememberMe: rememberMe ?? this.rememberMe,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      municipality: clearMunicipality ? null : municipality ?? this.municipality,
      barangay: clearBarangay ? null : barangay ?? this.barangay,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  List<String> get municipalities => AuthRepository.municipalities;

  List<String> barangaysFor(String? municipality) {
    if (municipality == null) return const [];
    return AuthRepository.barangaysByMunicipality[municipality] ?? const [];
  }

  void setEmail(String value) {
    state = state.copyWith(email: value.trim(), clearError: true);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value, clearError: true);
  }

  void setConfirmPassword(String value) {
    state = state.copyWith(confirmPassword: value, clearError: true);
  }

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void toggleTerms(bool value) {
    state = state.copyWith(termsAccepted: value);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword);
  }

  void selectMunicipality(String? value) {
    state = state.copyWith(
      municipality: value,
      clearBarangay: true,
      clearError: true,
    );
  }

  void selectBarangay(String? value) {
    state = state.copyWith(barangay: value, clearError: true);
  }

  bool get isEmailValid => _isEmailValid(state.email);

  bool get isPasswordValid => _isPasswordValid(state.password);

  bool get passwordsMatch => state.confirmPassword.isNotEmpty && state.confirmPassword == state.password;

  bool get canSubmitLogin => isEmailValid && state.password.isNotEmpty;

  bool get canSubmitSignup =>
      isEmailValid &&
      isPasswordValid &&
      passwordsMatch &&
      state.termsAccepted &&
      state.municipality != null &&
      state.barangay != null;

  PasswordStrength get passwordStrength {
    final score = [
      state.password.length >= 8,
      RegExp(r'[A-Z]').hasMatch(state.password),
      RegExp(r'[a-z]').hasMatch(state.password),
      RegExp(r'\d').hasMatch(state.password),
      RegExp(r'[^\w\s]').hasMatch(state.password),
    ].where((ok) => ok).length;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  List<bool> get passwordRequirements => [
        state.password.length >= 8,
        RegExp(r'[A-Z]').hasMatch(state.password),
        RegExp(r'[a-z]').hasMatch(state.password),
        RegExp(r'\d').hasMatch(state.password),
        RegExp(r'[^\w\s]').hasMatch(state.password),
      ];

  Future<bool> login() async {
    if (!canSubmitLogin) {
      state = state.copyWith(errorMessage: 'Please enter a valid email and password.');
      return false;
    }
    await _repository.setAuthenticated(true);
    return true;
  }

  Future<bool> signUp() async {
    if (!canSubmitSignup) {
      state = state.copyWith(errorMessage: 'Complete all required fields to continue.');
      return false;
    }
    await _repository.setAuthenticated(true);
    return true;
  }

  Future<void> guestContinue() async {
    await _repository.setAuthenticated(false);
  }

  static bool _isEmailValid(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }

  static bool _isPasswordValid(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password) &&
        RegExp(r'[^\w\s]').hasMatch(password);
  }
}
