
class Validation {


  bool isNameValid(String name) {
    return name.length >= 6;
  }

  bool isEmailValid(String email) {
    RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool isPhoneValid(String phone) {
    // Kiểm tra độ dài số điện thoại
    if (phone.length != 10 && phone.length != 11) {
      return false;
    }

    // Kiểm tra xem mỗi ký tự trong số điện thoại có phải là số không
    for (int i = 0; i < phone.length; i++) {
      if (phone.codeUnitAt(i) < 48 || phone.codeUnitAt(i) > 57) {
        return false;
      }
    }

    return true;
  }

  bool isPasswordValid(String password) {
    if (password.length < 8) {
      return false;
    }

    RegExp specialChars = RegExp(r'[!@#%^&*(),.?":{}|<>]');
    if (!specialChars.hasMatch(password)) {
      return false;
    }

    RegExp upperCaseChars = RegExp(r'[A-Z]');
    if (!upperCaseChars.hasMatch(password)) {
      return false;
    }

    RegExp lowerCaseChars = RegExp(r'[a-z]');
    if (!lowerCaseChars.hasMatch(password)) {
      return false;
    }

    return true;
  }

}
