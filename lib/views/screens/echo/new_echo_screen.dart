import 'dart:async';
import 'dart:io';

import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/model_view/main/echo_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/services/c_s_draft.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/widgets/c_audio_recoder_widget.dart';
import 'package:cfc_christ/views/widgets/c_document_select_file_widget.dart';
import 'package:cfc_christ/views/widgets/c_image_cropper.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class NewEchoScreen extends StatefulWidget {
  static const String routeName = 'echo.new';
  static const String routePath = 'new';

  const NewEchoScreen({super.key});

  @override
  State<NewEchoScreen> createState() => _NewEchoScreenState();
}

class _NewEchoScreenState extends State<NewEchoScreen> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  CSDraft draftInstance = CSDraft("OjOs2zlPXXCitDv3dw");

  Map<String, dynamic>? userData = UserMv.data;

  bool isInPushingMode = false;

  TextEditingController textEditingControllerTitle = TextEditingController();
  TextEditingController textEditingControllerTeaching = TextEditingController();
  var titleTextFieldKey = GlobalKey<FormState>();
  var teachingTextFieldKey = GlobalKey<FormState>();

  List<Map<String, String>> selectedPictures = [];
  String? attachedDocument;
  String? audioFilePath;
  int pictureUploadCount = 0;
  int failedOnUploadingPictures = 0;

  Map publishModeStates = {'text': null, 'picture': null, 'document': null, 'audio': null, 'finishing': null};

  PageController pageController = PageController(initialPage: 0);

  // INITIALIZERS ----------------------------------------------------------------------------------------------------------->
  @override
  void initState() {
    textEditingControllerTitle.text = draftInstance.data('title') ?? '';
    textEditingControllerTeaching.text = draftInstance.data('teaching') ?? '';

    super.initState();
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nouvelle écho'),
          actions: [
            TextButton.icon(
              onPressed: isInPushingMode ? null : startPublishing,
              icon: const Icon(CupertinoIcons.paperplane, size: CConstants.GOLDEN_SIZE * 2),
              label: const Text("Publier"),
            ),
          ],
        ),

        // --- Body :
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // --- MAIN VIEW --- :
            ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
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
                        hintText: "Entrer le titre de l'écho",
                        labelText: "Titre de l'écho",
                        border: InputBorder.none,
                        prefixIcon: Icon(CupertinoIcons.bookmark_fill),
                      ),
                    ),
                  ),
                ),
              ),

              // --- Pictures :
              Column(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(
                  selectedPictures.length,
                  (index) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Flexible(
                      child: ActionChip(
                        label: Text(selectedPictures[index]['name'] ?? 'Sans nom'),
                        avatar: const Icon(CupertinoIcons.photo),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                        onPressed: () => openImageViewer(index),
                      ),
                    ),
                    IconButton(onPressed: () => removePictureInList(index), icon: const Icon(CupertinoIcons.xmark)),
                  ]),
                ),
              ),

              // --- Add picture :
              Row(children: [
                FilledButton.tonalIcon(
                  onPressed: headPictureSelectorAndCropper,
                  label: const Text("Ajouter une photo"),
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  icon: const Icon(CupertinoIcons.photo),
                ),
              ]),

              // --- Attache FIle :
              CDocumentSelectFileWidget(onSelect: (filePath) => setState(() => attachedDocument = filePath)),

              // --- Text body :
              Padding(
                padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS / 2)),
                  child: Form(
                    key: teachingTextFieldKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: textEditingControllerTeaching,
                      validator: CFormValidator([
                        CFormValidator.required(
                          message: "Un tout petit texte descriptif de votre écho est nécessaire.",
                        ),
                        CFormValidator.min(9),
                      ]).validate,
                      onChanged: (value) => draftInstance.keep('teaching', value),
                      decoration: const InputDecoration(
                        labelText: "Enseignement en texte (obligatoire)",
                        hintText: "Écrivez le cours de vôtre publication ici ... Juste quelques lignes ou plus",
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                child:
                    CTtsReaderWidget(text: () => textEditingControllerTeaching.text, buttonText: "Ecouter les textes écrit"),
              ),

              // --- Simple reccorder text indicator.
              Padding(
                padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                child: Text(
                  "Enregistrer un enseignant audio ou envoyer un document audio pré-enregistrés",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),

              // --- Audio reccorder :
              SizedBox(child: CAudioRecoderWidget(onFinish: (String? path) => setState(() => audioFilePath = path))),

              const SizedBox(height: CConstants.GOLDEN_SIZE * 7),
            ]),

            // --- POST --- :
            Builder(builder: (context) {
              Map<dynamic, Widget> stateIcons = {
                null: const Icon(CupertinoIcons.minus),
                false: const SizedBox(
                  height: CConstants.GOLDEN_SIZE * 2,
                  width: CConstants.GOLDEN_SIZE * 2,
                  child: CircularProgressIndicator(strokeCap: StrokeCap.round),
                ),
                true: const Icon(CupertinoIcons.checkmark_alt, color: Colors.green),
              };

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: CConstants.MAX_CONTAINER_WIDTH - 63),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    WidgetAnimator(
                      atRestEffect: WidgetRestingEffects.bounce(),
                      child: Icon(
                        Icons.upload,
                        size: CConstants.GOLDEN_SIZE * 9,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                    Text("En cour de publication", style: Theme.of(context).textTheme.titleMedium),

                    // --
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                    Row(children: [
                      stateIcons[publishModeStates['text']] ?? const Text("--"),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      const Text("Creation de la publication"),
                    ]),

                    // --
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      stateIcons[publishModeStates['picture']] ?? const Text("--"),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      Text(
                        "Téléversement des images ($pictureUploadCount / ${selectedPictures.length}) - $failedOnUploadingPictures",
                      ),
                    ]),

                    // --
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      stateIcons[publishModeStates['document']] ?? const Text("--"),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      const Text("Téléversement du document attaché"),
                    ]),

                    // --
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      stateIcons[publishModeStates['audio']] ?? const Text("--"),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      const Text("Téléversement du fichier audio"),
                    ]),

                    // --
                    const SizedBox(height: CConstants.GOLDEN_SIZE),
                    Row(children: [
                      stateIcons[publishModeStates['finishing']] ?? const Text("--"),
                      const SizedBox(width: CConstants.GOLDEN_SIZE),
                      const Text("Finalisation"),
                    ]),
                  ]),
                ),
              ).animate(effects: CTransitionsTheme.model_1);
            }),
          ],
        ),
      ),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  void pageMan(bool isInPushingMode) {
    if (isInPushingMode) {
      setState(() {
        isInPushingMode = false;
        pageController.animateToPage(1, duration: 801.ms, curve: Curves.ease);
      });
    } else {
      setState(() {
        isInPushingMode = true;
        pageController.animateToPage(0, duration: 801.ms, curve: Curves.ease);
      });
    }
  }

  void headPictureSelectorAndCropper() async {
    FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(type: FileType.image);

    if (filePickerResult != null) {
      var file = filePickerResult.xFiles.first;
      CImageCropper(
        path: file.path,
        titleText: "Photo d'entête",
        gridMode: CropAspectRatioPreset.original,
        onCropped: (tempPath) {
          if (tempPath != null) setState(() => selectedPictures.add({'path': tempPath, 'name': file.name}));
        },
      );
    }
  }

  void removePictureInList(int index) => setState(() {
        File(selectedPictures[index]['path'] ?? '').delete();

        selectedPictures.removeAt(index);
      });

  void openImageViewer(int index) {
    CImageHandlerClass.show(
      context,
      selectedPictures.map<String>((e) => e['path'] ?? '').toList(),
      startAt: index,
      userFile: true,
    );
  }

  bool requiredDataValidator() {
    if (titleTextFieldKey.currentState!.validate() == false) {
      return false;
    }

    if (teachingTextFieldKey.currentState!.validate() == false) {
      return false;
    }

    return true;
  }

  startPublishing() async {
    if (requiredDataValidator()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Commencer la publication de cette écho ? "
              '\n\n'
              "La visibilité de cette écho sera à la portée défini par votre "
              "responsabilité sur le niveau du pool, de la communauté locale ou "
              "du noyau d'affermissement dont vous avez un rôle.",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            icon: const CircleAvatar(
              radius: CConstants.GOLDEN_SIZE * 2,
              backgroundImage: AssetImage(Env.APP_ICON_ASSET),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(onPressed: () => context.pop(), child: const Text("Non")),
              TextButton(
                onPressed: () {
                  context.pop();
                  _publish();
                },
                child: const Text("Oui commencer"),
              ),
            ],
          ).animate(effects: CTransitionsTheme.model_1);
        },
      );
    }
  }

  _publish() {
    pageMan(true);

    // Start :
    _pubText();
  }

  _pubText() {
    setState(() => publishModeStates['text'] = false); // loading circle.

    EchoMv().post(
      textEditingControllerTitle.text,
      textEditingControllerTeaching.text,
      (id) {
        publishModeStates['text'] = true;

        _pubPicture(id);
      },
      () {
        CSnackbarWidget.direct(
          const Text("La publication n'a pas était possible, vérifie l'état de votre connexion internet."),
          defaultDuration: true,
        );

        setState(() {
          pageMan(false);
          publishModeStates['text'] = null;
        });

        // _pubPicture(null);
      },
    );
  }

  _pubPicture(String? id) {
    setState(() => publishModeStates['picture'] = false);

    for (Map<String, String> picture in selectedPictures) {
      EchoMv().postPicture(
        id ?? '---',
        picture['path'] ?? '---',
        () {
          setState(() => pictureUploadCount += 1);

          if (picture['path'] != null) File(picture['path'] ?? '---').delete();
        },
        () => setState(() => failedOnUploadingPictures += 1),
      );
    }
    publishModeStates['picture'] = true;

    _pubDoc(id);
  }

  _pubDoc(String? id) {
    setState(() => publishModeStates['document'] = false);

    if (attachedDocument != null) {
      EchoMv().sendDocument(id ?? '---', attachedDocument ?? '---', () {
        publishModeStates['document'] = true;

        _pubAudio(id);
      });
    } else {
      publishModeStates['document'] = true;

      _pubAudio(id);
    }
  }

  _pubAudio(String? id) {
    setState(() => publishModeStates['audio'] = false);

    if (audioFilePath != null) {
      EchoMv().sendAudio(id ?? '---', audioFilePath ?? '---', () {
        setState(() => publishModeStates['audio'] = true);

        _finishing(id);
      });
    } else {
      setState(() => publishModeStates['audio'] = true);

      _finishing(id);
    }
  }

  _finishing(String? id) {
    setState(() => publishModeStates['finishing'] = false);

    Timer(const Duration(seconds: 3), () => setState(() => publishModeStates['finishing'] = true));

    Timer(const Duration(seconds: 5), () {
      draftInstance.free();

      CSnackbarWidget.direct(
        const Text(
          "L'enseignement a été publié.\nVous pouvez le retrouver dans vôtre liste des publications.",
        ),
        defaultDuration: false,
        backgroundColor: Colors.green,
      );

      context.pop();
    });
  }
}
