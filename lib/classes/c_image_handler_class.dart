import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
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

  // open imagee previewer by [pids].
  static void show(
    BuildContext context,
    List<String?> pids, {
    bool userFile = false,
    int scaleSize = defaultScaleSize,
    int startAt = 1,
  }) {
    // List<CachedNetworkImageProvider> imageProviders = [];
    List<dynamic> imageProviders = [];

    if (userFile == false) {
      for (String? pid in pids) {
        imageProviders.add(
          CachedNetworkImageProvider(CImageHandlerClass.byPid(pid, scale: scaleSize), cacheManager: DioCacheManager.instance),
        );
      }
    } else {
      imageProviders = pids;
    }

    if (pids.isNotEmpty) {
      int cursor = startAt;

      PageController pageController = PageController(initialPage: cursor);

      next() {
        if (cursor < imageProviders.length) {
          pageController.animateToPage(cursor + 1, duration: const Duration(milliseconds: 801), curve: Curves.ease);
        }
      }

      prev() {
        if ((cursor + 1) > 1) {
          pageController.animateToPage(cursor - 1, duration: const Duration(milliseconds: 801), curve: Curves.ease);
        }
      }

      CModalWidget.fullscreen(
        context: context,
        child: Stack(children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) => cursor = index,
              children: imageProviders.map<InteractiveViewer>((image) {
                if (image == null) {
                  return InteractiveViewer(child: const Image(image: AssetImage(Env.APP_ICON_ASSET)));
                }
                return InteractiveViewer(child: userFile ? Image.file(File(image)) : Image(image: image));
              }).toList(),
            ),
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
              Text("$cursor/${imageProviders.length}", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
              const IconButton.filledTonal(onPressed: null, icon: Icon(CupertinoIcons.down_arrow)),
              IconButton.filledTonal(
                onPressed: prev,
                icon: const Icon(CupertinoIcons.chevron_compact_left),
              ),
              IconButton.filledTonal(
                onPressed: next,
                icon: const Icon(CupertinoIcons.chevron_compact_right),
              ),
              const SizedBox(width: CConstants.GOLDEN_SIZE),
            ]),
          )
        ]),
      ).show();
    }
  }
}
