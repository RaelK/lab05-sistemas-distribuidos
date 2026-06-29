class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );

  static const int providerId = int.fromEnvironment(
    'PROVIDER_ID',
    defaultValue: 1,
  );

  static const Duration pollingInterval = Duration(seconds: 5);
}
