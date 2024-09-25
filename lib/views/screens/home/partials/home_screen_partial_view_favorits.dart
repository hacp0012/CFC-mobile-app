import 'package:flutter/cupertino.dart';

class HomeScreenPartialViewFavorits extends StatefulWidget {
  const HomeScreenPartialViewFavorits({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewFavoritsState();
}

class _HomeScreenPartialViewFavoritsState extends State<HomeScreenPartialViewFavorits> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: const [
      // ...List<Widget>.generate(9, (int index) {
      //   return const CEnseignementCardListComponent(teachData: {}, isInFavorite: true, showTypeLabel: true);
      // }),
    ]);
  }
}