import 'dart:async';

import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/views/widgets/c_modal_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class CFindCoupleComponent extends StatefulWidget {
  const CFindCoupleComponent({super.key, required this.civilite, this.isParent = true, this.selected, this.onSelected});

  final String? civilite;

  /// input the selected couple data.
  final Map? selected;
  final bool isParent;
  final Function(Map?)? onSelected;

  @override
  State<CFindCoupleComponent> createState() => _CFindCoupleComponentState();
}

class _CFindCoupleComponentState extends State<CFindCoupleComponent> {
  Map? selected;
  bool inLoading = false;
  List results = <Map>[];
  bool noResult = false;
  Timer? timingLaunchSearch;
  TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    selected = widget.selected;

    super.initState();
  }

  void _s(fn) => super.setState(fn);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: CConstants.GOLDEN_SIZE),
          child: Text(
            "Chercher votre ${widget.isParent ? 'partenaire' : 'famille'}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        TextField(
          controller: searchFieldController,
          decoration: InputDecoration(
            hintText: " Entrer le nom de votre ${widget.isParent ? "partenaire (épous/épouse)" : "famille"} ici...",
          ),
          textInputAction: TextInputAction.search,
          onChanged: (value) => temporalyWait(),
          onSubmitted: (value) {
            if (timingLaunchSearch != null) {
              timingLaunchSearch?.cancel();
            }
            startFetching();
          },
        ),
        if (widget.isParent)
          Text(
            "- Les résultats de votre recherche dépendent de votre civilité.\n"
            "- Ces résultats ne concernent que les membres qui sont en attente d'un partenaire de votre civilité.",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        if (selected != null)
          ListTile(
            selected: true,
            leading: const Icon(CupertinoIcons.person_crop_circle),
            title: Text("${widget.civilite == 'F' ? 'Sœur' : 'Frère'} ${widget.selected?['nom']}"),
            subtitle: const Text("Sélectionné"),
            trailing: IconButton(icon: const Icon(CupertinoIcons.xmark), onPressed: () => _s(() => selected = null)),
          ),
        Expanded(
          child: ListView(children: [
            if (inLoading)
              Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.blue,
                child: const Text(
                  'En cours de cherche...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: CConstants.GOLDEN_CONST * 9,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(effects: CTransitionsTheme.model_1),
              )
            else if (noResult)
              const Text("Aucun résultat trouvé").animate(effects: CTransitionsTheme.model_1)
            else
              ...results.map<Widget>((element) {
                return ListTile(
                  leading: const Icon(CupertinoIcons.person_crop_circle),
                  title: Text(
                    "${widget.isParent ? (widget.civilite == 'F' ? 'Sœur' : 'Frère') : 'Famille'} ${element['nom']}",
                  ),
                  subtitle: Text(element['adresse'] ?? ''),
                  onTap: () => selectCouple(element),
                ).animate(effects: CTransitionsTheme.model_1);
              }),
          ]),
        ),
        Row(children: [
          const Spacer(),
          TextButton(
            style: const ButtonStyle(visualDensity: VisualDensity.compact),
            onPressed: () {
              widget.onSelected?.call(selected);
              CModalWidget.close(context);
            },
            child: const Text("Fermer"),
          ),
        ]),
      ],
    );
  }

  // -------------------------------------------------------------------------------------------------------------------------
  void temporalyWait() {
    if (timingLaunchSearch != null) {
      timingLaunchSearch?.cancel();
    }

    timingLaunchSearch = Timer(2.seconds, () => startFetching());
  }

  void startFetching() {
    _s(() => inLoading = true);

    CApi.request.get(
      '/misc/find_couple',
      data: {'where': widget.isParent ? 'parent' : 'child', 'civility': widget.civilite, 'name': searchFieldController.text},
    ).then((response) {
      _s(() {
        inLoading = false;
        results = response.data;

        if (results.isEmpty) {
          noResult = true;
        } else {
          noResult = false;
        }
      });
    }, onError: (error) {
      if (kDebugMode) {
        print("ERROR ------------------------------------------------");
        print(error);
      }
    });
  }

  void selectCouple(Map? data) {
    widget.onSelected?.call(data);
    CModalWidget.close(context);
  }
}
