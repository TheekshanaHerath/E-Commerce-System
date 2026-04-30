class Validators {
  static String? validateEmail(String email) {
    if (email.isEmpty) return "Email required";
    if (!email.contains("@")) return "Invalid email";
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return "Password required";
    if (password.length < 6) return "Min 6 characters";
    return null;
  }

  static String? validateName(String name) {
    if (name.isEmpty) return "Name required";
    return null;
  }
}