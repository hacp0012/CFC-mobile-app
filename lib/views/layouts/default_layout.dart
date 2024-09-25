import 'package:cfc_christ/classes/c_misc_class.dart';
import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:cfc_christ/theme/configs/tc_overlay_ui_style.dart';
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:watch_it/watch_it.dart';

class DefaultLayout extends WatchingStatefulWidget with WatchItStatefulWidgetMixin {
  final Widget child;
  final Color? navColor;
  final bool transparentStatusBar;

  const DefaultLayout({super.key, required this.child, this.navColor, this.transparentStatusBar = false});

  @override
  State<StatefulWidget> createState() => _EmptyLayoutState();
}

class _EmptyLayoutState extends State<DefaultLayout> {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  bool appIsOnline = false;
  CSAudioPalyer csAudioPalyer = CSAudioPalyer.inst;
  bool showPlayerButton = false;

  // INITIALIZERS ------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();

    csAudioPalyer.player.playingStream.listen((state) {
      if (mounted) {
        setState(() {
          showPlayerButton = state;
        });
      }
    });
  }

  // VIEW --------------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    appIsOnline = watchValue<CNetworkState, bool>((CNetworkState data) => data.online);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: TcOverlayUiStyle.of(context, navColor: widget.navColor, statusBarTo: widget.transparentStatusBar),
      child: FloatingDraggableWidget(
        floatingWidget: Visibility(
          visible: showPlayerButton,
          child: Material(
            elevation: 6.3,
            shadowColor: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(27.3),
            child: IconButton.filledTonal(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              onPressed: () {
                csAudioPalyer.pause();
              },
              icon: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(CupertinoIcons.playpause, size: 9.0 * 2),
                Text("Lecture", style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9.0))
              ]),
            ).animate(effects: CTransitionsTheme.model_1),
          ),
        ),
        floatingWidgetWidth: CConstants.GOLDEN_SIZE * 6,
        floatingWidgetHeight: CConstants.GOLDEN_SIZE * 6,
        autoAlign: true,
        isDraggable: true,
        dy: CConstants.GOLDEN_SIZE + 126,
        mainScreenWidget: Column(mainAxisSize: MainAxisSize.min, children: [
          // APPLICATION CONTENT :
          Expanded(child: widget.child),

          // AUDIO READER :
          /*StreamBuilder<bool>(
            stream: csAudioPalyer.player.playingStream,
            builder: (context, snapshot) {
              return Visibility(
                visible: snapshot.hasData && snapshot.data == true,
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  height: CConstants.GOLDEN_SIZE * 4.5,
                  child: Row(children: [
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.play)),
                    Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("Audio title", style: Theme.of(context).textTheme.labelSmall),
                      LinearProgressIndicator(value: .6, borderRadius: BorderRadius.circular(4.5)),
                    ])),
                    IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.xmark)),
                  ]).animate(effects: CTransitionsTheme.model_1),
                ),
              );
            }
          ),*/

          // ONLINE STATE INDICATOR :
          if (!appIsOnline)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: CMiscClass.whenBrightnessOf<Color>(context, light: Colors.grey.shade200)),
              child: Text(
                "Vous êtes hors ligne",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ]),
      ),
    );
  }
}
