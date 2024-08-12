import 'dart:io';

import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/auth/login_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/views/screens/family/user_family_home_screen.dart';
import 'package:cfc_christ/views/screens/user/profile_setting_screen.dart';
import 'package:cfc_christ/views/screens/user/user_edit_pcn_screen.dart';
import 'package:cfc_christ/views/screens/user/user_favorits_screen.dart';
import 'package:cfc_christ/views/screens/user/user_publications_list_screen.dart';
import 'package:cfc_christ/views/screens/user/user_responsability_screen.dart';
import 'package:cfc_christ/views/screens/user/validable_screen.dart';
import 'package:cfc_christ/views/widgets/c_image_cropper.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:crop_image/crop_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http_parser/http_parser.dart';
import 'package:share_plus/share_plus.dart';

class UserPartialProfileScreen extends StatefulWidget {
  const UserPartialProfileScreen({super.key, this.showEditButton = false});

  final bool showEditButton;

  @override
  State<UserPartialProfileScreen> createState() => _UserPartialProfileScreenState();
}

class _UserPartialProfileScreenState extends State<UserPartialProfileScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  final Map<String, dynamic>? userData = UserMv.data;
  Map userPhoto = {'loading': false};
  final controller = CropController(
    /// If not specified, [aspectRatio] will not be enforced.
    aspectRatio: 1,

    /// Specify in percentages (1 means full width and height). Defaults to the full image.
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
  }

  void _s(fn) => super.setState(fn);

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: Column(children: [
          InkWell(
            child: Badge(
              offset: const Offset(-(CConstants.GOLDEN_SIZE * 2), -(CConstants.GOLDEN_SIZE * 2)),
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
              label: const Icon(CupertinoIcons.camera, size: CConstants.GOLDEN_SIZE * 2),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: CachedNetworkImage(
                cacheManager: DioCacheManager.instance,
                // cacheKey: 'USER_PHOTO_CACHE_KEY',
                imageUrl: CImageHandlerClass.byPid(userData?['photo']),
                imageBuilder: (context, imageProvider) {
                  return CircleAvatar(
                    radius: CConstants.GOLDEN_SIZE * 5,
                    backgroundImage: userPhoto['loading'] ? null : imageProvider,
                    child: userPhoto['loading'] ? const CircularProgressIndicator(strokeCap: StrokeCap.round) : null,
                  );
                },
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
                      onTap: () {},
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
                        CModalWidget.close(context);
                        openFile();
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
          Text("Role : ${userData?['role'] ?? 'Lecteur'}", style: Theme.of(context).textTheme.labelSmall),
          if (widget.showEditButton)
            FilledButton.tonalIcon(
              onPressed: () => context.pushNamed(ProfileSettingScreen.routeName),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Modifier"),
            ),
        ]),
      ),

      // --- Options bar :
      const SizedBox(height: CConstants.GOLDEN_SIZE),
      Row(children: [
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text("Mon profil", style: Theme.of(context).textTheme.labelMedium),
        ),
        InkWell(
          onTap: () => context.pushNamed(UserPublicationsListScreen.routeName),
          child: Text(
            "Mes Publications",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(width: CConstants.GOLDEN_SIZE * 2),
        InkWell(
          onTap: () => context.pushNamed(UserFavoritsScreen.routeName),
          child: Text(
            "🩷 Mes favoris",
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ]),
      const Padding(padding: EdgeInsets.symmetric(horizontal: 9.0), child: Divider(thickness: 0.5)),

      // --- HOME LINKS :
      ListTile(
        leading: const Icon(CupertinoIcons.person_3),
        title: const Text("Votre PCN"),
        subtitle: const Text("Changer votre Pool, Communauté locale et votre noyau d’affermissement."),
        onTap: () => context.pushNamed(UserEditPcnScreen.routeName),
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.person_crop_circle_badge_checkmark),
        title: const Text("Responsabilité"),
        subtitle: const Text(
          "Définir votre responsabilité/position au niveau du Pool ou Communauté "
          "locale ou noyau d'affermissement.",
        ),
        onTap: () => context.pushNamed(UserResponsabilityScreen.routeName),
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.person_2),
        title: const Text("Ma fimille"),
        subtitle: const Text("Gérer mon couple, mes enfants et les enfants dont je suis parrain."),
        onTap: () => context.pushNamed(UserFamilyHomeScreen.routeName),
      ),
      ListTile(
        leading: const Icon(CupertinoIcons.shield_lefthalf_fill),
        title: const Text("Demandes d'aprobation"),
        subtitle: const Text("Valider les demandes d'approbation qui m'ont étaient envoyés."),
        onTap: () => context.pushNamed(ValidableScreen.routeName),
      ),
    ]);
  }

  // FUNCTIONS ---------------------------------------------------------------------------------------------------------------
  void openFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpeg', 'png'],
    );

    if (file != null) {
      var picked = file.files.first.xFile;
      cropperAndUpload(picked);
    }
  }

  void _showSnackbar(String message, [Color? color]) {
    CSnackbarWidget(context, content: Text(message), backgroundColor: color);
  }

  void cropperAndUpload(XFile xfile) {
    CImageCropper(context, path: xfile.path, onCropped: (croppedFile, bytesList, tempPath) async {
      print("8888888888888888888888888888888888888");
      print(xfile.path);
      var data = FormData.fromMap({
        CConstants.IMAGE_UPLOAD_NAME: await MultipartFile.fromFile(
          tempPath,
          filename: xfile.name,
          // contentType: MediaType.parse(xfile.mimeType ?? 'image/jpeg'),
        ),
        // CConstants.IMAGE_UPLOAD_NAME: MultipartFile.fromBytes(
        //   bytesList,
        //   filename: xfile.name,
        //   contentType: MediaType.parse(xfile.mimeType ?? 'application/octet-stream'),
        // ),
      });

      _s(() => userPhoto['loading'] = true);
      CApi.request.post('/user/update/photo', data: data).then(
        (response) {
          print(response.data);
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
    });
  }
}
