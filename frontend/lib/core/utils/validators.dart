/// Validation utilities.
class Validators {
  Validators._();

  /// Email regex pattern.
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone regex pattern (international format).
  static final _phoneRegex = RegExp(
    r'^\+?[1-9]\d{6,14}$',
  );

  /// Check if email is valid.
  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// Validate email with error message.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Check if password is valid.
  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return password.length >= 8;
  }

  /// Validate password with error message.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Validate password confirmation.
  static String? validatePasswordConfirm(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate required field.
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Check if phone is valid.
  static bool isValidPhone(String? phone) {
    if (phone == null || phone.isEmpty) return true; // Phone is optional
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return _phoneRegex.hasMatch(cleaned);
  }

  /// Validate phone with error message.
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    if (!isValidPhone(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}
