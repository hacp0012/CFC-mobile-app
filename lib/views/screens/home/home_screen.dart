import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/model_view/notification_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/app/aboutus_screen.dart';
import 'package:cfc_christ/views/screens/app/app_pastoral_calendar_screen.dart';
import 'package:cfc_christ/views/screens/app/app_setting_screen.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/app/donate_screen.dart';
import 'package:cfc_christ/views/screens/app/find_cfc_around_screen.dart';
import 'package:cfc_christ/views/screens/app/invite_friend_screen.dart';
import 'package:cfc_christ/views/screens/app/leave_notice_screen.dart';
import 'package:cfc_christ/views/screens/comm/new_comm_screen.dart';
import 'package:cfc_christ/views/screens/echo/new_echo_screen.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_drawer.dart';
import 'package:cfc_christ/views/screens/notification/notifications_screen.dart';
import 'package:cfc_christ/views/screens/teaching/new_teaching_screen.dart';
import 'package:cfc_christ/views/screens/user/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_home.dart';
import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_teachings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager_dio/flutter_cache_manager_dio.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';

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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int selectedPageViewIndex = 0;
  late PageController mainPagesViewControler;
  bool showFloatingActionButton = true;
  Map themeModeButtonIcon = <ThemeMode, IconData>{
    ThemeMode.light: CupertinoIcons.sun_max,
    ThemeMode.dark: CupertinoIcons.moon,
    ThemeMode.system: CupertinoIcons.sunrise_fill,
  };

  MotionTabBarController? _motionTabBarController;

  Map userData = {};

  // INITIALIZER /////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  void initState() {
    userData = UserMv.data ?? {};

    super.initState();

    mainPagesViewControler = PageController(initialPage: selectedPageViewIndex);

    _motionTabBarController = MotionTabBarController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _motionTabBarController!.dispose();

    super.dispose();
  }

  // VIEW ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    int countNotifications = watchValue((CDefaultState n) => n.notificationsCount);

    return DefaultLayout(
      navColor: CMiscClass.whenBrightnessOf(
        context,
        light: Theme.of(context).colorScheme.surfaceContainer,
        dark: const Color.fromARGB(255, 33, 45, 61),
      ),
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
            // PopupMenuButton(
            //   itemBuilder: (context) => menuDrawerListItems().map((item) => PopupMenuItem(child: item)).toList(),
            //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS)),
            //   // onSelected: (value) => context.pop(),
            //   child: Row(children: [
            //     const Icon(CupertinoIcons.ellipsis_vertical),
            //     CircleAvatar(
            //       backgroundColor: CMiscClass.whenBrightnessOf(context, dark: CConstants.LIGHT_COLOR),
            //       child: Image.asset('lib/assets/icons/LOGO_CFC_512.png'),
            //     ),
            //   ]),
            // ),
            // const SizedBox(width: CConstants.GOLDEN_SIZE),
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
            /*IconButton(onPressed: () => context.pushNamed(SearchScreen.routeName), icon: const Icon(CupertinoIcons.search)),*/
            // IconButton(
            //   onPressed: () => context.pushNamed(NotificationsScreen.routeName),
            //   icon: const Icon(CupertinoIcons.bell),
            // ),
            Badge(
              isLabelVisible: countNotifications > 0,
              label: countNotifications > 0
                  ? Text(countNotifications.toString())
                  : NotificationMv.count() > 0
                      ? Text(NotificationMv.count().toString())
                      : null,
              alignment: Alignment.bottomRight,
              offset: const Offset(-7, -24),
              child: IconButton(
                onPressed: () => context.pushNamed(NotificationsScreen.routeName),
                icon: const Icon(CupertinoIcons.bell),
              ),
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
          children: [
            const HomeScreenPartialViewHome(),
            const HomeScreenPartialViewTeachings(),
            // HomeScreenPartialViewEchos(),
            // HomeScreenPartialViewFavorits(),

            ...List.generate(2, (element) {
              return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(CupertinoIcons.snow, size: CConstants.GOLDEN_SIZE * 12, color: Theme.of(context).colorScheme.primary),
                const Text("Cette fonctionnalité vient bientôt"),
              ]));
            }),
            // UserPartialProfileScreen(showEditButton: true),
          ],
          onPageChanged: (int index) => setState(() {
            _motionTabBarController?.index = index;

            selectedPageViewIndex = index;
            if (index == 3) {
              showFloatingActionButton = false;
            } else {
              showFloatingActionButton = true;
            }
          }),
        ),

        /*body: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          // controller: _tabController,
          controller: _motionTabBarController,
          children: const <Widget>[
            HomeScreenPartialViewHome(),
            HomeScreenPartialViewTeachings(),
            HomeScreenPartialViewEchos(),
            HomeScreenPartialViewFavorits(),
            // UserPartialProfileScreen(showEditButton: true),
          ],
        ),*/

        // --- Floating button :
        floatingActionButton: SpeedDial(
          visible: showFloatingActionButton,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.GOLDEN_SIZE * 2)),
          activeIcon: CupertinoIcons.xmark,
          icon: CupertinoIcons.ellipsis_vertical,
          buttonSize: const Size(50.4, 50.4),
          elevation: 6.3,
          animationCurve: Curves.ease,
          overlayColor: Theme.of(context).colorScheme.surfaceContainer,
          foregroundColor: CMiscClass.whenBrightnessOf(context, dark: Colors.white70),
          childMargin: const EdgeInsets.all(CConstants.GOLDEN_SIZE * 1),
          childPadding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
          label: const Text("Menu"),
          activeLabel: const Text("Fermer"),
          children: [
            // TODO: User role :
            if (userData['role']?['role'] == 'COMMUNICATION_MANAGER') ...[
              SpeedDialChild(
                label: "Publier un communiquer",
                child: const Icon(CupertinoIcons.news),
                onTap: () => context.pushNamed(NewCommScreen.routeName),
              ),
              SpeedDialChild(
                label: "Publier un enseignement",
                child: const Icon(CupertinoIcons.book),
                onTap: () => context.pushNamed(NewTeachingScreen.routeName),
              ),
              SpeedDialChild(
                label: "Publier un écho de la CFC",
                child: const Icon(CupertinoIcons.radiowaves_right),
                onTap: () => context.pushNamed(NewEchoScreen.routeName),
              ),
            ],
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
        /*bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelSmall),
            iconTheme: WidgetStatePropertyAll(
              IconThemeData(color: CMiscClass.whenBrightnessOf(context, dark: Colors.white70)),
            ),
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
        ),*/

        bottomNavigationBar: MotionTabBar(
          controller: _motionTabBarController, // ADD THIS if you need to change your tab programmatically
          initialSelectedTab: "Accueil",
          labels: const ["Accueil", "Enseignements", "Echos", "Favoris"],
          icons: const [
            CupertinoIcons.home,
            CupertinoIcons.book,
            CupertinoIcons.radiowaves_right,
            CupertinoIcons.heart,
          ],
          tabSize: 45,
          tabBarHeight: 45,
          textStyle: Theme.of(context).textTheme.labelSmall,
          tabIconColor: CMiscClass.whenBrightnessOf(context, light: Colors.black, dark: CConstants.LIGHT_COLOR),
          tabIconSize: 23.4,
          tabIconSelectedSize: 23.4,
          tabSelectedColor: Theme.of(context).colorScheme.primaryContainer,
          tabIconSelectedColor: CMiscClass.whenBrightnessOf(context, light: Colors.blue, dark: CConstants.LIGHT_COLOR),
          tabBarColor: CMiscClass.whenBrightnessOf(
            context,
            light: Theme.of(context).colorScheme.surfaceContainer,
            dark: const Color.fromARGB(255, 33, 45, 61),
          ),
          onTabItemSelected: (int index) {
            setState(() {
              // _tabController!.index = value;
              // _motionTabBarController!.index = value;
              mainPagesViewControler.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }

  // METHODS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  List<Widget> menuDrawerListItems() {
    return [
      ListTile(
        title: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Mon compte", style: Theme.of(context).textTheme.labelSmall),
          Text(userData['fullname'], style: const TextStyle(fontWeight: FontWeight.w500)),
        ]),
        leading: Hero(
          tag: 'USER_PROFILE_PHOTO',
          child: CachedNetworkImage(
            cacheManager: DioCacheManager.instance,
            imageUrl: CImageHandlerClass.byPid(userData['photo']),
            placeholder: (context, url) => const Icon(CupertinoIcons.person),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: CConstants.GOLDEN_SIZE * 3,
              backgroundImage: imageProvider,
            ),
          ),
        ),
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        titleAlignment: ListTileTitleAlignment.center,
        contentPadding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE / 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CConstants.DEFAULT_RADIUS)),
        onTap: () => context.pushNamed(ProfileScreen.routeName),
      ),
      // ListTile(
      //   title: const Text("Demande d'approbation"),
      //   subtitle: Text(
      //     "Certains activités nécessite vraiment votre approbation.",
      //     style: Theme.of(context).textTheme.labelSmall?.copyWith(fontFamily: CConstants.FONT_FAMILY_SECONDARY),
      //   ),
      //   leading: Icon(CupertinoIcons.shield_lefthalf_fill, color: Theme.of(context).colorScheme.error),
      //   onTap: () => context.pushNamed(ValidableScreen.routeName),
      // ),
      ListTile(
        title: const Text("Calendrier pastoral"),
        leading: const Icon(CupertinoIcons.calendar),
        onTap: () => context.pushNamed(AppPastoralCalendarScreen.routeName),
      ),
      Builder(builder: (context) {
        int count = NotificationMv.count();
        return ListTile(
          title: const Text("Notifications"),
          leading: const Icon(CupertinoIcons.bell),
          trailing: count > 0 ? Badge.count(count: count) : null,
          onTap: () => context.pushNamed(NotificationsScreen.routeName),
        );
      }),
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
        leading: const Icon(CupertinoIcons.settings),
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

  showDomoNotif() {}
}
