class ValidationService {
  static String? requiredValidation(dynamic value, {String? message}) {
    if (value == null || value.toString().trim().isEmpty) {
      return message ?? 'Required*';
    }
    return null;
  }

  static String? passwordValidation(
    String? value, {
    String? message,
    bool isLogin = true,
  }) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  static String? confirmPasswordValidation(
    String? confirmPassword,
    String? password, {
    String? message,
  }) {
    if (confirmPassword == null || confirmPassword.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final trimmedConfirm = confirmPassword.trim();
    if (trimmedConfirm.length < 6) {
      return 'Confirm password must be at least 6 characters';
    }

    if (trimmedConfirm != password?.trim()) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? nameValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final nameRegex = RegExp(r"^[A-Za-z\s'-]+$");
    if (!nameRegex.hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, or apostrophes';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  static String? emailValidation(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Required*';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }
}
