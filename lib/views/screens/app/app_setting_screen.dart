import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/services/c_s_tts.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/widgets/c_tts_reader_widget.dart';
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
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  Widget build(BuildContext context) {
    final watchedThemeState = watchValue<CDefaultState, ThemeMode>((CDefaultState data) => data.themeMode);

    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Parametres')),

        // --- Body :
        body: ListView(padding: const EdgeInsets.symmetric(horizontal: CConstants.GOLDEN_SIZE * 2), children: [
          const SizedBox(height: CConstants.GOLDEN_SIZE),
          Text("Theme", style: Theme.of(context).textTheme.titleMedium),
          ListTile(
            title: Text('Theme ${themeModeButtonText[watchedThemeState]}'),
            subtitle: const Text("Changer en mode sombre, claire ou automatique."),
            leading: Icon(themeModeButtonIcon[watchedThemeState]),
            onTap: () => toggleThemeMode(),
          ),

          // --- TTS ---
          const SizedBox(height: CConstants.GOLDEN_SIZE * 3),
          Text("Moteur de synthese vocale", style: Theme.of(context).textTheme.titleMedium),
          Text(
            "Celle qui est utilisé pour la lecture des publications textuel (Communiqué, Écho et Enseignement).",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: CConstants.GOLDEN_SIZE * 2),
          DropdownButtonHideUnderline(
            child: DropdownMenu<String>(
              label: const Text("Voix (Français et Anglais)"),
              initialSelection: CSTts.inst.voice?['name'],
              menuHeight: CConstants.GOLDEN_SIZE * 27,
              width: double.infinity,
              onSelected: (name) {
                for (Map voice in CSTts.inst.voices ?? []) {
                  if (voice['name'] == name) {
                    CSTts.inst.updateVoice({'name': voice['name'], 'locale': voice['locale']});
                    CSTts.inst.initiliaze();
                    break;
                  }
                }
              },
              dropdownMenuEntries: CSTts.inst.voices?.map((element) {
                    return DropdownMenuEntry<String>(
                      leadingIcon: const Icon(Icons.voice_chat),
                      value: element['name'],
                      label: "${element['locale']} - ${element['name']}",
                    );
                  }).toList() ??
                  [],
            ),
          ),
          Row(children: [
            const Text("Vitesse"),
            Expanded(
              child: Slider(
                value: CSTts.inst.rate,
                divisions: 20,
                label: "Vitesse",
                onChanged: (value) {},
                onChangeStart: (value) {},
                onChangeEnd: (value) {
                  setState(() {
                    CSTts.inst.updateRate(value);
                    CSTts.inst.initiliaze();
                  });
                },
              ),
            ),
          ]),
          Row(children: [
            const Text("Hauteur"),
            Expanded(
                child: Slider(
              value: CSTts.inst.pitch,
              divisions: 20,
              label: "Hauteur",
              onChanged: (value) {},
              onChangeEnd: (pitch) {
                setState(() {
                  CSTts.inst.updatePicth(pitch);
                  CSTts.inst.initiliaze();
                });
              },
            )),
          ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [const Text("Tester la voix "), CTtsReaderWidget(text: () => "Salut, dans la Famille Chrétienne.")]),
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
