mixin ValidatorMixin {
  String? isValidPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 3) {
      return "Password must be at least 4 characters";
    }
    return null;
  }

  String? isEmpty(String text, String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter $text";
    }
    return null;
  }

  String? isBothPasswordSame(String password, String? confirmPassword) {
    if (password != confirmPassword) {
      return "Password does not match";
    }
    if (confirmPassword == null ||
        confirmPassword.isEmpty ||
        password.isEmpty) {
      return "Please enter password";
    }
    return null;
  }

  String? isUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your userName";
    }
    return null;
  }

  String? isValidPhonNumer(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    if (value.length < 10) {
      return "Please enter valid phone number";
    }
    return null;
  }

  String? isOtpFieldEmpty(String? value) {
    if (value == null || value.length != 4) {
      return "Please enter OTP";
    }
    return null;
  }

  String? isValidEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!value.contains('@')) {
      return "Please enter valid email";
    }
    return null;
  }

  String? isZipValid(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter zip code";
    }
    if (value.length < 6) {
      return "Please enter valid zip code";
    }
    return null;
  }
}
