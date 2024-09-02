import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cfc_christ/classes/c_form_validator.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/components/c_find_couple_component.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/user/user_profile_details_screen.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class UserFamilyCoupleScreen extends StatefulWidget {
  static const String routeName = 'family.couple';
  static const String routePath = 'my/couple';

  const UserFamilyCoupleScreen({super.key});

  @override
  State<UserFamilyCoupleScreen> createState() => _UserFamilyCoupleScreenState();
}

class _UserFamilyCoupleScreenState extends State<UserFamilyCoupleScreen> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  Map<String, dynamic>? userData = UserMv.data;
  Map? coupleData;
  Map? rightHand;
  List childrenData = [];
  Map<String, bool> loadingState = {'couple': true, 'children': true, 'couple_update': false};

  Map? selectCouple;

  bool hasPartner = true;
  bool hasPartnerRequest = false;
  String newCoupleName = '';

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  _s(fn) => super.setState(fn);

  @override
  void initState() {
    super.initState();

    downloadCoupleData();
    downloadChildrenData();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    var hand = coupleData?[userData?['civility'] == 'F' ? 'epouse' : 'epoue'];

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mon couple'),
          actions: const [IconButton(onPressed: null, icon: Icon(CupertinoIcons.trash))],
        ),

        // --- Body :
        body: Builder(builder: (context) {
          if (hasPartner == false && hasPartnerRequest == true) {
            return ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Card.filled(
                child: Column(children: [
                  const SizedBox(height: CConstants.GOLDEN_SIZE),
                  const Icon(CupertinoIcons.clock, size: CConstants.GOLDEN_SIZE * 5),
                  Padding(
                    padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: StyledText(
                      text: "Vous aviez envoyé une demande d'approbation à une personne que "
                          "vous aviez désigné comme étant votre partenaire et cette demande est attente.",
                      tags: CStyledTextTags().tags,
                    ),
                  ),
                ]),
              ).animate(effects: CTransitionsTheme.model_1),
              const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
              Text(
                "Si vous remarques que quelques choses n'est pas "
                "correct, vous pouvez contacter un responsable.",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => context.pushNamed(ContactusScreen.routeName),
                child: const Text("Contacter un responsable"),
              )
            ]);
          } else if (hasPartner == false) {
            return ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
              const Padding(
                padding: EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 5),
                child: Icon(CupertinoIcons.exclamationmark_octagon, size: CConstants.GOLDEN_SIZE * 7),
              ),
              Text("Vous n'avez pas de couple", textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              StyledText(
                text: "Inscriviez le nom de vôtre couple puis appuyez sur Cré le couple pour créer votre couple.",
                tags: CStyledTextTags().tags,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              TextField(
                onChanged: (value) => newCoupleName = value,
                decoration: const InputDecoration(
                  hintText: "Entrer le nom du couple que vous voulez créer",
                  labelText: "Nom du couple",
                ),
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              SizedBox(
                width: CConstants.GOLDEN_SIZE * 10,
                height: CConstants.GOLDEN_SIZE * 5,
                child: FittedBox(
                  child: FilledButton.tonalIcon(onPressed: () => sendCreateNewCouple(), label: const Text("Créer le couple")),
                ),
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
              Text(
                "Ou vous pouvez sélectionner un couple depuis le bouton suivant.",
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                FilledButton.tonalIcon(
                  onPressed: () => openCoupleFitchModal(),
                  label: const Text("Sélectionner un couple"),
                ),
                if (selectCouple != null)
                  IconButton.filled(
                    onPressed: () => _openSubmissionOfJoinCouple(),
                    icon: const Icon(CupertinoIcons.paperplane),
                  ),
              ]),
            ]).animate(effects: CTransitionsTheme.model_1);
          }

          return ListView(children: [
            Padding(
              padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                // LEFT PARTNER.
                WidgetAnimator(
                  incomingEffect:
                      WidgetTransitionEffects.incomingSlideInFromLeft(duration: const Duration(milliseconds: 500)),
                  child: Column(children: [
                    CachedNetworkImage(
                      imageUrl: CImageHandlerClass.byPid(userData?['photo']),
                      cacheManager: DioCacheManager.instance,
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: CConstants.GOLDEN_SIZE * 5,
                          backgroundImage: imageProvider,
                        );
                      },
                    ),
                    Text(userData?['name'] ?? ''),
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
                  child: Icon(CupertinoIcons.link),
                ),

                // RIGHT PARTNER.
                Column(children: [
                  Builder(builder: (context) {
                    if (hand == null) {
                      return const CircleAvatar(
                        radius: CConstants.GOLDEN_SIZE * 5,
                        child: Icon(CupertinoIcons.person_crop_circle_fill_badge_checkmark, size: 9 * 4),
                      );
                    } else {
                      return CachedNetworkImage(
                        imageUrl: CImageHandlerClass.byPid(rightHand?['photo']),
                        cacheManager: DioCacheManager.instance,
                        imageBuilder: (context, imageProvider) => GestureAnimator(
                          child: CircleAvatar(
                            radius: CConstants.GOLDEN_SIZE * 5,
                            backgroundImage: imageProvider,
                          ),
                          onTap: () => context.pushNamed(
                            UserProfileDetailsScreen.routeName,
                            extra: {'user_id': rightHand?['id']},
                          ),
                        ),
                      );
                    }
                  }),
                  Text(hand == null ? "En attente..." : rightHand?['name'] ?? '---'),
                ]).animate(effects: CTransitionsTheme.model_1),
              ]),
            ),
            Text("Le couple : ${coupleData?['nom'] ?? '...'}", textAlign: TextAlign.center),

            // --- Infos :
            Builder(builder: (context) {
              if (loadingState['couple'] ?? false) {
                return const Padding(
                  padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: CardLoading(
                    height: CConstants.GOLDEN_SIZE * 8,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                );
              } else {
                DateTime? coupleDate =
                    coupleData?['d_mariage'] == null ? null : DateTime.parse(coupleData?['d_mariage'] ?? '');

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE * 2, horizontal: CConstants.GOLDEN_SIZE),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: CConstants.GOLDEN_SIZE,
                      right: CConstants.GOLDEN_SIZE,
                      bottom: CConstants.GOLDEN_SIZE,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(coupleData?['nom'] ?? "---", style: Theme.of(context).textTheme.titleMedium, maxLines: 2),
                        const Spacer(),
                        Visibility(
                          visible: loadingState['couple_update'] == false,
                          replacement: const SizedBox(
                            height: CConstants.GOLDEN_SIZE * 2,
                            width: CConstants.GOLDEN_SIZE * 2,
                            child: CircularProgressIndicator(strokeCap: StrokeCap.round),
                          ),
                          child: IconButton(
                            onPressed: openUpdateCouple,
                            icon: const Icon(Icons.edit, size: CConstants.GOLDEN_SIZE * 2),
                          ).animate(effects: CTransitionsTheme.model_1),
                        ),
                      ]),
                      const SizedBox(height: CConstants.GOLDEN_SIZE),
                      SelectableText(
                          "💍 Marié depuis ${coupleData != null ? coupleDate?.format('D, j M Y') ?? '___' : '___'}"),
                      SelectableText("🏠 Habite à ${coupleData?['adresse'] ?? '___'}"),
                      SelectableText("⭕ Téléphone : ${coupleData?['phone'] ?? '___'}"),
                    ]),
                  ),
                ).animate(effects: CTransitionsTheme.model_1);
              }
            }),

            // --- Enfants :
            const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("NOS ENFANTS", style: TextStyle(fontWeight: FontWeight.w200)),
                const SizedBox(width: CConstants.GOLDEN_SIZE),
                Expanded(child: Divider(thickness: 0.0, color: Theme.of(context).colorScheme.primary)),
              ]),
            ),

            if (loadingState['children'] ?? false)
              ...List<Widget>.generate(2, (index) {
                return const Padding(
                  padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: CardLoading(
                    height: CConstants.GOLDEN_SIZE * 5,
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                  ),
                );
              })

            // --- LIST :
            else
              ...childrenData.map((e) {
                return Builder(builder: (context) {
                  if (e['type'] == 'VIRTUAL') {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(CupertinoIcons.person)),
                      title: Text(e['data']['nom']),
                      subtitle: Text(e['data']['is_maried'] == true ? 'Marié' : "Celibataire"),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const ListTile(title: Text("Modifie"), leading: Icon(Icons.edit)),
                            onTap: () => openEditChildDialog(e),
                          ),
                          PopupMenuItem(
                            child: const ListTile(title: Text("Supprimer"), leading: Icon(CupertinoIcons.trash)),
                            onTap: () => removeChild(e['id']),
                          ),
                        ],
                      ),
                    ).animate(effects: CTransitionsTheme.model_1);
                  } else {
                    // CONCRET CHILD.
                    return ListTile(
                      leading: GestureAnimator(
                        child: Badge(
                          isLabelVisible: true,
                          label: const Text("Utilisateur", style: TextStyle(fontSize: CConstants.GOLDEN_SIZE)),
                          padding: const EdgeInsets.symmetric(
                            horizontal: CConstants.GOLDEN_SIZE - 7,
                            vertical: CConstants.GOLDEN_SIZE - 8,
                          ),
                          alignment: Alignment.bottomLeft,
                          offset: const Offset(CConstants.GOLDEN_SIZE - 13, -9.0),
                          child: CircleAvatar(backgroundImage: NetworkImage(CImageHandlerClass.byPid(e['data']['photo']))),
                        ),
                        onTap: () => openProfile(e['data']['id']),
                      ),
                      title: Text(e['data']['name']),
                      // subtitle: Text(e['data']['is_maried'] == true ? 'Marié' : "Celibataire"),
                      subtitle: Text(e['data']['fullname']),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const ListTile(title: Text("Supprimer"), leading: Icon(CupertinoIcons.trash)),
                            onTap: () => removeChild(e['id']),
                          ),
                        ],
                      ),
                    ).animate(effects: CTransitionsTheme.model_1);
                  }
                });
              }),

            // --- ADD :
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CConstants.GOLDEN_SIZE * 2,
                vertical: CConstants.GOLDEN_SIZE * 1,
              ),
              child: FilledButton.tonal(
                onPressed:
                    loadingState['children'] == true || loadingState['couple'] == true ? null : () => openAddChildDialog(),
                child: const Text("Ajouter un enfant"),
              ),
            ),
          ]);
        }),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void downloadCoupleData() {
    var hand = userData?['civility'] == 'F' ? 'epouse' : 'epoue';

    Map data = {
      's': 'family',
      'f': 'get_couple',
    };

    CApi.request.post('/family/request/handler', data: data).then(
      (response) {
        _s(() {
          loadingState['couple'] = false;
          if (response.data is Map) {
            coupleData = response.data;
            rightHand = response.data[hand];
          } else {
            hasPartner = false;
            checkIfHasPartnerRequest();
          }
        });
      },
      onError: (error) {
        _s(() => loadingState['couple'] = true);
      },
    );
  }

  void downloadChildrenData() {
    Map data = {'s': 'child', 'f': 'get_children'};

    CApi.request.post('/family/request/handler', data: data).then(
      (response) {
        _s(() => loadingState['children'] = false);
        childrenData = response.data;
      },
      onError: (error) {
        _s(() => loadingState['children'] = false);
      },
    );
  }

  void updateCouple(Map data) {
    _s(() => loadingState['couple_update'] = true);

    Map requestData = {
      's': 'family',
      'f': 'update_couple',
      ...data,
    };

    CApi.request.post('/family/request/handler', data: requestData).then(
      (response) {
        _s(() => loadingState['couple_update'] = false);
        if (response.data['state'] == 'UPDATED') {
          downloadCoupleData();
        } else {
          //
        }
      },
      onError: (error) {
        _s(() => loadingState['couple_update'] = false);
      },
    );
  }

  void openUpdateCouple() {
    // Open dialog.
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController coupleNameControler = TextEditingController(text: coupleData?['nom']);
        TextEditingController dMariageNameControler = TextEditingController(text: coupleData?['d_mariage']);
        TextEditingController adresseNameControler = TextEditingController(text: coupleData?['adresse']);
        TextEditingController photoNameControler = TextEditingController(text: coupleData?['phone']);

        return AlertDialog(
          contentPadding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          content: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text("Mon couple", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              TextFormField(
                validator: CFormValidator([CFormValidator.required(message: "Un couple doit avoir un nom.")]).validate,
                decoration: const InputDecoration(label: Text("Nom du couple")),
                controller: coupleNameControler,
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              TextFormField(
                decoration: const InputDecoration(label: Text("Date du mariage")),
                controller: dMariageNameControler,
                keyboardType: TextInputType.datetime,
                inputFormatters: [TextInputMask(mask: '99-99-9999', placeholder: '_', maxPlaceHolders: 8)],
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              TextFormField(
                decoration: const InputDecoration(label: Text("Adresse")),
                controller: adresseNameControler,
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              TextFormField(
                decoration: const InputDecoration(label: Text("Numéro de téléphone")),
                // inputFormatters: [TextInputMask(mask: '999-999-999', placeholder: '_', maxPlaceHolders: 9)],
                keyboardType: TextInputType.phone,
                controller: photoNameControler,
              ),
              const SizedBox(height: CConstants.GOLDEN_SIZE),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                TextButton.icon(
                  icon: const Icon(CupertinoIcons.check_mark, size: CConstants.GOLDEN_SIZE * 2),
                  onPressed: () {
                    Navigator.pop(context);
                    updateCouple({
                      'name': coupleNameControler.text.trim(),
                      'd_mariage': dMariageNameControler.text,
                      'adresse': adresseNameControler.text.trim(),
                      'phone': photoNameControler.text,
                    });
                  },
                  label: const Text("OK"),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  label: const Text("Annuler"),
                ),
              ]),
            ]),
          ),
        ).animate(effects: CTransitionsTheme.model_1);
      },
    );
  }

  void addChild(Map data) {
    _s(() => loadingState['children'] = true);

    Map requestData = {
      's': 'child',
      'f': 'add',
      ...data,
    };

    CApi.request.post('/family/request/handler', data: requestData).then(
      (response) {
        if (response.data['state'] == 'CREATED') {
          downloadChildrenData();
        } else {
          _s(() => loadingState['children'] = false);
          _showSnackbar(text: "Le informations que vous avez fourni sont incomplètes ou incorrects.");
        }
      },
      onError: (error) {
        _s(() => loadingState['children'] = false);
        _showSnackbar(text: "Le informations que vous avez fourni sont incomplètes ou incorrects.");
      },
    );
  }

  void removeChild(String childId) {
    _s(() => loadingState['children'] = true);

    Map requestData = {
      's': 'child',
      'f': 'remove',
      'child_id': childId,
    };

    CApi.request.post('/family/request/handler', data: requestData).then(
      (response) {
        if (response.data['state'] == 'REMOVED') {
          downloadChildrenData();
        } else {
          _showSnackbar(text: "La suppression a échoué. Veuillez réessayer.");
        }
      },
      onError: (error) {
        _showSnackbar(text: "Veuillez vérifier votre l'état de votre connexion internet.");
      },
    );
  }

  void editChild(String childId, Map data) {
    _s(() => loadingState['children'] = true);

    var requestData = {
      's': 'child',
      'f': 'update',
      'child_id': childId,
      ...data,
    };

    // return;
    CApi.request.post("/family/request/handler", data: requestData).then(
      (response) {
        _s(() => loadingState['children'] = false);
        if (response.data['state'] == 'UPDATED') {
          downloadChildrenData();
        } else {
          _showSnackbar(text: "La mise à jour a échoué. Veuillez réessayer.");
        }
      },
      onError: (error) {
        _s(() => loadingState['children'] = false);
        _showSnackbar(text: "Veuillez vérifier votre l'état de votre connexion internet.");
      },
    );
  }

  void openAddChildDialog() {
    showDialog(
      context: context,
      builder: (context) {
        Map data = {'nom': '', 'd_naissance': '', 'gender': 'M', 'is_maried': false};

        return SimpleDialog(contentPadding: const EdgeInsets.all(CConstants.GOLDEN_SIZE), children: [
          Text(
            "Ajouter un enfant",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          TextField(
            onChanged: (value) => data['nom'] = value.trim(),
            decoration: const InputDecoration(labelText: "Nom"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          TextField(
            onChanged: (value) => data['d_naissance'] = value.trim(),
            decoration: const InputDecoration(labelText: "Date de naissance", hintText: '09-09-200'),
            keyboardType: TextInputType.datetime,
            inputFormatters: [TextInputMask(mask: '99-99-9999', placeholder: '_', maxPlaceHolders: 8)],
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: DropdownMenu<String>(
                initialSelection: data['gender'],
                onSelected: (value) => data['gender'] = value,
                label: const Text("Genre"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'M', label: 'Masculin'),
                  DropdownMenuEntry(value: 'F', label: 'Feminin'),
                ],
              ),
            ),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Expanded(
              child: DropdownMenu<bool>(
                initialSelection: data['is_maried'],
                onSelected: (state) => data['is_maried'] = state,
                label: const Text("Etat marital"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: false, label: 'Célibataire'),
                  DropdownMenuEntry(value: true, label: 'Marié'),
                ],
              ),
            ),
          ]),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () {
                Navigator.pop(context);
                addChild(data);
              },
              child: const Text("Ajouter"),
            ),
            TextButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
          ]),
        ]).animate(effects: CTransitionsTheme.model_1);
      },
    );
  }

  void openEditChildDialog(Map data) {
    showDialog(
      context: context,
      builder: (context) {
        var date = DateTime.parse(data['data']['d_naissance'] ?? '');

        TextEditingController nameInputController = TextEditingController(text: data['data']['nom'] ?? '');
        TextEditingController dateInputController = TextEditingController(text: "${date.day}-${date.month}-${date.year}");

        return SimpleDialog(contentPadding: const EdgeInsets.all(CConstants.GOLDEN_SIZE), children: [
          Text(
            "Editer ${data['data']['nom']}",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          TextField(
            controller: nameInputController,
            onChanged: (value) => data['data']['nom'] = value.trim(),
            decoration: const InputDecoration(labelText: "Nom"),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          TextField(
            controller: dateInputController,
            onChanged: (value) => data['data']['d_naissance'] = value.trim(),
            decoration: const InputDecoration(labelText: "Date de naissance", hintText: '09-09-2007'),
            keyboardType: TextInputType.datetime,
            inputFormatters: [TextInputMask(mask: '99-99-9999', placeholder: '_', maxPlaceHolders: 8)],
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: DropdownMenu<String>(
                initialSelection: data['data']['genre'],
                onSelected: (value) => data['data']['genre'] = value,
                label: const Text("Genre"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: 'M', label: 'Masculin'),
                  DropdownMenuEntry(value: 'F', label: 'Feminin'),
                ],
              ),
            ),
            const SizedBox(width: CConstants.GOLDEN_SIZE),
            Expanded(
              child: DropdownMenu<bool>(
                initialSelection: data['data']['is_maried'],
                onSelected: (state) => data['data']['is_maried'] = state,
                label: const Text("Etat marital"),
                dropdownMenuEntries: const [
                  DropdownMenuEntry(value: false, label: 'Célibataire'),
                  DropdownMenuEntry(value: true, label: 'Marié'),
                ],
              ),
            ),
          ]),
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              child: const Text("Enregistrer"),
              onPressed: () {
                Navigator.pop(context);
                editChild(data['id'], data['data']);
              },
            ),
            TextButton(
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
          ]),
        ]).animate(effects: CTransitionsTheme.model_1);
      },
    );
  }

  void _showSnackbar({required String text, Color? color}) {
    CSnackbarWidget(context, content: Text(text), backgroundColor: color ?? Theme.of(context).colorScheme.error);
  }

  void openProfile(String userId) => context.pushNamed(UserProfileDetailsScreen.routeName, extra: {'user_id': userId});

  void openCoupleFitchModal() {
    CModalWidget.fullscreen(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        child: CFindCoupleComponent(
          isParent: true,
          civilite: userData?['civilite'],
          selected: selectCouple,
          onSelected: (selected) => _s(() => selectCouple = selected),
        ),
      ),
    ).show();
  }

  void _openSubmissionOfJoinCouple() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: StyledText(
          text: "Vous allez envoyer une demande d'approbation au partenaire du "
              "couple <bold>${selectCouple?['nom'] ?? ''}</bold> que vous venez de sélectionner. Notez bien que "
              "cette demande n'est soumis q'une fois. Si prochainement vous tentés de resoumettre "
              "cette demande, il échouera.",
          tags: CStyledTextTags().tags,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actionsPadding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE, horizontal: CConstants.GOLDEN_SIZE),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Fermer"),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              sendCoupleJoinRequest();
            },
            child: const Text("Soumettre"),
          ),
        ],
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        content: LinearProgressIndicator(
          borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS),
        ),
      ).animate(effects: CTransitionsTheme.model_1),
    );
  }

  void checkIfHasPartnerRequest() {
    Map data = {'s': 'family', 'f': 'has_sent_couple_request'};

    CApi.request.post('/family/request/handler', data: data).then(
      (res) {
        if (res.data['state'] == 'YES') {
          setState(() => hasPartnerRequest = true);
        }
      },
      onError: (e) {
        _showSnackbar(
          text: "Le serveur n'a pas être contacté pour savoir si vous avez une demande de partenaire disponible.",
        );
      },
    );
  }

  void sendCoupleJoinRequest() {
    _showLoadingDialog();

    Map data = {'s': 'family', 'f': 'send_couple_bind_request', 'couple_id': selectCouple?['id']};

    CApi.request.post('/family/request/handler', data: data).then(
      (res) {
        _back();
        if (res.data['state'] == 'SENT') {
          downloadCoupleData();
        } else {
          _showSnackbar(
            text: "Impossible de satisfaire votre demande. Car il ce peut que vous ayez une autre demande en cours.",
          );
        }
      },
      onError: (error) {
        _back();
        _showSnackbar(
          text: "Impossible de satisfaire votre demande. Veuillez vérifier la qualité de votre connexion internet.",
        );
      },
    );
  }

  void sendCreateNewCouple() {
    _showLoadingDialog();

    Map data = {'s': 'family', 'f': 'create_couple', 'name': newCoupleName};

    CApi.request.post('/family/request/handler', data: data).then(
      (res) {
        _back();
        if (res.data['state'] == 'CREATED') {
          setState(() => hasPartner = true);
          downloadCoupleData();
        } else {
          _showSnackbar(text: "Le couple n'a pas pus être créé car il semble que vous ayez une autre couple déjà créé.");
        }
      },
      onError: (error) {
        _back();
        _showSnackbar(
          text: "Impossible de satisfaire votre demande. Veuillez vérifier la qualité de votre connexion internet.",
        );
      },
    );
  }

  void _back() => context.pop();
}
