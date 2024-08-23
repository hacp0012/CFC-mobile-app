import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:cfc_christ/views/screens/app/aboutus_screen.dart';
import 'package:cfc_christ/views/screens/app/app_pastoral_calendar_screen.dart';
import 'package:cfc_christ/views/screens/app/app_setting_screen.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/app/donate_screen.dart';
import 'package:cfc_christ/views/screens/app/find_cfc_around_screen.dart';
import 'package:cfc_christ/views/screens/app/invite_friend_screen.dart';
import 'package:cfc_christ/views/screens/app/leave_notice_screen.dart';
import 'package:cfc_christ/views/screens/app/search_screen.dart';
import 'package:cfc_christ/views/screens/comm/new_comm_screen.dart';
import 'package:cfc_christ/views/screens/echo/new_echo_screen.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_drawer.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_echos.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_favorits.dart';
import 'package:cfc_christ/views/screens/notification/notifications_screen.dart';
import 'package:cfc_christ/views/screens/teaching/new_teaching_screen.dart';
import 'package:cfc_christ/views/screens/user/validable_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_home.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_teachings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class HomeScreen extends WatchingStatefulWidget {
  static const String routeName = 'home';
  static const String routePath = 'home';

  const HomeScreen({super.key, this.mainView, this.echosView, this.favoritesView, this.teachingsView});

  final Widget? mainView;
  final Widget? teachingsView;
  final Widget? echosView;
  final Widget? favoritesView;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPageViewIndex = 0;
  late PageController mainPagesViewControler;
  bool showFloatingActionButton = true;
  Map themeModeButtonIcon = <ThemeMode, IconData>{
    ThemeMode.light: CupertinoIcons.sun_max,
    ThemeMode.dark: CupertinoIcons.moon,
    ThemeMode.system: CupertinoIcons.sunrise_fill,
  };

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  void initState() {
    super.initState();

    mainPagesViewControler = PageController(initialPage: selectedPageViewIndex);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      navColor: Theme.of(context).colorScheme.surfaceContainer,
      child: Scaffold(
        // --- AppBar :
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: CConstants.GOLDEN_SIZE / 2,
          title: Row(children: [
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Row(children: [
                  const Icon(CupertinoIcons.ellipsis_vertical),
                  CircleAvatar(
                    backgroundColor: CMiscClass.whenBrightnessOf(context, dark: CConstants.LIGHT_COLOR),
                    child: Image.asset('lib/assets/icons/LOGO_CFC_512.png'),
                  ),
                ]),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE / 1),
            //   child: CircleAvatar(
            //     backgroundColor: CMiscClass.whenBrightnessOf(context, dark: CConstants.LIGHT_COLOR),
            //     child: Image.asset('lib/assets/icons/LOGO_CFC_512.png'),
            //   ),
            // ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("CFC"),
                Text("Communauté Famille Chrétienne", style: TextStyle(fontSize: CConstants.GOLDEN_SIZE)),
              ],
            ),
          ]),
          // leading: Builder(
          //   builder: (context) => IconButton(
          //     onPressed: () => Scaffold.of(context).openDrawer(),
          //     icon: const Icon(CupertinoIcons.bars),
          //   ),
          // ),
          // title: const Text("CFC", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(onPressed: () => context.pushNamed(SearchScreen.routeName), icon: const Icon(CupertinoIcons.search)),
            IconButton(
              onPressed: () => context.pushNamed(NotificationsScreen.routeName),
              icon: const Icon(CupertinoIcons.bell),
            ),
            // PopupMenuButton(
            //   itemBuilder: (context) => menuDrawerListItems().map((item) => PopupMenuItem(child: item)).toList(),
            // ),
          ],
        ),

        drawer: const Drawer(child: HomeScreenPartialDrawer()),

        // --- AppDrawer :
        // drawer: Drawer(
        //   child: Column(
        //     children: [
        //       DrawerHeader(
        //         padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
        //         decoration: BoxDecoration(
        //           color: Theme.of(context).colorScheme.surface,
        //           boxShadow: [
        //             if (Theme.of(context).brightness == Brightness.light)
        //               BoxShadow(
        //                 color: Theme.of(context).colorScheme.primaryContainer,
        //                 offset: const Offset(0.0, 6.0),
        //                 blurRadius: 9.0,
        //               )
        //           ],
        //         ),
        //         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //           // --- Logo bar :
        //           Row(children: [
        //             Row(children: [
        //               Padding(
        //                 padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE / 2),
        //                 child: CircleAvatar(
        //                   backgroundColor: CConstants.LIGHT_COLOR,
        //                   child: Image.asset('lib/assets/icons/LOGO_CFC_512.png'),
        //                 ),
        //               ),
        //               const Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text("CFC"),
        //                   Text("Communaute Familles Chretiene", style: TextStyle(fontSize: CConstants.GOLDEN_SIZE)),
        //                 ],
        //               ),
        //             ]),
        //             const Spacer(),
        //             IconButton(
        //               onPressed: () => toggleThemeMode(),
        //               icon: Icon(
        //                 themeModeButtonIcon[watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode)],
        //               ),
        //             ),
        //           ]),
        //
        //           // --- Profile :
        //           const SizedBox(height: CConstants.GOLDEN_SIZE),
        //           InkWell(
        //             child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //               const Padding(
        //                 padding: EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
        //                 child: CircleAvatar(radius: CConstants.GOLDEN_SIZE * 4, child: Icon(CupertinoIcons.person)),
        //               ),
        //               Expanded(
        //                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //                   const Text.rich(
        //                     TextSpan(text: 'Frere : ', children: [
        //                       TextSpan(
        //                         text: "tincidunt cumo congue mamrim",
        //                         style: TextStyle(fontWeight: FontWeight.w500),
        //                       )
        //                     ]),
        //                     maxLines: 3,
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                   Text(
        //                     "Modifier le profil",
        //                     style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 9.0),
        //                   )
        //                 ]),
        //               ),
        //             ]),
        //             onTap: () => context.pushNamed(ProfileScreen.routeName),
        //           ),
        //         ]),
        //       ),
        //
        //       // --- Buttons List :
        //       Expanded(child: ListView(children: menuDrawerListItems())),
        //
        //       // -- Logout Button :
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
        //         child: Text("cfc.app v1.0", textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelSmall),
        //       ),
        //     ],
        //   ),
        // ),

        // --- Body :
        body: PageView(
          restorationId: "home_main_page_view_restoration_id",
          controller: mainPagesViewControler,
          children: const [
            HomeScreenPartialViewHome(),
            HomeScreenPartialViewTeachings(),
            HomeScreenPartialViewEchos(),
            HomeScreenPartialViewFavorits(),
            // UserPartialProfileScreen(showEditButton: true),
          ],
          onPageChanged: (int index) => setState(() {
            selectedPageViewIndex = index;
            if (index == 3) {
              showFloatingActionButton = false;
            } else {
              showFloatingActionButton = true;
            }
          }),
        ),

        // --- Floating button :
        floatingActionButton: SpeedDial(
          visible: showFloatingActionButton,
          shape: const StadiumBorder(),
          activeIcon: CupertinoIcons.xmark,
          icon: CupertinoIcons.ellipsis_vertical,
          overlayColor: Theme.of(context).colorScheme.surfaceContainer,
          childMargin: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 1),
          label: const Text("Pub"),
          activeLabel: const Text("Fermer"),
          children: [
            SpeedDialChild(
              label: "Publier un communiquer",
              child: const Icon(CupertinoIcons.news),
              onTap: () => context.pushNamed(NewCommScreen.routeName),
            ),
            SpeedDialChild(
              label: "Publier un écho de la CFC",
              child: const Icon(CupertinoIcons.radiowaves_right),
              onTap: () => context.pushNamed(NewEchoScreen.routeName),
            ),
            SpeedDialChild(
              label: "Publier un enseignement",
              child: const Icon(CupertinoIcons.book),
              onTap: () => context.pushNamed(NewTeachingScreen.routeName),
            ),
            SpeedDialChild(
              label: "Calendrier pastoral",
              child: const Icon(CupertinoIcons.calendar),
              onTap: () => context.pushNamed(AppPastoralCalendarScreen.routeName),
            ),
            SpeedDialChild(
              label: "CFC à proximité",
              child: const Icon(CupertinoIcons.map_pin_ellipse),
              onTap: () => context.pushNamed(FindCfcAroundScreen.routeName),
            ),
          ],
        ),

        // --- Navigation :
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelSmall),
          ),
          child: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            selectedIndex: selectedPageViewIndex,
            animationDuration: const Duration(milliseconds: 900),
            height: CConstants.GOLDEN_SIZE * 7,
            destinations: const [
              NavigationDestination(icon: Icon(CupertinoIcons.home), label: "Accueil"),
              NavigationDestination(icon: Icon(CupertinoIcons.book), label: "Enseignements"),
              NavigationDestination(icon: Icon(CupertinoIcons.radiowaves_right), label: "Echos"),
              NavigationDestination(icon: Icon(CupertinoIcons.heart), label: "Favoris"),
              // NavigationDestination(icon: Icon(CupertinoIcons.person_circle), label: "Mon compte"),
            ],
            onDestinationSelected: (int index) => setState(() {
              selectedPageViewIndex = index;

              mainPagesViewControler.jumpToPage(index);
            }),
          ),
        ),
      ),
    );
  }

  List<Widget> menuDrawerListItems() {
    return [
      // ListTile(
      //   title: const Text("Mon compte"),
      //   leading: const Icon(CupertinoIcons.person_circle),
      //   tileColor: Theme.of(context).colorScheme.primaryContainer,
      //   titleAlignment: ListTileTitleAlignment.center,
      //   contentPadding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE),
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS)),
      //   onTap: () => context.pushNamed(ProfileScreen.routeName),
      // ),
      ListTile(
        title: const Text("Demande d'approbation"),
        subtitle: Text(
          "Certains activités nécessite vraiment votre approbation.",
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontFamily: CConstants.FONT_FAMILY_SECONDARY),
        ),
        leading: Icon(CupertinoIcons.shield_lefthalf_fill, color: Theme.of(context).colorScheme.error),
        onTap: () => context.pushNamed(ValidableScreen.routeName),
      ),
      ListTile(
        title: const Text("Calendrier pastoral"),
        leading: const Icon(CupertinoIcons.calendar),
        onTap: () => context.pushNamed(AppPastoralCalendarScreen.routeName),
      ),
      ListTile(
        title: const Text("9 : Notifications"),
        leading: const Icon(CupertinoIcons.bell),
        onTap: () => context.pushNamed(NotificationsScreen.routeName),
      ),
      ListTile(
        title: const Text("CFC à proximité"),
        leading: const Icon(CupertinoIcons.map_pin_ellipse),
        onTap: () => context.pushNamed(FindCfcAroundScreen.routeName),
      ),
      ListTile(
        title: const Text("Inviter un ami"),
        leading: const Icon(CupertinoIcons.person_2),
        onTap: () => context.pushNamed(InviteFriendScreen.routeName),
      ),
      ListTile(
        title: const Text("Laisser un avis"),
        leading: const Icon(CupertinoIcons.chat_bubble_text),
        onTap: () => context.pushNamed(LeaveNoticeScreen.routeName),
      ),
      ListTile(
        title: const Text("Faire une donation"),
        leading: const Icon(CupertinoIcons.money_dollar),
        onTap: () => context.pushNamed(DonateScreen.routeName),
      ),
      ListTile(
        title: const Text("Nous contacter"),
        leading: const Icon(CupertinoIcons.chat_bubble),
        onTap: () => context.pushNamed(ContactusScreen.routeName),
      ),
      ListTile(
        title: const Text("Paramètres"),
        leading: WidgetAnimator(atRestEffect: WidgetRestingEffects.rotate(), child: const Icon(CupertinoIcons.settings)),
        onTap: () => context.pushNamed(AppSettingScreen.routeName),
      ),
      ListTile(
        title: const Text("A propos de la CFC"),
        leading: const Icon(CupertinoIcons.info),
        onTap: () => context.pushNamed(AboutusScreen.routeName),
      ),
    ];
  }

  // --- FUNCTIONS :
  void toggleThemeMode() {
    setState(() {
      var mode = GetIt.I<CDefaultState>();
      if (mode.themeMode.value == ThemeMode.light) {
        mode.setThemeMode(ThemeMode.dark);
      } else if (mode.themeMode.value == ThemeMode.dark) {
        mode.setThemeMode(ThemeMode.system);
      } else {
        mode.setThemeMode(ThemeMode.light);
      }
    });
  }
}
