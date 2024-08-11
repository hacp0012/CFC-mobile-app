import 'package:cfc_christ/views/components/c_enseignement_card_list_component.dart';
import 'package:flutter/cupertino.dart';

class HomeScreenPartialViewFavorits extends StatefulWidget {
  const HomeScreenPartialViewFavorits({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewFavoritsState();
}

class _HomeScreenPartialViewFavoritsState extends State<HomeScreenPartialViewFavorits> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ...List<Widget>.generate(9, (int index) {
        return const CEnseignementCardListComponent(isInFavorite: true, showTypeLabel: true);
      }),
    ]);
  }
}