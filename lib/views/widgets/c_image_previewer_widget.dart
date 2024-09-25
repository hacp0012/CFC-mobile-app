import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CImagePreviewerWidget extends StatefulWidget {
  const CImagePreviewerWidget({super.key, required this.pids, this.userFile = false, this.scaleSize = 45, this.startAt = 1});

  final List<String?> pids;
  final int startAt;
  final bool userFile;
  final int scaleSize;

  @override
  State<CImagePreviewerWidget> createState() => _CImagePreviewerWidgetState();
}

class _CImagePreviewerWidgetState extends State<CImagePreviewerWidget> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  late int cursor;

  late PageController pageController;

  List<dynamic> imageProviders = [];

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    cursor = widget.startAt;

    pageController = PageController(initialPage: cursor);

    if (widget.userFile == false) {
      for (String? pid in widget.pids) {
        imageProviders.add(
          CachedNetworkImageProvider(CImageHandlerClass.byPid(pid, scale: widget.scaleSize)),
        );
      }
    } else {
      imageProviders = widget.pids;
    }

    super.initState();
  }

  // WIDGET ------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CMiscClass.whenBrightnessOf(context, dark: Theme.of(context).colorScheme.surface),
        automaticallyImplyLeading: false,
        title: FilledButton.icon(
          onPressed: () => context.pop(),
          label: const Text("Retour"),
          icon: const Icon(CupertinoIcons.xmark),
        ),
        actions: [
          Text("${cursor + 1}/${imageProviders.length}", style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(width: CConstants.GOLDEN_SIZE),
          const IconButton.filledTonal(onPressed: null, icon: Icon(CupertinoIcons.down_arrow)),
          IconButton.filledTonal(
            onPressed: prev,
            icon: const Icon(CupertinoIcons.chevron_compact_left),
          ),
          IconButton.filledTonal(
            onPressed: next,
            icon: const Icon(CupertinoIcons.chevron_compact_right),
          )
        ],
      ),

      // -- BODY:
      body: PageView(
        controller: pageController,
        scrollBehavior: const MaterialScrollBehavior(),
        onPageChanged: (index) {
          setState(() => cursor = index);
        },
        children: imageProviders.map<InteractiveViewer>((image) {
          if (image == null) {
            return InteractiveViewer(child: const Image(image: AssetImage(Env.APP_ICON_ASSET)));
          }
          return InteractiveViewer(child: widget.userFile ? Image.file(File(image)) : Image(image: image));
        }).toList(),
      ),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
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
}
