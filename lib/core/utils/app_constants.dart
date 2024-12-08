sealed class AppConstants {
  static Duration timeout = Duration(seconds: 30);

  static final RegExp regexForKey = RegExp(
    r'findNextItem.*?"(.*?)"',
    dotAll: true,
  );

  /// Regex For JS for parsing API TOKEN -> [regexForJs]
  static final RegExp regexForJs = RegExp(
    r'(b.min.js.*)(?=")',
  );

  static const keyToken = "TOKEN";
}
