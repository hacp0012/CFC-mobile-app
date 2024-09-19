import 'package:cached_network_image/cached_network_image.dart';
import 'package:cfc_christ/classes/c_image_handler_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/model_view/notification_mv.dart';
import 'package:cfc_christ/model_view/user_mv.dart';
import 'package:cfc_christ/services/validable/c_s_validable.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/views/screens/app/aboutus_screen.dart';
import 'package:cfc_christ/views/screens/app/app_pastoral_calendar_screen.dart';
import 'package:cfc_christ/views/screens/app/app_setting_screen.dart';
import 'package:cfc_christ/views/screens/app/contactus_screen.dart';
import 'package:cfc_christ/views/screens/app/donate_screen.dart';
import 'package:cfc_christ/views/screens/app/find_cfc_around_screen.dart';
import 'package:cfc_christ/views/screens/app/invite_friend_screen.dart';
import 'package:cfc_christ/views/screens/app/leave_notice_screen.dart';
import 'package:cfc_christ/views/screens/notification/notifications_screen.dart';
import 'package:cfc_christ/views/screens/user/profile_screen.dart';
import 'package:cfc_christ/views/screens/user/user_publications_list_screen.dart';
import 'package:cfc_christ/views/screens/user/validable_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watch_it/watch_it.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class HomeScreenPartialDrawer extends WatchingStatefulWidget {
  const HomeScreenPartialDrawer({super.key});

  @override
  State<HomeScreenPartialDrawer> createState() => _HomeScreenPartialDrawerState();
}

class _HomeScreenPartialDrawerState extends State<HomeScreenPartialDrawer> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  Map themeModeButtonIcon = <ThemeMode, IconData>{
    ThemeMode.light: CupertinoIcons.sun_max,
    ThemeMode.dark: CupertinoIcons.moon,
    ThemeMode.system: CupertinoIcons.sunrise_fill,
  };
  Map<String, dynamic> userData = {};
  int validableCount = 0;

  // INITLIZER ---------------------------------------------------------------------------------------------------------------
  // void _s(fn) => super.setState(fn);

  @override
  void initState() {
    userData = UserMv.data ?? {};

    super.initState();
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    validableCount = watchValue<CSValidable, int>((CSValidable x) => x.counter);

    return Column(
      children: [
        DrawerHeader(
          padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              if (Theme.of(context).brightness == Brightness.light)
                BoxShadow(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  offset: const Offset(0.0, 6.0),
                  blurRadius: 9.0,
                )
            ],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // --- Logo bar :
            Row(children: [
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE / 2),
                  child: CircleAvatar(
                    backgroundColor: CConstants.LIGHT_COLOR,
                    child: Image.asset(Env.APP_ICON_ASSET),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CFC"),
                    Text("Communaute Familles Chretiene", style: TextStyle(fontSize: CConstants.GOLDEN_SIZE)),
                  ],
                ),
              ]),
              const Spacer(),
              IconButton(
                onPressed: () => toggleThemeMode(),
                icon: Icon(
                  themeModeButtonIcon[watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode)],
                ),
              ),
            ]),

            // --- Profile :
            const SizedBox(height: CConstants.GOLDEN_SIZE),
            GestureAnimator(
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.only(right: CConstants.GOLDEN_SIZE),
                  // child: CircleAvatar(radius: CConstants.GOLDEN_SIZE * 4, child: Icon(CupertinoIcons.person)),
                  child: Hero(
                    tag: 'USER_PROFILE_PHOTO',
                    child: CircleAvatar(
                      radius: CConstants.GOLDEN_SIZE * 4,
                      backgroundImage: CachedNetworkImageProvider(CImageHandlerClass.byPid(userData['photo'])),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      '${userData['civility'] == 'F' ? 'Frère' : 'Sœur'} : ',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(userData['fullname'], style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(
                      "Modifier le profil",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 9.0),
                    )
                  ]),
                ),
              ]),
              onTap: () => context.pushNamed(ProfileScreen.routeName),
            ),
          ]),
        ),

        // --- Buttons List :
        Expanded(child: ListView(children: menuDrawerListItems())),

        // -- Logout Button :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: CConstants.GOLDEN_SIZE),
          child: Text("CFC V1.0", textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelSmall),
        ),
      ],
    );
  }

  // DATAS -------------------------------------------------------------------------------------------------------------------
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
        title: const Text("Mes publications"),
        leading: const Icon(CupertinoIcons.news),
        onTap: () => context.pushNamed(UserPublicationsListScreen.routeName),
      ),
      const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
      if (validableCount > 0)
        ListTile(
          title: const Text("Demande d'approbation"),
          subtitle: Text(
            "Certains activités nécessite vraiment votre approbation.",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontFamily: CConstants.FONT_FAMILY_SECONDARY),
          ),
          leading: WidgetAnimator(
            atRestEffect: WidgetRestingEffects.pulse(),
            child: Icon(CupertinoIcons.shield_lefthalf_fill, color: Theme.of(context).colorScheme.error),
          ),
          trailing: validableCount == 0 ? null : Badge.count(count: validableCount),
          onTap: () => context.pushNamed(ValidableScreen.routeName),
        ),
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

  // --- FUNCTIONS -----------------------------------------------------------------------------------------------------------
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
