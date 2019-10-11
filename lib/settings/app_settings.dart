// ignore_for_file: constant_identifier_names
class AppSettings {
  static const String API_BASE_URI = 'api.shutterstock.com';

  static AppEnvironment currentEnvironment;

  /// Setup different environment for the app
  /// Base on [env] you can setup up for example different backend URL for API
  static void setEnvironment(AppEnvironment env) {
    switch (env) {
      case AppEnvironment.DEV:
        // If we are running development
        break;
      case AppEnvironment.STAGING:
        // If we are running staging
        break;
      case AppEnvironment.PROD:
        // If we are running production
        break;
    }
    AppSettings.currentEnvironment = env;
  }
}

enum AppEnvironment { DEV, STAGING, PROD }