import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_echo_new_card_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_print_json/pretty_print_json.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenPartialViewEchos extends StatefulWidget {
  const HomeScreenPartialViewEchos({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewEchosState();
}

class _HomeScreenPartialViewEchosState extends State<HomeScreenPartialViewEchos> with AutomaticKeepAliveClientMixin {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool isLoading = true;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  List echoList = [];

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    load();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  // COMPONENT ---------------------------------------------------------------------------------------------------------------
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
      controller: refreshController,
      onRefresh: refreshList,header: WaterDropMaterialHeader(
        distance: 36,
        backgroundColor: CMiscClass.whenBrightnessOf(
          context,
          light: Theme.of(context).colorScheme.primaryContainer,
          dark: const Color.fromARGB(255, 33, 45, 61),
        ),
        color: CConstants.PRIMARY_COLOR,
      ),
      child: ListView(children: [
        // --- PCN Set :
        InkWell(
          child: Row(children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
        ...List<Widget>.generate(echoList.length, (int index) {
          return CEchoNewCardListComponent(echoData: echoList[index]);
        }),

        // --- Bottom Empty space :
        const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
      ]),
    );
  }

  // METHODS -----------------------------------------------------------------------------------------------------------------
  load() {
    setState(() => isLoading = true);

    _loadEchos();
  }

  refreshList() => _loadEchos();

  _loadEchos() {
    CApi.request.get('/echo/quest/home.echos.get.mVBuu9LnEPpBNFm9dJBPFUUNIrz').then((res) {
      if (res.data is Map && res.data['success']) {
        setState(() {
          prettyPrintJson(res.data['echos']);
          isLoading = false;
          echoList = res.data['echos'];
          // echoList = [];
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
