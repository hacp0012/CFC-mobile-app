import 'package:cfc_christ/env.dart';

class CImageHandlerClass {
  /// Get image http path by Public Id
  static String byPid(String? pid, {int scale = 45, String defaultImage = 'logos.logo'}) {
    var uri = Uri.parse("${Env.API_URL}/api/v1/photo/get/$pid/$scale/$defaultImage");

    return uri.toString();
  }

  /// Download image
  static bool download(String url) {
    // TODO: implement image download handler.
    return false;
  }

  /// Downlaod image by Public Id with settings.
  /// Download in a desired size.
  static bool downloadByPid(String? pid, {int scale = 45, String defaultImg = 'no-image'}) {
    // TODO: implement image dowload by pid handler.
    return false;
  }
}
