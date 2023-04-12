class Validators {
  static final RegExp _numeric = RegExp(r'^-?[0-9]+$');

  /// check if the string [str] contains only numbers
  static bool isNumeric(String str) {
    return _numeric.hasMatch(str);
  }

  static bool isURL(String? str) {
    if ((str?.startsWith('http') ?? false) ||
        (str?.startsWith('https') ?? false)) {
      return true;
    } else {
      return false;
    }
  }
}
