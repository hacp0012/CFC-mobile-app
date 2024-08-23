import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:go_router/go_router.dart';

class CImageHandlerClass {
  static const int defaultScaleSize = 45;

  /// Get image http path by Public Id
  static String byPid(String? pid, {int scale = defaultScaleSize, String defaultImage = 'logos.logo'}) {
    var uri = Uri.parse("${Env.API_URL}/api/v1/photo/get/$scale/$pid/$defaultImage");

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

  static void show(BuildContext context, List<String?> pids, {int scaleSize = defaultScaleSize}) {
    dynamic imageProvider;

    if (pids.length > 1) {
      MultiImageProvider multiImageProvider = MultiImageProvider(
        pids
            .map((pid) => CachedNetworkImageProvider(
                  CImageHandlerClass.byPid(pid, scale: scaleSize),
                  cacheManager: DioCacheManager.instance,
                ))
            .toList(),
      );

      imageProvider = multiImageProvider;
    } else if (pids.isNotEmpty) {
      imageProvider = CachedNetworkImageProvider(
        CImageHandlerClass.byPid(pids.first, scale: scaleSize),
        cacheManager: DioCacheManager.instance,
      );
    }

    if (pids.isNotEmpty) {
      // showImageViewer(
      //   context,
      //   useSafeArea: true,
      //   doubleTapZoomable: true,
      //   immersive: false,
      //   // barrierColor: Theme.of(context).colorScheme.,
      //   imageProvider,
      // );
      CModalWidget.fullscreen(
        context: context,
        child: Stack(children: [
          Positioned.fill(
            child: InteractiveViewer(child: Image(image: imageProvider)),
          ),
          Positioned(
            child: Row(children: [
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              FilledButton.tonalIcon(
                onPressed: () => context.pop(),
                label: const Text("Retour"),
                icon: const Icon(CupertinoIcons.xmark),
              ),
              const Spacer(),
              Text("1/1", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              const IconButton.filledTonal(onPressed: null, icon: Icon(CupertinoIcons.chevron_compact_left)),
              const IconButton.filledTonal(onPressed: null, icon: Icon(CupertinoIcons.chevron_compact_right)),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
            ]),
          )
        ]),
      ).show();
    }
  }
}
