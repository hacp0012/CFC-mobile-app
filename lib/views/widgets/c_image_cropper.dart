import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CImageCropper {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  BuildContext context;

  final Function(String? tempPath)? onCropped;

  // VIEW --------------------------------------------------------------------------------------------------------------------
  CImageCropper(
    this.context, {
    required String path,
    bool squareGrid = false,
    String? titleText,
    int compressQuality = 90,
    String? mimeType,
    this.onCropped,
  }) {
    () async {
      ImageCompressFormat compressFormat = ImageCompressFormat.jpg;
      if (mimeType == 'image/png') {
        compressFormat = ImageCompressFormat.png;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        compressFormat: compressFormat,
        compressQuality: compressQuality,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: titleText,
            statusBarColor: Theme.of(context).colorScheme.surfaceContainer,
            toolbarColor: Theme.of(context).colorScheme.surfaceContainer,
            toolbarWidgetColor: CMiscClass.whenBrightnessOf<Color>(context, dark: CConstants.LIGHT_COLOR),
            backgroundColor: Theme.of(context).colorScheme.surface,
            cropFrameColor: CConstants.LIGHT_COLOR,
            cropGridColor: CConstants.LIGHT_COLOR,
            // activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
            // showCropGrid: false,
            hideBottomControls: true,
            initAspectRatio: squareGrid ? CropAspectRatioPreset.square : CropAspectRatioPreset.original,
            cropStyle: CropStyle.rectangle,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          )
        ],
      );

      _crop(croppedFile?.path);
    }();
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void _crop(String? path) async {
    onCropped?.call(path);

    // var bitmap = await controller.croppedBitmap();
    // var bitmap = await controller.croppedImage();

    // ByteData? data = await bitmap.toByteData();
    // Uint8List byte = data!.buffer.asUint8List();

    // File file = File.fromRawPath(byte);

    // Uint8List image8 = byte;
    // final tempDir = (await getTemporaryDirectory()).path;
    // File filex = await File("${tempDir}/temp_image.jpg").create();
    // File xfile = await filex.writeAsBytes(byte, flush: true);
  }
}
