import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/services/c_s_draft.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/comm/read_comm_screen.dart';
import 'package:cfc_christ/views/screens/user/user_comments_admin.dart';
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
import 'package:markdown_toolbar/markdown_toolbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class EditCommScreen extends StatefulWidget {
  static const String routeName = 'com.editor';
  static const String routePath = 'com/editor';

  const EditCommScreen({super.key, required this.comId});

  final String? comId;

  @override
  State<EditCommScreen> createState() => _EditCommScreenState();
}

class _EditCommScreenState extends State<EditCommScreen> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  CSDraft draftInstance = CSDraft("7bQYZyfH2FUSVpPF5C");

  Map<String, dynamic>? userData = UserMv.data;

  bool isInLoadingData = true;

  bool isInPushingMode = false;

  TextEditingController textEditingControllerTitle = TextEditingController();
  TextEditingController textEditingControllerCom = TextEditingController();
  var titleTextFieldKey = GlobalKey<FormState>();
  var comTextFieldKkey = GlobalKey<FormState>();

  final _focusNodeEditCom = FocusNode();

  String? selectHeadPicture;
  String? attachedDocument;

  bool comStatus = false;

  // Loaded datas : --> -----------------|
  Map? comData; // Com datas.
  int commentsCounts = 0;

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void initState() {
    textEditingControllerTitle.text = draftInstance.data('title') ?? '';
    textEditingControllerCom.text = draftInstance.data('teaching') ?? '';

    super.initState();

    loadingCom();
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
              Text('Communiqué'),
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
                    visible: comData?['picture'] != null,
                    child: Animate(
                      effects: [FadeEffect(duration: 1.seconds)],
                      child: GestureAnimator(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: CConstants.GOLDEN_SIZE * 27),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                            child: Image.network(CImageHandlerClass.byPid(comData?['picture'] ?? '---')),
                          ),
                        ),
                        onTap: () => CImageHandlerClass.show(context, [comData?['picture']]),
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
                        onPressed: (isInPushingMode || comData?['picture'] == null) ? null : removePicture,
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
                  child: Column(
                    children: [
                      // --> Status :
                      Padding(
                        padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                        child: DropdownButtonHideUnderline(
                          child: DropdownMenu(
                            label: const Text('Statut'),
                            enabled: !isInPushingMode,
                            initialSelection: comData?['status'] ?? 'NONE',
                            onSelected: (value) => setState(() => comData?['status'] = value),
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(value: 'NONE', label: "Rien de Prévu dans ce communiqué"),
                              DropdownMenuEntry(value: 'REALIZED', label: "Cette information est déjà réalisé"),
                              DropdownMenuEntry(value: 'INWAIT', label: "Cette information est Prévu"),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
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
                              // border: InputBorder.none,
                              prefixIcon: Icon(CupertinoIcons.bookmark_fill),
                            ),
                          ),
                        ),
                      ),

                      // --- Text body :
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                        child: Form(
                          key: comTextFieldKkey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: textEditingControllerCom,
                            focusNode: _focusNodeEditCom,
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

                      MarkdownToolbar(
                        useIncludedTextField: false,
                        controller: textEditingControllerCom,
                        focusNode: _focusNodeEditCom,
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
                    ],
                  ),
                ),
              ),

              // --- Attache FIle :
              Padding(
                padding: const EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                child: Visibility(
                  visible: comData?['document']['pid'] == null,
                  replacement: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
                      child: ListTile(
                        title: const Text("Document :"),
                        subtitle: Text(comData?['document']['name'] ?? "Aucun document."),
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
              ),
            ],
          ).animate(effects: CTransitionsTheme.model_1);
        }),
      ),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  void loadingCom() async {
    setState(() {
      isInLoadingData = true;
      isInPushingMode = true;
    });

    CApi.request.get('/com/quest/edit.get.KRT7TBTvs5yGP2rUsy', data: {'com_id': widget.comId}).then(
      (res) {
        if (res.data is Map && res.data['state'] == 'GETTED') {
          setState(() {
            commentsCounts = res.data['comments'] ?? 0;
            comData = res.data['com'];

            isInLoadingData = false;
            isInPushingMode = false;

            draftInstance.free();

            textEditingControllerTitle.text = comData?['title'] ?? '';
            textEditingControllerCom.text = comData?['text'] ?? '';
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
        'com_id': widget.comId,
        'status': comData?['status'] ?? 'NONE',
        'title': textEditingControllerTitle.text,
        'text': textEditingControllerCom.text,
      };

      String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      CApi.request.post('/com/quest/com.update.text.628L7cLg1RGTvaxkgg', data: data).then(
        (res) {
          if (res.data['state'] == 'UPDATED') {
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
    if (comData?['picture'] != null) {
      setState(() => isInPushingMode = true);

      const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      Map data = {'pid': comData?['picture']};

      CApi.request.delete('/com/quest/com.edit.relete.picture.0q69A65BL0f6LRRDDz', data: data).then(
        (res) {
          setState(() => isInPushingMode = false);
          if (res.data is Map && res.data['success']) {
            setState(() => comData?['picture'] = null);

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
  }

  void updatePicture(String? filePath) {
    if (filePath != null) {
      const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

      setState(() => isInPushingMode = true);

      var data = FormData.fromMap({
        'com_id': widget.comId,
        'picture': MultipartFile.fromFileSync(filePath),
      });

      CApi.request.post('/com/quest/com.edit.update.picture.uCJPfanAYmhvQesGEG', data: data).then(
        (res) {
          setState(() => isInPushingMode = false);

          if (res.data is Map && res.data['success']) {
            setState(() => comData?['picture'] = res.data['pid']);

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

    Map data = {'pid': comData?['document']['pid'] ?? '---'};

    const String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.delete('/com/quest/com.edit.delete.doc.6LUlI6O4yAnKXI2M1J', data: data).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['success']) {
          setState(() => comData?['document'] = {'name': null, 'pid': null});

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
      'com_id': widget.comId,
      'document': MultipartFile.fromFileSync(documentPath ?? '---'),
    });

    String failedMessage = "La mises à jour a échou. Réessaye plus tard.";

    CApi.request.post('/com/quest/com.edit.update.doc.1q2IIeqday1xSwRHZl', data: param).then(
      (res) {
        setState(() => isInPushingMode = false);

        if (res.data is Map && res.data['state'] == 'UPDATED') {
          setState(() {
            comData?['document']['pid'] = res.data['pid'];
            comData?['document']['name'] = "Document mises à jour";
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
    context.pushNamed(ReadCommScreen.routeName, extra: {'com_id': widget.comId});
  }

  void openCommentsMan() {
    context.pushNamed(UserCommentsAdminScreen.routeName, extra: {'section_name': 'COM', 'id': widget.comId, 'admin': true});
  }
}
