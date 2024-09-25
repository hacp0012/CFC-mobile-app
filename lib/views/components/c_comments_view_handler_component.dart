import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/classes/c_sections_types_enum.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/views/screens/user/user_profile_details_screen.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pretty_print_json/pretty_print_json.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class CCommentsViewHandlerComponent extends StatefulWidget {
  const CCommentsViewHandlerComponent({
    super.key,
    required this.section,
    required this.id,
    this.ownerId,
    this.administrator = false,
  });

  final CSectionsTypesEnum section;
  final String id;
  final String? ownerId;
  final bool administrator;

  @override
  State<CCommentsViewHandlerComponent> createState() => _CCommentsViewHandlerComponentState();
}

class _CCommentsViewHandlerComponentState extends State<CCommentsViewHandlerComponent> {
  // DATAS ------------------------------------------------------------------------------------------------------------------:
  Map? userData = UserMv.data;

  bool isInLoading = true;
  bool isInPushing = true;

  TextEditingController mainTextFieldController = TextEditingController();
  TextEditingController editTextFieldController = TextEditingController();

  var mainTextFieldKey = GlobalKey<FormState>();
  var editTextFieldKey = GlobalKey<FormState>();
  var mainFocusNode = FocusNode();

  List commentsList = [];

  // INITIALIZER ------------------------------------------------------------------------------------------------------------:
  @override
  void initState() {
    super.initState();

    load();
  }

  // VIEW -------------------------------------------------------------------------------------------------------------------:
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: CConstants.GOLDEN_SIZE * 1),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: Form(
            key: mainTextFieldKey,
            child: TextFormField(
              controller: mainTextFieldController,
              textCapitalization: TextCapitalization.sentences,
              validator: CFormValidator([CFormValidator.min(3, message: "Min 3 caractères")]).validate,
              decoration: const InputDecoration().copyWith(hintText: "Laissez votre commentaire ici ..."),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              focusNode: mainFocusNode,
              onTapOutside: (event) => mainFocusNode.unfocus(),
            ),
          ),
        ),
        const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
        TextButton(onPressed: isInPushing ? null : () => post(null), child: Text(isInPushing ? '...' : 'POSTER')),
      ]),

      // --> Contents :
      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
      Builder(
        builder: (context) {
          if (isInLoading) {
            return Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surface,
              highlightColor: Theme.of(context).colorScheme.primary,
              child: const Text("Chargement des commantaires..."),
            );
          } else if (commentsList.isEmpty) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 9.0),
              child: Text(
                "Aucun commentaire disponible",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            );
          }

          return Column(
            children: List<Widget>.generate(commentsList.length, (int index) {
              var comment = commentsList[index];

              return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Column(
                  children: [
                    const SizedBox(height: CConstants.GOLDEN_SIZE * 1.5),
                    GestureAnimator(
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.userById(comment['poster']['id'])),
                        radius: CConstants.GOLDEN_SIZE * 2,
                      ),
                      onTap: () => context.pushNamed(
                        UserProfileDetailsScreen.routeName,
                        extra: {'user_id': comment['poster']['id']},
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: CConstants.GOLDEN_SIZE / 2),
                Expanded(
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(comment['poster']['fullname'])),
                            Text(
                              CMiscClass.date(DateTime.parse(comment['comment']['created_at'])).ago(),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ]),
                          SelectableText(
                            comment['comment']['comment'],
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: CMiscClass.whenBrightnessOf(context, light: Colors.grey.shade700),
                                ),
                          ),
                          Row(children: [
                            TextButton.icon(
                              style: const ButtonStyle(
                                visualDensity: VisualDensity.compact,
                                alignment: Alignment.centerLeft,
                              ),
                              onPressed: isInPushing ? null : () => likeThis(index),
                              icon: const Icon(CupertinoIcons.heart, size: CConstants.GOLDEN_SIZE * 2),
                              label: Text(CMiscClass.numberAbrev((commentsList[index]['likes'] as int).toDouble())),
                            ),
                            const Spacer(),
                            const TextButton(
                              style: ButtonStyle(visualDensity: VisualDensity.compact),
                              onPressed: null,
                              child: Text('Répondre'),
                            ),
                            if (comment['poster']['is_owner'] || widget.administrator)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: isInPushing ? null : () => remove(comment['comment']['id']),
                                icon: const Icon(CupertinoIcons.trash, size: CConstants.GOLDEN_SIZE * 2),
                              ),
                            if (comment['poster']['is_owner'] || widget.administrator)
                              IconButton(
                                style: const ButtonStyle(visualDensity: VisualDensity.compact),
                                onPressed: isInPushing
                                    ? null
                                    : () => opnEditBottomSheet(comment['comment']['id'], comment['comment']['comment']),
                                icon: const Icon(CupertinoIcons.pencil_ellipsis_rectangle),
                              ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }),
          );
        },
      )
    ]);
  }

  // METHODS ----------------------------------------------------------------------------------------------------------------:
  String? _provideGoodSection() {
    String? model;

    if (widget.section == CSectionsTypesEnum.teaching) {
      model = 'TEACHING';
    } else if (widget.section == CSectionsTypesEnum.echo) {
      model = 'ECHO';
    } else if (widget.section == CSectionsTypesEnum.com) {
      model = 'COM';
    }

    return model;
  }

  load() {
    setState(() {
      // isInLoading = true;
      isInPushing = true;
    });

    Map data = {
      'model': _provideGoodSection(),
      'model_id': widget.id,
    };

    CApi.request.get('/comment/handler/get.EoJkzyMftwPf72SCUuNxv8IMiinUL9rKIOTi', data: data).then(
      (res) {
        prettyPrintJson(res.data);
        setState(() {
          isInPushing = false;
          isInLoading = false;
        });

        if (res.data is Map && res.data['success']) {
          setState(() => commentsList = res.data['comments']);
        }
      },
      onError: (err) {
        prettyPrintJson(err);
        setState(() {
          isInPushing = false;
          isInLoading = false;
        });
      },
    );
  }

  void post(String? parent) {
    if (mainTextFieldKey.currentState?.validate() == true && mainTextFieldController.text.isNotEmpty) {
      setState(() => isInPushing = true);

      const String errorMessage = "La publication a échoué. Ressayer plus tard.";

      Map data = {
        'model': _provideGoodSection(),
        'model_id': widget.id,
        'comment': mainTextFieldController.text,
        'parent': parent,
      };

      CApi.request.post('/comment/handler/add.DQrta4poHvDfJEeyX2VQ27IW1H1', data: data).then(
        (res) {
          prettyPrintJson(res.data);
          setState(() => isInPushing = false);

          if (res.data is Map && res.data['success']) {
            mainTextFieldController.text = '';

            load();

            CSnackbarWidget.direct(const Text('Publié avec succès.'), defaultDuration: true);
          } else {
            CSnackbarWidget.direct(const Text(errorMessage), defaultDuration: true);
          }
        },
        onError: (err) {
          prettyPrintJson(err);
          setState(() => isInPushing = false);

          CSnackbarWidget.direct(const Text(errorMessage), defaultDuration: true);
        },
      );
    }
  }

  // OWNLER --> -------------------------------- :
  edit(String commentId) {
    if (editTextFieldKey.currentState?.validate() == true) {
      setState(() => isInPushing = true);

      const String errorMessage = "La modification a échoué. Ressayer plus tard.";

      Map data = {
        'comment_id': commentId,
        'comment': editTextFieldController.text,
      };

      CApi.request.post('/comment/handler/edit.yRR26S9K4haLzej0rZLLlBwqj1M', data: data).then(
        (res) {
          setState(() => isInPushing = false);

          if (res.data is Map && res.data['success']) {
            load();

            editTextFieldController.text = '';
            CSnackbarWidget.direct(const Text('Modifié avec succès.'), defaultDuration: true);
          } else {
            CSnackbarWidget.direct(const Text(errorMessage), defaultDuration: true);
          }
        },
        onError: (err) {
          setState(() => isInPushing = false);

          CSnackbarWidget.direct(const Text(errorMessage), defaultDuration: true);
        },
      );
    }
  }

  opnEditBottomSheet(String commentId, String comment) {
    editTextFieldController.text = comment;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('Modification du commentaire'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE * 2),
                  child: Form(
                    key: editTextFieldKey,
                    child: TextFormField(
                      controller: editTextFieldController,
                      textCapitalization: TextCapitalization.sentences,
                      validator: CFormValidator([CFormValidator.min(3, message: 'Min 3 caractères')]).validate,
                      decoration: const InputDecoration().copyWith(
                        hintText: "Modifier votre commentaire ici ...",
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text("Annuler"),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (editTextFieldKey.currentState?.validate() == true) {
                        edit(commentId);

                        context.pop();
                      }
                    },
                    child: const Text("Enregistrer"),
                  ),
                ]),
              ]),
            );
          },
        );
      },
    );
  }

  likeThis(int index) {
    setState(() => isInPushing = true);

    var comment = commentsList[index];

    Map data = {
      'commentId': comment['comment']['id'],
      'reactorId': comment['poster']['id'],
    };

    CApi.request.post('/comment/handler/like.reaction.gfsUuXfSdNUDdUruwSGDjbm2xQf', data: data).then((res) {
      setState(() => isInPushing = false);

      if (res.data is Map && res.data['success']) {
        commentsList[index]['likes'] = res.data['count'];
      }
    }).catchError((err) {
      setState(() => isInPushing = false);
    });
  }

  // ADMIN --> --------------------------------- :
  remove(String commentId) {
    setState(() => isInPushing = true);

    const String errorMessage = "La suppression a échoué. Ressayer plus tard.";

    Map data = {
      'model': _provideGoodSection(),
      'model_id': widget.id,
      'comment_id': commentId,
    };

    CApi.request.delete('/comment/handler/remove.oua2TPqGoWhF8zkAjFrhPgT8dVG', data: data).then(
      (res) {
        setState(() => isInPushing = false);

        if (res.data is Map && res.data['success']) {
          load();

          CSnackbarWidget.direct(const Text('Supprimé avec succès.'), defaultDuration: true);
        } else {
          CSnackbarWidget.direct(const Text(errorMessage), defaultDuration: true);
        }
      },
      onError: (err) {
        setState(() => isInPushing = false);

        CSnackbarWidget.direct(const Text(errorMessage), defaultDuration: true);
      },
    );
  }
}
