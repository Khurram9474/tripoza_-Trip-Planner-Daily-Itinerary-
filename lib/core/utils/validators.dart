class Validators {
  Validators._();

  static String? requiredField(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name.';
    }
    if (value.trim().length < 3) {
      return 'Please enter a valid full name.';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number.';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    final phoneRegex = RegExp(r'^\+?[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address.';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? reviewText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please write a review before submitting.';
    }
    if (value.trim().length < 10) {
      return 'Your review is too short. Please share a bit more detail.';
    }
    return null;
  }

  static String? reviewerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name.';
    }
    return null;
  }
}