import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/components/c_com_card_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class HomeScreenPartialViewHome extends StatefulWidget {
  const HomeScreenPartialViewHome({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenPartialViewHomeState();
}

class _HomeScreenPartialViewHomeState extends State<HomeScreenPartialViewHome> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      // --- Carousel :
      Padding(
        padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
        child: FlutterCarousel(
          options: CarouselOptions(height: CConstants.GOLDEN_SIZE * 22, autoPlay: true, viewportFraction: 0.80),
          items: List<Widget>.generate(
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
          ),
        ),
      ),

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

      // --- LIST :
      ...List<Widget>.generate(9, (int index) {
        return const CComCardListComponent(showTypeLabel: true);
      }),

      // --- Bottom Empty space :
      const SizedBox(height: CConstants.GOLDEN_SIZE * 9),
    ]);
  }
}
