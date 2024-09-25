import 'dart:async';

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
import 'package:cfc_christ/views/screens/teaching/read_teaching_screen.dart';
import 'package:cfc_christ/views/widgets/c_audio_reader_widget.dart';
import 'package:cfc_christ/views/widgets/c_audio_recoder_widget.dart';
import 'package:cfc_christ/views/widgets/c_document_select_file_widget.dart';
import 'package:cfc_christ/views/widgets/c_image_cropper.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:pretty_print_json/pretty_print_json.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class EditTeachingScreen extends StatefulWidget {
  static const String routeName = 'edit.teaching';
  static const String routePath = 'edit/teaching';

  const EditTeachingScreen({super.key, required this.teachId});

  final String? teachId;

  @override
  State<EditTeachingScreen> createState() => _EditTeachingScreenState();
}

class _EditTeachingScreenState extends State<EditTeachingScreen> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  CSDraft draftInstance = CSDraft("erHVxnM7nshaPYaXVc");

  Map<String, dynamic>? userData = UserMv.data;

  bool isInLoadingData = true;

  bool isInPushingMode = false;

  TextEditingController textEditingControllerTitle = TextEditingController();
  TextEditingController textEditingControllerCom = TextEditingController();
  TextEditingController textEditingControllerPredicator = TextEditingController();
  TextEditingController textEditingControllerVerse = TextEditingController();
  TextEditingController textEditingControllerDate = TextEditingController();

  var predicatorTextFieldKey = GlobalKey<FormState>();
  var dateVerseTextFieldKey = GlobalKey<FormState>();
  var titleTextFieldKey = GlobalKey<FormState>();
  var echoTextFieldKkey = GlobalKey<FormState>();

  final _focusNodeEditorCom = FocusNode();

  String? selectHeadPicture;
  String? attachedDocument;

  bool comStatus = false;

  // Loaded datas : --> -----------------|
  Map teachData = {}; // Com datas.
  int commentsCounts = 0;

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void initState() {
    textEditingControllerTitle.text = draftInstance.data('title') ?? '';
    textEditingControllerCom.text = draftInstance.data('teaching') ?? '';

    super.initState();

    loadingTeach();
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
              Text('Enseignement'),
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
                  )),
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
                      "Le communiqué est en cours de chargement ",
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
                  Visibility(
                    visible: teachData['picture'] != null,
                    child: Animate(
                      effects: [FadeEffect(duration: 1.seconds)],
                      child: GestureAnimator(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 27),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                            child: Image.network(CImageHandlerClass.byPid(teachData['picture'] ?? '---')),
                          ),
                        ),
                        onTap: () => CImageHandlerClass.show(context, [teachData['picture']]),
                      ),
                    ),
                  ),

                  // --- Photo button.
                  Padding(
                    padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE / 2),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FilledButton.tonalIcon(
                        onPressed: headPictureSelectorAndCropper,
                        label: const Text("Changer/Ajouter"),
                        style: const ButtonStyle(visualDensity: VisualDensity.compact),
                        icon: const Icon(CupertinoIcons.photo),
                      ),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      IconButton(
                        onPressed: (isInPushingMode || teachData['picture'] == null) ? null : removePicture,
                        style: const ButtonStyle(visualDensity: VisualDensity.compact),
                        icon: const Icon(CupertinoIcons.xmark),
                      ).animate(effects: CTransitionsTheme.model_1),
                    ]),
                  ),
                ]),
              ),

              Card(
                margin: EdgeInsets.zero,
                elevation: .0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    // --- Title :
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS / 2)),
                        child: Form(
                          key: titleTextFieldKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
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

                    // --- Date & Verse :
                    Padding(
                      padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
                        child: Form(
                          key: dateVerseTextFieldKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Row(children: [
                            // --- Teaching date :
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: textEditingControllerDate,
                                validator: CFormValidator([CFormValidator.date(message: "Ex. jj/mm/aaaa")]).validate,
                                onChanged: (value) => draftInstance.keep('date', value),
                                keyboardType: TextInputType.datetime,
                                inputFormatters: [TextInputMask(mask: '99/99/9999', placeholder: '-', maxPlaceHolders: 8)],
                                decoration: const InputDecoration(
                                  isCollapsed: false,
                                  hintText: "00/00/2024",
                                  labelText: "Date de prédication",
                                  border: InputBorder.none,
                                  prefixIcon: Icon(CupertinoIcons.calendar),
                                  prefixIconConstraints: BoxConstraints(minWidth: CConstants.GOLDEN_SIZE * 4),
                                ),
                              ),
                            ),

                            // --- Biblic verse :
                            const SizedBox(width: CConstants.GOLDEN_SIZE),
                            Expanded(
                              flex: 4,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: textEditingControllerVerse,
                                // validator: CFormValidator([CFormValidator.date()]).validate,
                                onChanged: (value) => draftInstance.keep('verse', value),
                                decoration: const InputDecoration(
                                  isCollapsed: false,
                                  hintText: "Versé ...",
                                  labelText: "Versé biblique",
                                  border: InputBorder.none,
                                  prefixIcon: Icon(CupertinoIcons.book),
                                  prefixIconConstraints: BoxConstraints(minWidth: CConstants.GOLDEN_SIZE * 4),
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),

                    // --- Predicator :
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                      child: Form(
                        key: predicatorTextFieldKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: textEditingControllerPredicator,
                            validator:
                                CFormValidator([CFormValidator.required(message: "Un nom d'un prédicateur est requise")])
                                    .validate,
                            onChanged: (value) => draftInstance.keep('predicator', value),
                            decoration: const InputDecoration(
                              isCollapsed: false,
                              hintText: "Entrer le nom du prédicateur",
                              labelText: "Prédicateur de l'enseignement",
                              border: InputBorder.none,
                              prefixIcon: Icon(CupertinoIcons.person_alt),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // --- Text body :
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                      child: Form(
                        key: echoTextFieldKkey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: textEditingControllerCom,
                          focusNode: _focusNodeEditorCom,
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
                            // border: InputBorder.none,
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
                    // Markdown toolbar
                    MarkdownToolbar(
                      useIncludedTextField: false,
                      controller: textEditingControllerCom,
                      focusNode: _focusNodeEditorCom,

                      alignCollapseButtonEnd: true,
                      borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2),
                      spacing: CConstants.GOLDEN_SIZE / 2,
                      iconSize: CConstants.GOLDEN_SIZE * 2,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      flipCollapseButtonIcon: true,
                      height: CConstants.GOLDEN_SIZE * 3,
                      width: CConstants.GOLDEN_SIZE * 3,
                      iconColor: Theme.of(context).colorScheme.onSurface,
                      hideCode: true,
                      hideImage: true,
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
                  ]),
                ),
              ),

              // --- Attache FIle :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                child: Text('Document'),
              ),
              Visibility(
                visible: teachData['document']['pid'] == null,
                replacement: Card(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                    child: ListTile(
                      title: const Text("Document :"),
                      subtitle: Text(teachData['document']['name'] ?? "Aucun document."),
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

              // --- Autiod :
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                child: Text('Audio'),
              ),
              Visibility(
                visible: teachData['audio'] != null,
                replacement: CAudioRecoderWidget(onFinish: updateAudio).animate(effects: CTransitionsTheme.model_1),
                child: Column(children: [
                  CAudioReaderWidget(audioSource: CDocumentHandlerClass.byPid(teachData['audio'] ?? '---')),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    TextButton.icon(
                      icon: const Icon(CupertinoIcons.refresh),
                      style: const ButtonStyle(visualDensity: VisualDensity.compact),
                      onPressed: isInPushingMode
                          ? null
                          : () {
                              CSAudioPalyer.inst.source = CDocumentHandlerClass.byPid(teachData['audio'] ?? '---');
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
  void loadingTeach() async {
    setState(() {
      isInLoadingData = true;
      isInPushingMode = true;
    });

    CApi.request.get('/teaching/quest/edit.get.teach.za40Hx5A0r1UbT0pZs', data: {'teach_id': widget.teachId}).then(
      (res) {
        if (res.data is Map && res.data['success']) {
          prettyPrintJson(res.data);
          setState(() {
            commentsCounts = res.data['comments'] ?? 0;
            teachData = res.data['teach'];

            isInLoadingData = false;
            isInPushingMode = false;

            draftInstance.free();

            if (teachData['date'] != null) {
              var date = DateTime.parse(teachData['date']);

              textEditingControllerDate.text = "${date.day}/${date.month}/${date.year}";
            }

            textEditingControllerTitle.text = teachData['title'] ?? '';
            textEditingControllerCom.text = teachData['text'] ?? '';
            textEditingControllerPredicator.text = teachData['predicator'] ?? '';
            textEditingControllerVerse.text = teachData['verse'] ?? '';
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

    if (echoTextFieldKkey.currentState!.validate() == false) {
      return false;
    }

    if (dateVerseTextFieldKey.currentState!.validate() == false) {
      return false;
    }

    // if (predicatorTextFieldKey.currentState!.validate() == false) {
    //   return false;
    // }

    return true;
  }

  void updateText() {
    if (requiredDataValidator()) {
      setState(() => isInPushingMode = true);

      Map data = {
        'teach_id': widget.teachId,
        'title': textEditingControllerTitle.text,
        'text': textEditingControllerCom.text,
        'date': textEditingControllerDate.text,
        'verse': textEditingControllerVerse.text,
        'predicator': textEditingControllerPredicator.text,
      };

      String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      CApi.request.post('/teaching/quest/edit.update.text.emG2li4U0tQUzZLukA', data: data).then(
        (res) {
          prettyPrintJson(res.data);
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

  void removePicture() {
    if (teachData['picture'] != null) {
      setState(() => isInPushingMode = true);

      const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      Map data = {'pid': teachData['picture']};

      CApi.request.delete('/teaching/quest/edit.remove.picture.HU1vcOhjCDK4jtRORc', data: data).then(
        (res) {
          setState(() => isInPushingMode = false);
          if (res.data is Map && res.data['success']) {
            setState(() => teachData['picture'] = null);

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
      const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      setState(() => isInPushingMode = true);

      var data = FormData.fromMap({
        'teach_id': widget.teachId,
        'picture': MultipartFile.fromFileSync(filePath),
      });

      CApi.request.post('/teaching/quest/edit.upload.picture.47XzYr5UnSQsx2hMPg', data: data).then(
        (res) {
          setState(() => isInPushingMode = false);

          if (res.data is Map && res.data['success']) {
            setState(() => teachData['picture'] = res.data['pid']);

            CSnackbarWidget.direct(const Text('Mises à jour avec succès.'), defaultDuration: true);
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

    Map data = {'pid': teachData['document']['pid'] ?? '---'};

    const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.delete('/teaching/quest/edit.remove.document.Ycnr98PntxRv9B3G0l', data: data).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['success']) {
          setState(() => teachData['document'] = {'name': null, 'pid': null});

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
      'teach_id': widget.teachId,
      'document': MultipartFile.fromFileSync(documentPath ?? '---'),
    });

    String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.post('/teaching/quest/edit.update.document.lTCdWLZ9nb58DoIXUM', data: param).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['state'] == 'UPDATED') {
          setState(() {
            teachData['document']['pid'] = res.data['pid'];
            teachData['document']['name'] = "Document mises à jour";
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

  void showPost() {
    context.pushNamed(ReadTeachingScreen.routeName, extra: {'teach_id': widget.teachId});
  }

  void openCommentsMan() {
    if (teachData['audio'] != null) CSAudioPalyer.inst.dispose();

    context.pushNamed(ReadTeachingScreen.routeName, extra: {'section_name': 'TEACH', 'id': widget.teachId, 'admin': true});
  }

  void updateAudio(String? audioPath) {
    setState(() => isInPushingMode = true);

    if (audioPath != null) {
      var param = FormData.fromMap({
        'teach_id': widget.teachId,
        'audio': MultipartFile.fromFileSync(audioPath),
      });

      String failedMessage = "La mises à jour a échou. Réessaye plus tard. "
          "Vérifier la taille du fichier, qui doit être inférieur à 9Mo";

      CApi.request.post('/teaching/quest/edit.update.audio.Izum4tK9O4lhIrpgd8', data: param).then(
        (res) {
          setState(() => isInPushingMode = false);

          if (res.data is Map && res.data['success']) {
            setState(() => teachData['audio'] = res.data['pid']);

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

    Map data = {'pid': teachData['audio'] ?? '---'};

    const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.delete('/teaching/quest/edit.remove.audio.04NveuJzo0HQxx29tZ', data: data).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['success']) {
          setState(() => teachData['audio'] = null);

          CSnackbarWidget.direct(const Text('Audio supprimé avec succès.'), defaultDuration: true);
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
