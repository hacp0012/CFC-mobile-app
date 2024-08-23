import 'package:card_loading/card_loading.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_styled_text_tags.dart';
import 'package:cfc_christ/model_view/validable_mv.dart';
import 'package:cfc_christ/services/validable/c_s_validable.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:styled_text/styled_text.dart';
import 'package:watch_it/watch_it.dart';

class ChildValidableScreen extends StatefulWidget {
  static const String routeName = 'validable.child';
  static const String routePath = 'child';

  final GoRouterState? grState;

  const ChildValidableScreen({super.key, this.grState});

  @override
  State createState() => _ChildValidableScreenState();
}

class _ChildValidableScreenState extends State<ChildValidableScreen> {
  // DATA --------------------------------------------------------------------------------------------------------------------
  Map validable = {};
  bool inLoading = true;
  Map askerData = {};

  bool notInValidationProcess = true;

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    var gState = widget.grState?.extra;
    validable = (gState ?? {}) as Map;
    // print(validable);

    super.initState();

    _downloadAskerData();
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info de comfirmation'), centerTitle: true),

      // Body.
      body: SingleChildScrollView(
        child: Builder(builder: (context) {
          if (inLoading) {
            return const Padding(
              padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
              child: Column(
                children: [
                  SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                  CardLoading(
                    borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                    height: CConstants.GOLDEN_SIZE * 5,
                    width: CConstants.GOLDEN_SIZE * 5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: CardLoading(
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      height: CConstants.GOLDEN_SIZE,
                      width: CConstants.GOLDEN_SIZE * 7,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                    child: CardLoading(
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      height: CConstants.GOLDEN_SIZE,
                      child: Padding(padding: EdgeInsets.all(8.0), child: Text("Chargement")),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 2),
                    child: CardLoading(
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      height: CConstants.GOLDEN_SIZE * 7,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: CConstants.GOLDEN_SIZE),
                    child: CardLoading(
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      height: CConstants.GOLDEN_SIZE,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: CConstants.GOLDEN_SIZE * 3),
                    child: CardLoading(
                      borderRadius: BorderRadius.all(Radius.circular(CConstants.DEFAULT_RADIUS)),
                      height: CConstants.GOLDEN_SIZE * 2,
                    ),
                  ),
                ],
              ),
            ).animate(effects: CTransitionsTheme.model_1);
          } else {
            DateTime date = DateTime.parse(askerData['data']['d_naissance']);
            DateTime validableDate = DateTime.parse(validable['created_at']);

            return Center(
              child: Column(children: [
                const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
                InkWell(
                  child: CircleAvatar(
                    radius: CConstants.GOLDEN_SIZE * 5,
                    backgroundImage: NetworkImage(CImageHandlerClass.byPid(askerData['data']['photo'])),
                  ),
                  onTap: () {
                    CImageHandlerClass.show(context, [askerData['data']['photo']]);
                  },
                ),
                Text(askerData['data']['name'], style: Theme.of(context).textTheme.titleMedium),
                Text(askerData['data']['fullname']),
                Text(
                  "${askerData['data']['civility'] == 'F' ? 'Homme' : 'Femme'}, né le ${date.format('j M Y')}",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text("(${askerData['data']['telephone'][0]}) ${askerData['data']['telephone'][1]}"),
                Padding(
                  padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                  child: Text(
                    "Cette demande fut soumis depuis ${validableDate.format('j M Y')}. \n"
                    "Cette personne attend juste votre confirmation pour qu'il "
                    "puiss commencer à faire usage de sont compte comme un utilisateur "
                    "normal mais avec quelques restructurations soumis à son age et sont état civile.",
                  ),
                ),
                Visibility(
                  visible: notInValidationProcess,
                  replacement: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE, vertical: CConstants.GOLDEN_SIZE),
                    child: LinearProgressIndicator(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE / 2))
                        .animate(effects: CTransitionsTheme.model_1),
                  ),
                  child: Card(
                    margin: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                    child: Padding(
                      padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
                      child: Column(
                        children: [
                          StyledText(
                            text: '<small>'
                                "Notre politique veut à ce que, quand un parent rejete "
                                "la demande d'un enfant, le profil de cet enfant est aussi supprimé. "
                                '<br/>'
                                '<br/>'
                                "Donc vous avez le plein pouvoir sur l'état de cet utilisateur (personne)."
                                '</small>',
                            tags: CStyledTextTags().tags,
                          ),
                          const SizedBox(height: CConstants.GOLDEN_SIZE),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            TextButton.icon(
                              icon: const Icon(CupertinoIcons.xmark, size: CConstants.GOLDEN_SIZE * 2),
                              style:
                                  ButtonStyle(foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.error)),
                              onPressed: () => rejectAsker(),
                              label: const Text("Rejeter"),
                            ),
                            TextButton.icon(
                              icon: const Icon(CupertinoIcons.check_mark, size: CConstants.GOLDEN_SIZE * 2),
                              onPressed: () => comfirmAsker(),
                              label: const Text("Je l'accept"),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ).animate(effects: CTransitionsTheme.model_1);
          }
        }),
      ),
    );
  }

  // METHODES ----------------------------------------------------------------------------------------------------------------
  void _downloadAskerData() {
    CApi.request.get('/user/minimum/info', data: {'user_id': validable['sender']}).then((response) {
      if (response.data['state'] == 'SUCCESS') {
        setState(() {
          inLoading = false;
          askerData = response.data;
        });
      } else {
        _back();
        _showSnackbar("Impossible de télécharger les données de la demande, veuillez réouvrir la page de la demande.");
      }
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    });
  }

  void comfirmAsker() {
    setState(() => notInValidationProcess = false);

    ValidableMv(validable).validate(
      onFinish: () {
        setState(() => notInValidationProcess = true);
        GetIt.I<CSValidable>().load();
        context.pop();
      },
      onFailed: () {
        setState(() => notInValidationProcess = true);
        _showSnackbar("Échec de mises à jour.");
      },
    );
  }

  void rejectAsker() {
    setState(() => notInValidationProcess = false);

    ValidableMv(validable).reject(
      onFinish: () {
        setState(() => notInValidationProcess = true);
        GetIt.I<CSValidable>().load(true);
        context.pop();
      },
      onFailed: () {
        setState(() => notInValidationProcess = true);
        _showSnackbar("Échec de mises à jour.");
      },
    );
  }

  void _back() => context.pop();

  void _showSnackbar(String s) {
    CSnackbarWidget(context, content: Text(s));
  }
}
