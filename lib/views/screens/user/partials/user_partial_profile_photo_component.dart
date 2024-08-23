import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/views/widgets/c_image_cropper.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watch_it/watch_it.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserPartialProfilePhotoComponent extends StatefulWidget with WatchItStatefulWidgetMixin {
  const UserPartialProfilePhotoComponent({super.key});

  @override
  State<StatefulWidget> createState() => _UserPartialProfilePhotoComponentState();
}

class _UserPartialProfilePhotoComponentState extends State<UserPartialProfilePhotoComponent> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool isOnline = false;
  final Map<String, dynamic>? userData = UserMv.data;
  Map userPhoto = {'loading': false};

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  void _s(fn) => super.setState(fn);

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    isOnline = watchValue<CNetworkState, bool>((CNetworkState state) => state.online);

    return Padding(
      padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
      child: Column(children: [
        GestureAnimator(
          child: Badge(
            offset: const Offset(-(CConstants.GOLDEN_SIZE * 2), -(CConstants.GOLDEN_SIZE * 2)),
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
            label: const Icon(CupertinoIcons.camera, size: CConstants.GOLDEN_SIZE * 2),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Hero(
              tag: "USER_PROFILE_PHOTO",
              child: CachedNetworkImage(
                cacheManager: DioCacheManager.instance,
                imageUrl: CImageHandlerClass.byPid(userData?['photo']),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    radius: CConstants.GOLDEN_SIZE * 6,
                    backgroundImage: userPhoto['loading'] ? null : imageProvider,
                    child: userPhoto['loading'] ? const CircularProgressIndicator(strokeCap: StrokeCap.round) : null,
                  );
                },
              ),
            ),
          ),
          onTap: () {
            CModalWidget(
              context: context,
              child: Padding(
                padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                    child: Text("Photo de profile", style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    title: const Text("Afficher la photo"),
                    leading: const Icon(CupertinoIcons.photo),
                    dense: false,
                    onTap: () {
                      CModalWidget.close(context);
                      CImageHandlerClass.show(context, [userData?['photo']], scaleSize: 90);
                    },
                  ),
                  ListTile(
                    title: const Text("Changer la photo"),
                    subtitle: Text(
                      "Sélectionnez une phone dans la bibliothèque.",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    leading: const Icon(CupertinoIcons.camera),
                    dense: false,
                    onTap: () {
                      CNetworkState.ifOnline(context, isOnline, () {
                        CModalWidget.close(context);
                        openFile();
                      });
                    },
                  ),
                  Row(children: [
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => CModalWidget.close(context),
                      icon: const Icon(CupertinoIcons.xmark, size: CConstants.GOLDEN_SIZE * 2),
                      label: const Text("Fermer"),
                      iconAlignment: IconAlignment.end,
                    ),
                  ]),
                ]),
              ),
            ).show();
          },
        ),

        // INFOS :
        SelectableText(userData?['name'] ?? '', style: Theme.of(context).textTheme.titleLarge),
        SelectableText(userData?['fullname'] ?? ''),
        Text(
            "${MiscDataHandlerMv.getRole(userData?['role']?['role'])['name']} "
            "[${MiscDataHandlerMv.getRole(userData?['role']?['role'])['level'] ?? 'App'}]",
            style: Theme.of(context).textTheme.labelSmall),
      ]),
    );
  }

  // FUNCTIONS ---------------------------------------------------------------------------------------------------------------
  void openFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png'],
    );

    if (file != null) {
      cropperAndUpload(file.files.first.xFile);
    }
  }

  void _showSnackbar(String message, [Color? color]) {
    CSnackbarWidget(context, content: Text(message), backgroundColor: color);
  }

  void cropperAndUpload(XFile xfile) {
    CImageCropper(context, path: xfile.path, squareGrid: true, onCropped: (tempPath) async {
      if (tempPath != null) {
        var data = FormData.fromMap({
          CConstants.IMAGE_UPLOAD_NAME: await MultipartFile.fromFile(
            tempPath,
            filename: xfile.name,
            contentType: MediaType.parse(xfile.mimeType ?? 'image/jpeg'),
          ),
        });

        _s(() => userPhoto['loading'] = true);
        CApi.request.post('/user/update/photo', data: data).then(
          (response) {
            if (response.data['state'] == 'STORED') {
              _s(() => userData?['photo'] = response.data['pid']);
              LoginMv().downloadAndInstallUserDatas();
            }
            _s(() => userPhoto['loading'] = false);
          },
          onError: (error) {
            _s(() => userPhoto['loading'] = false);
            _showSnackbar("Le téléversement n'a pas pût être effectué. Réessayer plus tard.");
          },
        );
      }
    });
  }
}
