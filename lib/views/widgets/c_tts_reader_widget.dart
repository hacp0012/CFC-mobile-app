import 'package:cfc_christ/services/c_s_tts.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CTtsReaderWidget extends StatefulWidget {
  const CTtsReaderWidget({super.key, required this.text, this.iConOnly = false, this.buttonText = 'Ecouter'});
  const CTtsReaderWidget.icon({super.key, required this.text, this.iConOnly = true, this.buttonText = 'Ecouter'});

  final String Function() text;
  final bool iConOnly;
  final String buttonText;

  @override
  State createState() => _CTtsReaderWidgetState();
}

class _CTtsReaderWidgetState extends State<CTtsReaderWidget> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  bool inPlaying = false;
  var playState = CSTts.inst.state;

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    CSTts.inst.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    playState.addListener(() => setState(() {}));
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (widget.iConOnly) {
        return IconButton(
          // style: const ButtonStyle(visualDensity: VisualDensity.compact),
          onPressed: action,
          icon: _iconState(),
        );
      } else {
        return ElevatedButton.icon(
          style: const ButtonStyle(visualDensity: VisualDensity.compact),
          label: Text(playState.value == CSTtsState.playing ? 'Arrêter' : widget.buttonText),
          onPressed: action,
          icon: _iconState(),
        );
      }
    });
  }

  Widget _iconState() {
    return Builder(builder: (context) {
      if (playState.value == CSTtsState.playing) {
        return Icon(
          CupertinoIcons.stop,
          color: Theme.of(context).colorScheme.error,
        ).animate(effects: CTransitionsTheme.model_1);
      } else {
        return const Icon(CupertinoIcons.speaker_1);
      }
    });
  }
  // METHOD ----------------------------------------------------------------------------------------------------------------->

  action() {
    if (playState.value == CSTtsState.playing) {
      _stop();
    } else if (playState.value == CSTtsState.stopped) {
      _play();
    }
  }

  _play() {
    setState(() => playState.value = CSTtsState.playing);

    CSTts.inst.textToRead(widget.text.call());
    CSTts.inst.replay();
  }

  _stop() {
    setState(() => playState.value == CSTtsState.stopped);

    CSTts.inst.stop();
  }
}
