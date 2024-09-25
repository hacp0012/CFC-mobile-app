import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/views/widgets/c_image_previewer_widget.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CImageHandlerClass {
  static const int defaultScaleSize = 45;

  /// Get image http path by Public Id
  static String byPid(String? pid, {int scale = defaultScaleSize, String defaultImage = 'logos.logo'}) {
    var uri = Uri.parse("${Env.API_URL}/api/v1/photo/get/$scale/$pid/$defaultImage");

    return uri.toString();
  }

  /// Get image http path by Public Id
  static String userById(String? userId, {int scale = defaultScaleSize, String defaultImage = 'logos.logo'}) {
    var uri = Uri.parse("${Env.API_URL}/api/v1/photo/user/$userId/$scale/$defaultImage");

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

  // open imagee previewer by [pids].
  static void show(
    BuildContext context,
    List<String?> pids, {
    bool userFile = false,
    int scaleSize = defaultScaleSize,
    int startAt = 1,
  }) {
    if (pids.isNotEmpty) {
      CModalWidget.fullscreen(
        context: context,
        child: CImagePreviewerWidget(pids: pids, userFile: userFile, scaleSize: scaleSize, startAt: startAt),
      ).show();
    }
  }
}
