import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_document_handler_class.dart';
import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:cfc_christ/services/c_s_draft.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/echo/read_echo_screen.dart';
import 'package:cfc_christ/views/screens/user/user_comments_admin.dart';
import 'package:cfc_christ/views/widgets/c_audio_reader_widget.dart';
import 'package:cfc_christ/views/widgets/c_audio_recoder_widget.dart';
import 'package:cfc_christ/views/widgets/c_document_select_file_widget.dart';
import 'package:cfc_christ/views/widgets/c_image_cropper.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pretty_print_json/pretty_print_json.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/styled_text.dart';

class EditEchoScreen extends StatefulWidget {
  static const String routeName = 'edit.echo';
  static const String routePath = 'edit/echo';

  const EditEchoScreen({super.key, required this.echoId});

  final String? echoId;

  @override
  State<EditEchoScreen> createState() => _EditEchoScreenState();
}

class _EditEchoScreenState extends State<EditEchoScreen> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  CSDraft draftInstance = CSDraft("F6BxXmiFg4CW8gIjfu");

  Map<String, dynamic>? userData = UserMv.data;

  bool isInLoadingData = true;

  bool isInPushingMode = false;

  TextEditingController textEditingControllerTitle = TextEditingController();
  TextEditingController textEditingControllerCom = TextEditingController();
  var titleTextFieldKey = GlobalKey<FormState>();
  var comTextFieldKkey = GlobalKey<FormState>();

  String? selectHeadPicture;
  String? attachedDocument;

  bool comStatus = false;

  // Loaded datas : --> -----------------|
  Map echoData = {}; // Com datas.
  int commentsCounts = 0;
  List picturesList = [];

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void initState() {
    textEditingControllerTitle.text = draftInstance.data('title') ?? '';
    textEditingControllerCom.text = draftInstance.data('teaching') ?? '';

    super.initState();

    loadingEcho();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(CupertinoIcons.pen),
              SizedBox(width: CConstants.GOLDEN_SIZE),
              Text('Echo'),
            ],
          ),
          actions: [
            Visibility(
              visible: isInPushingMode,
              replacement: TextButton(
                onPressed: isInPushingMode ? null : showPost,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.eye),
                    Text("Voir", style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child:
                      const CircularProgressIndicator(strokeCap: StrokeCap.round).animate(effects: CTransitionsTheme.model_1),
                ),
              ),
            ),
            Badge(
              isLabelVisible: true,
              offset: const Offset(3, 4),
              label: Text(CMiscClass.numberAbrev(commentsCounts.toDouble())),
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: isInPushingMode ? null : openCommentsMan,
                icon: const Icon(CupertinoIcons.chat_bubble_text_fill),
              ),
            ),
          ],
        ),

        // ->--
        body: Builder(builder: (context) {
          if (isInLoadingData) {
            return Center(
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surfaceContainer,
                highlightColor: CConstants.PRIMARY_COLOR,
                child: StyledText(
                  text: "<bold>Chargement</bold>"
                      '<br/>'
                      "Le écho est en cours de chargement ",
                  textAlign: TextAlign.center,
                  tags: CStyledTextTags().tags,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.only(
              left: CConstants.GOLDEN_SIZE,
              right: CConstants.GOLDEN_SIZE,
              top: CConstants.GOLDEN_SIZE,
              bottom: CConstants.GOLDEN_SIZE * 7,
            ),
            children: [
              // --- Heading image :
              Padding(
                padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                child: Column(children: [
                  /*Visibility(
                    visible: echoData?['picture'] != null,
                    child: Animate(
                      effects: [FadeEffect(duration: 1.seconds)],
                      child: GestureAnimator(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 27),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                            child: Image.network(CImageHandlerClass.byPid(echoData?['picture'] ?? '---')),
                          ),
                        ),
                        onTap: () => CImageHandlerClass.show(context, [echoData?['picture']]),
                      ),
                    ),
                  ),*/

                  // Pictures List :
                  ...List.generate(
                    picturesList.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE / 2),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        CircleAvatar(
                          radius: CConstants.GOLDEN_SIZE * 2,
                          foregroundImage: CachedNetworkImageProvider(CImageHandlerClass.byPid(picturesList[index])),
                        ),
                        const SizedBox(width: CConstants.GOLDEN_SIZE),
                        FilledButton.tonalIcon(
                          onPressed: () => CImageHandlerClass.show(
                            context,
                            picturesList.map((e) => e as String).toList(),
                            startAt: index,
                          ),
                          label: Text("Voir la photo No. ${index + 1}"),
                          style: const ButtonStyle(visualDensity: VisualDensity.compact),
                          icon: const Icon(CupertinoIcons.photo),
                        ),
                        const SizedBox(width: CConstants.GOLDEN_SIZE),
                        IconButton(
                          onPressed: isInPushingMode ? null : () => removePicture(index),
                          style: const ButtonStyle(visualDensity: VisualDensity.compact),
                          icon: const Icon(CupertinoIcons.xmark),
                        ).animate(effects: CTransitionsTheme.model_1),
                      ]),
                    ),
                  ),

                  // --- Add Photo button.
                  Padding(
                    padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE / 2),
                    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      FilledButton.tonalIcon(
                        onPressed: headPictureSelectorAndCropper,
                        label: const Text("Ajouter un photo"),
                        style: const ButtonStyle(visualDensity: VisualDensity.compact),
                        icon: const Icon(CupertinoIcons.add),
                      ),
                    ]),
                  ),
                ]),
              ),

              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Card(
                margin: EdgeInsets.zero,
                elevation: .0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS / 2)),
                          child: Form(
                            key: titleTextFieldKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: textEditingControllerTitle,
                              validator: CFormValidator([CFormValidator.required(message: "Un titre est requis")]).validate,
                              onChanged: (value) => draftInstance.keep('title', value),
                              decoration: const InputDecoration(
                                isCollapsed: false,
                                hintText: "Modifier le titre de l'enseignement",
                                labelText: "Titre de l'enseignement",
                                border: InputBorder.none,
                                prefixIcon: Icon(CupertinoIcons.bookmark_fill),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // --- Text body :
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS / 2)),
                          child: Form(
                            key: comTextFieldKkey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: textEditingControllerCom,
                              validator: CFormValidator([
                                CFormValidator.required(
                                  message: "Un tout petit texte descriptif de votre communiqué est nécessaire.",
                                ),
                                CFormValidator.min(9),
                              ]).validate,
                              onChanged: (value) => draftInstance.keep('teaching', value),
                              decoration: const InputDecoration(
                                labelText: "Enseignement en texte (obligatoire)",
                                hintText: "Écrivez le cours de vôtre enseignement ici ... Juste quelques lignes ou plus",
                                border: InputBorder.none,
                                hintMaxLines: 2,
                                helperMaxLines: 2,
                                errorMaxLines: 2,
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                prefixIcon: Icon(CupertinoIcons.t_bubble),
                                prefixIconConstraints: BoxConstraints(minWidth: CConstants.GOLDEN_SIZE * 4),
                                constraints: BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 36),
                              ),
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                        ),
                      ),

                      // --- TTS reader button :
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                          child: CTtsReaderWidget(text: () => textEditingControllerCom.text, buttonText: "Lire"),
                        ),
                        ElevatedButton.icon(
                          onPressed: isInPushingMode ? null : updateText,
                          icon: const Icon(Icons.save),
                          iconAlignment: IconAlignment.end,
                          label: const Text("Enregistrer"),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),

              // --- Attache FIle :
              const Padding(
                padding: EdgeInsets.only(
                  top: CConstants.GOLDEN_SIZE * 2,
                  left: CConstants.GOLDEN_SIZE,
                  bottom: CConstants.GOLDEN_SIZE,
                ),
                child: Text('Document'),
              ),
              Visibility(
                visible: echoData['document']['pid'] == null,
                replacement: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                    child: ListTile(
                      title: const Text("Document :"),
                      subtitle: Text(echoData['document']?['name'] ?? "Aucun document."),
                      dense: true,
                      isThreeLine: true,
                      // trailing: GestureAnimator(child: const Icon(CupertinoIcons.xmark), onTap: () {},),
                      trailing: IconButton(
                          onPressed: isInPushingMode ? null : removeDocument, icon: const Icon(CupertinoIcons.xmark)),
                    ),
                  ),
                ),
                child: CDocumentSelectFileWidget(
                  onSelect: isInPushingMode ? null : updateDocument,
                ).animate(effects: CTransitionsTheme.model_1),
              ),

              // --> Audio :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              const Padding(
                padding: EdgeInsets.all(9.0),
                child: Text('Audio'),
              ),
              Visibility(
                visible: echoData['audio'] != null,
                replacement: CAudioRecoderWidget(onFinish: updateAudio).animate(effects: CTransitionsTheme.model_1),
                child: Column(children: [
                  CAudioReaderWidget(audioSource: CDocumentHandlerClass.byPid(echoData['audio'] ?? '---')),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextButton.icon(
                      icon: const Icon(CupertinoIcons.refresh),
                      style: const ButtonStyle(visualDensity: VisualDensity.compact),
                      onPressed: isInPushingMode ? null : () {
                        CSAudioPalyer.inst.source = CDocumentHandlerClass.byPid(echoData['audio'] ?? '---');
                      },
                      label: const Text("Recharger"),
                    ),
                    FilledButton.icon(
                      icon: const Icon(CupertinoIcons.trash),
                      style: const ButtonStyle(visualDensity: VisualDensity.compact),
                      onPressed: isInPushingMode ? null : removeAudio,
                      label: const Text("Retirer l'audio"),
                    ),
                  ]),
                ]),
              ),
            ],
          ).animate(effects: CTransitionsTheme.model_1);
        }),
      ),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  void loadingEcho() async {
    setState(() {
      isInLoadingData = true;
      isInPushingMode = true;
    });

    CApi.request.get('/echo/quest/edit.get.UclrFc9HDV4oCtJhfq', data: {'echo_id': widget.echoId}).then(
      (res) {
        if (res.data is Map && res.data['success']) {
          setState(() {
            // prettyPrintJson(res.data);
            commentsCounts = res.data['comments'] ?? 0;
            echoData = res.data['echo'];
            picturesList = res.data['pictures'];

            isInLoadingData = false;
            isInPushingMode = false;

            draftInstance.free();

            textEditingControllerTitle.text = echoData['title'] ?? '';
            textEditingControllerCom.text = echoData['text'] ?? '';
          });
        } else {
          _failed();
        }
      },
      onError: (err) => _failed(),
    );
  }

  void _failed() {
    CSnackbarWidget.direct(const Text("Contenu introuvable."), backgroundColor: Colors.red, defaultDuration: true);

    context.pop();
  }

  void headPictureSelectorAndCropper() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(type: FileType.image);

    if (filePickerResult != null) {
      CImageCropper(
        path: filePickerResult.xFiles.first.path,
        titleText: "Photo d'entête",
        gridMode: CropAspectRatioPreset.ratio4x3,
        onCropped: (tempPath) => updatePicture(tempPath),
      );
    }
  }

  bool requiredDataValidator() {
    if (titleTextFieldKey.currentState!.validate() == false) {
      return false;
    }

    if (comTextFieldKkey.currentState!.validate() == false) {
      return false;
    }

    return true;
  }

  void updateText() {
    if (requiredDataValidator()) {
      setState(() => isInPushingMode = true);

      Map data = {
        'echo_id': widget.echoId,
        'title': textEditingControllerTitle.text,
        'text': textEditingControllerCom.text,
      };

      String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      CApi.request.post('/echo/quest/edit.update.text.HpCyO42ugbAa85Q1MG', data: data).then(
        (res) {
          if (res.data is Map && res.data['success']) {
            setState(() => isInPushingMode = false);
            CSnackbarWidget.direct(const Text("Mises à jour effectué avec succès."), defaultDuration: true);
          } else {
            CSnackbarWidget.direct(Text(failedMessage));
          }
        },
        onError: (err) => setState(
          () {
            isInPushingMode = false;
            CSnackbarWidget.direct(Text(failedMessage));
          },
        ),
      );
    }
  }

  void removePicture(int index) {
    if (picturesList.isNotEmpty) {
      setState(() => isInPushingMode = true);

      const String failedMessage = "La suppression a échou. Réessaye plus tard.";

      Map data = {'pid': picturesList[index]};

      CApi.request.delete('/echo/quest/edit.remove.picture.Mg1CdY0SbHZ5h76aiC', data: data).then(
        (res) {
          setState(() => isInPushingMode = false);
          if (res.data is Map && res.data['success']) {
            setState(() => picturesList.removeAt(index));

            CSnackbarWidget.direct(const Text('Photo supprimé avec succès.'), defaultDuration: true);
          } else {
            CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
          }
        },
        onError: (err) {
          setState(() => isInPushingMode = false);
          CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
        },
      );
    }
  }

  void updatePicture(String? filePath) {
    if (filePath != null) {
      const String failedMessage = "L'ajoue a échou. Réessaye plus tard.";

      setState(() => isInPushingMode = true);

      var data = FormData.fromMap({
        'echo_id': widget.echoId,
        'picture': MultipartFile.fromFileSync(filePath),
      });

      CApi.request.post('/echo/quest/edit.add.picture.ORmFOLoAyTNnWJSNs3', data: data).then(
        (res) {
          setState(() => isInPushingMode = false);

          if (res.data is Map && res.data['success']) {
            setState(() => picturesList.add(res.data['pid']));

            CSnackbarWidget.direct(const Text('Ajoutée avec succès.'), defaultDuration: true);
          } else {
            CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
          }
        },
        onError: (err) {
          setState(() => isInPushingMode = false);
          CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
        },
      );
    }
  }

  void removeDocument() {
    setState(() => isInPushingMode = true);

    Map data = {'pid': echoData['document']['pid'] ?? '---'};

    const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.delete('/echo/quest/edit.remove.document.43HXMZvScDOZKq1F0z', data: data).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['success']) {
          setState(() => echoData['document'] = {'name': null, 'pid': null});

          CSnackbarWidget.direct(const Text('Document supprimé avec succès.'), defaultDuration: true);
        } else {
          CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
        }
      },
      onError: (err) {
        setState(() => isInPushingMode = false);
        CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
      },
    );
  }

  void updateDocument(String? documentPath) {
    setState(() => isInPushingMode = true);

    var param = FormData.fromMap({
      'echo_id': widget.echoId,
      'document': MultipartFile.fromFileSync(documentPath ?? '---'),
    });

    String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.post('/echo/quest/edit.update.document.64DUWiID5rKO8hHa8l', data: param).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['success']) {
          setState(() {
            echoData['document']['pid'] = res.data['pid'];
            echoData['document']['name'] = "Document mises à jour";
          });

          CSnackbarWidget.direct(const Text("Mises à jour effectué avec succès."), defaultDuration: true);
        } else {
          CSnackbarWidget.direct(Text(failedMessage), defaultDuration: true);
        }
      },
      onError: (err) {
        setState(() => isInPushingMode = false);
        CSnackbarWidget.direct(Text(failedMessage), defaultDuration: true);
      },
    );
  }

  void updateAudio(String? audioPath) {
    setState(() => isInPushingMode = true);

    if (audioPath != null) {
      var param = FormData.fromMap({
        'echo_id': widget.echoId,
        'audio': MultipartFile.fromFileSync(audioPath),
      });

      String failedMessage = "La mises à jour a échou. Réessaye plus tard. "
          "Vérifier la taille du fichier, qui doit être inférieur à 9Mo";

      CApi.request.post('/echo/quest/edit.update.audio.jEZ3K79hxn2RXZ6MFx', data: param).then(
        (res) {
          setState(() => isInPushingMode = false);

          if (res.data is Map && res.data['success']) {
            setState(() => echoData['audio'] = res.data['pid']);

            Timer(900.ms, () => CSAudioPalyer.inst.source = CDocumentHandlerClass.byPid(res.data['pid']));

            CSnackbarWidget.direct(const Text("Mises à jour effectué avec succès."), defaultDuration: true);
          } else {
            CSnackbarWidget.direct(Text(failedMessage), defaultDuration: true);
          }
        },
        onError: (err) {
          setState(() => isInPushingMode = false);
          CSnackbarWidget.direct(Text(failedMessage), defaultDuration: true);
        },
      );
    } else {
      setState(() => isInPushingMode = false);
    }
  }

  void removeAudio() {
    setState(() => isInPushingMode = true);

    Map data = {'pid': echoData['audio'] ?? '---'};

    const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.delete('/echo/quest/edit.remove.audio.nuKFP67aCAAokKalWy', data: data).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['success']) {
          setState(() => echoData['audio'] = null);

          CSnackbarWidget.direct(const Text('Audio supprimé avec succès.'), defaultDuration: true);
        } else {
          CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
        }
      },
      onError: (err) {
        prettyPrintJson(err);
        setState(() => isInPushingMode = false);
        CSnackbarWidget.direct(const Text(failedMessage), defaultDuration: true);
      },
    );
  }

  void showPost() {
    if (echoData['audio'] != null) CSAudioPalyer.inst.dispose();

    context.pushNamed(ReadEchoScreen.routeName, extra: {'com_id': widget.echoId});
  }

  void openCommentsMan() {
    context.pushNamed(UserCommentsAdminScreen.routeName, extra: {'section_name': 'ECHO', 'id': widget.echoId, 'admin': true});
  }
}
