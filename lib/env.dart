// ignore_for_file: constant_identifier_names

class Env {
  static const bool DEBUG = true;

  /// Application name.
  static const String APP_NAME = 'CFC';

  /// Application slogan.
  static const String APP_SLOGAN = "L’amour, la joie, la paix du Christ";

  /// Application large name.
  static const String APP_LARGE_NAME = "Communauté Famille Chrétienne";

  /// Application small description.
  static const String APP_DESCRIPTION = "L’amour, la joie, la paix du Christ";

  /// Specify for somes features to be accessible offline too.
  static const bool APP_NETWORK_OFFLINE_MODE = false;

  /// Local API local url
  // static const String API_LOCAL_URL = "http://10.0.2.2";
  // static const String API_LOCAL_URL = "https://cfc-media.org";
  static const String API_LOCAL_URL = "http://192.168.213.140:80";

  /// API real url.
  static const String API_URL = DEBUG ? API_LOCAL_URL : "";

  static const String APP_ICON_ASSET = "lib/assets/icons/LOGO_CFC_512.png";

  static const String API_SESSION_TOKEN_NAME = '5076ff2e-f192-4504-8fa7-da16a5c83df0';

  /// Database version.
  static const int APP_DATABSE_VERSION = 1;

  /// Databse name.
  static const String APP_DATABSE_NAME = 'cfc_database';

  /// Background service ID.
  static const String APP_BACKGROUND_SERVICE_NAME = 'CFC_BACKGROUND_FOREGROUND_SERVICE';

  static const String NOTIFICATION_STORE_NAME = "60749d8c-9482-4e34-8c92-d75b8aec129c";
}
