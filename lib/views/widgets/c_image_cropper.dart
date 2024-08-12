import 'dart:io';
import 'dart:typed_data';

import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CImageCropper {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  BuildContext context;
  String? tempPath;
  String path;

  /// [croppedFile] has no path or filename it is a binary data.
  /// plz set it after.
  final Function(File croppedFile, Uint8List bytesList, String tempPath)? onCropped;

  final controller = CropController(
    /// If not specified, [aspectRatio] will not be enforced.
    aspectRatio: 1,

    /// Specify in percentages (1 means full width and height). Defaults to the full image.
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  // VIEW --------------------------------------------------------------------------------------------------------------------
  CImageCropper(this.context, {required this.path, String? titleText, this.onCropped}) {
    CModalWidget.fullscreen(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            Row(children: [
              const BackButton(),
              if (titleText != null)
                Text(
                  titleText,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const Spacer(),
              FilledButton.tonal(onPressed: crop, child: const Text("Recadrer")),
            ]),
            Expanded(
              child: CropImage(
                /// Only needed if you expect to make use of its functionality like setting initial values of
                /// [aspectRatio] and [defaultCrop].
                controller: controller,

                /// The image to be cropped. Use [Image.file] or [Image.network] or any other [Image].
                image: Image.file(File(path)),

                /// The crop grid color of the outer lines. Defaults to 70% white.
                gridColor: Theme.of(context).colorScheme.primaryContainer,

                /// The crop grid color of the inner lines. Defaults to [gridColor].
                gridInnerColor: Theme.of(context).colorScheme.primaryContainer,

                /// The crop grid color of the corner lines. Defaults to [gridColor].
                gridCornerColor: Theme.of(context).colorScheme.primaryContainer,

                /// The size of the corner of the crop grid. Defaults to 25.
                gridCornerSize: 50,

                /// Whether to display the corners. Defaults to true.
                showCorners: true,

                /// The width of the crop grid thin lines. Defaults to 2.
                gridThinWidth: 2,

                /// The width of the crop grid thick lines. Defaults to 5.
                gridThickWidth: 5,

                /// The crop grid scrim (outside area overlay) color. Defaults to 54% black.
                scrimColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),

                /// True: Always show third lines of the crop grid.
                /// False: third lines are only displayed while the user manipulates the grid (default).
                alwaysShowThirdLines: false,

                /// Event called when the user changes the crop rectangle.
                /// The passed [Rect] is normalized between 0 and 1.
                // onCrop: (rect) => print(rect),

                /// The minimum pixel size the crop rectangle can be shrunk to. Defaults to 100.
                minimumImageSize: 50,

                /// The maximum pixel size the crop rectangle can be grown to. Defaults to infinity.
                /// You can constrain the crop rectangle to a fixed size by setting
                /// both [minimumImageSize] and [maximumImageSize] to the same value (the width) and using
                /// the [aspectRatio] of the controller to force the other dimension (width / height).
                /// Doing so disables the display of the corners.
                maximumImageSize: 2000,
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void crop() async {
    var bitmap = await controller.croppedBitmap();

    ByteData? data = await bitmap.toByteData();
    Uint8List byte = data!.buffer.asUint8List();

    File file = File.fromRawPath(byte);

    Uint8List image8 = byte;
    final tempDir = (await getTemporaryDirectory()).path;
    File filex = await File("${tempDir}/temp_image.jpg");
    filex.writeAsBytesSync(byte, flush: true);

    onCropped?.call(file, byte, path);

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }
}
