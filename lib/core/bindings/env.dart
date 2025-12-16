sealed class Env {
  static const proxyUrl = String.fromEnvironment('PROXY_URL');
  static const baseUrl = '$proxyUrl${String.fromEnvironment('BASE_URL')}';
  static const autoCompleteUrl = String.fromEnvironment('AUTOCOMPLETE_URL');
  static const adUnitId = String.fromEnvironment('AD_UNI_ID');
}
