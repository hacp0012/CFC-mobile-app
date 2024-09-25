import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/views/components/c_enseignement_card_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenPartialViewTeachings extends StatefulWidget {
  const HomeScreenPartialViewTeachings({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewTeachingsState();
}

class _HomeScreenPartialViewTeachingsState extends State<HomeScreenPartialViewTeachings> with AutomaticKeepAliveClientMixin {
  // DATA --------------------------------------------------------------------------------------------------------------------
  bool isLoading = true;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  List teachList = [];

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    load();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE), children: [
        Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(9),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(child: SizedBox(height: 9.0 * 14, width: double.infinity)),
            SizedBox(height: 9.0),
            Card(child: SizedBox(height: 9.0 * 3, width: double.infinity)),
            SizedBox(height: 9.0 * 2),
            Card(child: SizedBox(height: 9.0 * 14, width: double.infinity)),
            SizedBox(height: 9.0 * 1),
            Card(child: SizedBox(height: 9.0 * 14, width: double.infinity)),
            SizedBox(height: 9.0 * 1),
            Card(child: SizedBox(height: 9.0 * 3, width: 9.0 * 18)),
          ]),
        ),
      ]);
    }

    return SmartRefresher(
      controller: refreshController,header: WaterDropMaterialHeader(
        distance: 36,
        backgroundColor: CMiscClass.whenBrightnessOf(
          context,
          light: Theme.of(context).colorScheme.primaryContainer,
          dark: const Color.fromARGB(255, 33, 45, 61),
        ),
        color: CConstants.PRIMARY_COLOR,
      ),
      onRefresh: refreshList,
      child: ListView(children: [
        // --- PCN Set :
        InkWell(
          child: Row(children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Text(
                "Pool de Bukavu, CL Notre-Dame, NA Notre-Dame",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CConstants.PRIMARY_COLOR),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
              child: Icon(CupertinoIcons.map_pin_ellipse, size: CConstants.GOLDEN_SIZE * 2),
            ),
          ]),
          onTap: () {},
        ),

        // --- LIST Body :
        ...List<Widget>.generate(teachList.length, (int index) {
          return CEnseignementCardListComponent(teachData: teachList[index], showTypeLabel: true);
        }),

        // --- Bottom Empty space :
        const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
      ]),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  load() {
    setState(() => isLoading = true);

    _loadComs();
  }

  refreshList() => _loadComs();

  _loadComs() {
    CApi.requestWithCache.get('/teaching/quest/home.teachs.get.tNakED4gqPiuBHcOGHa7IT3U86n').then((res) {
      if (res.data is Map && res.data['success']) {
        setState(() {
          isLoading = false;
          teachList = res.data['teachs'];
        });

        refreshController.refreshCompleted();
      }
    }).catchError((err) {
      setState(() => isLoading = false);
      refreshController.refreshCompleted();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
