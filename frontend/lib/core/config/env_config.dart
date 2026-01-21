/// Environment configuration for the app.
class EnvConfig {
  EnvConfig._();

  /// Base URL for the API.
  static const String apiBaseUrl = 'http://localhost:8001/api/v1';

  /// Timeout for API requests in milliseconds.
  static const int apiTimeout = 30000;

  /// Whether to enable debug logging.
  static const bool enableLogging = true;

  /// App name.
  static const String appName = '8Move Transfer';

  /// Support email.
  static const String supportEmail = 'support@8move.com';

  /// Google Maps API Key (same as in AppDelegate.swift and AndroidManifest.xml).
  static const String googleMapsApiKey = 'AIzaSyDVKSZEG7OodJHiew1xrfE9D7KmxLzi9SA';
}
