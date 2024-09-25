import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_com_card_list_component.dart';
import 'package:cfc_christ/views/components/c_echo_new_card_list_component.dart';
import 'package:cfc_christ/views/components/c_enseignement_card_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenPartialViewHome extends StatefulWidget {
  const HomeScreenPartialViewHome({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewHomeState();
}

class _HomeScreenPartialViewHomeState extends State<HomeScreenPartialViewHome> with AutomaticKeepAliveClientMixin {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool isLoading = true;
  RefreshController refreshController = RefreshController(initialRefresh: false);

  // List comList = [];
  List itemsList = [];

  List carouselPictures = [
    'Diapositive1.JPG',
    'Diapositive2.JPG',
    'picture_4.jpeg',
    'picture_5.jpeg',
    'picture_6.jpeg',
    'picture_7.jpeg',
  ];

  // INITALIZERS -------------------------------------------------------------------------------------------------------------
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
      controller: refreshController,
      header: WaterDropMaterialHeader(
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
        // --- Carousel :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
          child: FlutterCarousel(
            options: CarouselOptions(
              height: CConstants.GOLDEN_SIZE * 22,
              autoPlay: true,
              reverse: false,
              viewportFraction: 0.85,
              showIndicator: false,
              enlargeCenterPage: true,
              autoPlayCurve: Curves.ease,
              autoPlayAnimationDuration: 1.seconds,
            ),
            items: carouselPictures.map((element) {
              return Container(
                width: CConstants.GOLDEN_SIZE * 36,
                margin: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
                  boxShadow: const [BoxShadow(color: Colors.blueGrey, blurRadius: CConstants.GOLDEN_SIZE - 6)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
                  child: Image.asset('lib/assets/pictures/final/$element', height: 100, fit: BoxFit.cover),
                ),
              );
            }).toList(),
            /*items: List<Widget>.generate(
              3,
              (int index) => Container(
                width: CConstants.GOLDEN_SIZE * 36,
                margin: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
                  boxShadow: const [BoxShadow(color: Colors.blueGrey, blurRadius: CConstants.GOLDEN_SIZE - 6)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS / 2),
                  child: Image.asset('lib/assets/pictures/family_1.jpg', height: 100, fit: BoxFit.cover),
                ),
              ),
            ),*/
          ),
        ),

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

        // --- LIST :
        ...List<Widget>.generate(itemsList.length, (int index) {
          if (itemsList[index]['type'] == 'TEACH') {
            return CEnseignementCardListComponent(showTypeLabel: true, teachData: itemsList[index]['item']);
          } else if (itemsList[index]['type'] == 'ECHO') {
            return CEchoNewCardListComponent(echoData: itemsList[index]['item']);
          } else if (itemsList[index]['type'] == 'COM') {
            return CComCardListComponent(showTypeLabel: true, comData: itemsList[index]['item']);
          }

          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 9.0),
            child: Row(children: [
              Text("Element indisponible"),
            ]),
          );
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

  refreshList() {
    _loadComs();
  }

  _loadComs() {
    CApi.requestWithCache.get('/home/handler/get.home.3nLq7p0NwnXpcHjH9NANsNCNWJXKTyTKxJ9V').then((res) {
      if (res.data is Map && res.data['success']) {
        setState(() => isLoading = false);
        itemsList = res.data['list'];

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
