import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class AppSettingScreen extends WatchingStatefulWidget {
  static const String routeName = 'settings';
  static const String routePath = 'settings';

  const AppSettingScreen({super.key});

  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  Map themeModeButtonIcon = <ThemeMode, IconData>{
    ThemeMode.light: CupertinoIcons.sun_max,
    ThemeMode.dark: CupertinoIcons.moon,
    ThemeMode.system: CupertinoIcons.sunrise_fill,
  };
  Map themeModeButtonText = <ThemeMode, String>{
    ThemeMode.light: "Claire",
    ThemeMode.dark: "Sombre",
    ThemeMode.system: "Systeme",
  };

  @override
  Widget build(BuildContext context) {
    final watchedThemeState = watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode);

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Parametrises')),

        // --- Body :
        body: ListView(children: [
          ListTile(
            title: Text('Theme ${themeModeButtonText[watchedThemeState]}'),
            subtitle: const Text("Changer en mode sombre, claire ou automatique."),
            leading: Icon(themeModeButtonIcon[watchedThemeState]),
            onTap: () => toggleThemeMode(),
          ),
        ]),
      ),
    );
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
