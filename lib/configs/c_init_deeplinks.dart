import 'package:app_links/app_links.dart';

class CDeeplinks {
  late AppLinks _appLinks;

  Future<void> startWatching() async {
    _appLinks = AppLinks(); // AppLinks is singleton
    // Subscribe to all events (initial link and further)
    _appLinks.uriLinkStream.listen((uri) {
      // TODO: implement UrlLauncher here...
    });
  }
}
