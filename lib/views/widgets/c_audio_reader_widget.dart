import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

class CAudioReaderWidget extends StatefulWidget {
  const CAudioReaderWidget({super.key, required this.audioSource});

  final String audioSource;

  @override
  State createState() => _CAudioReaderWidgetState();
}

class _CAudioReaderWidgetState extends State<CAudioReaderWidget> {
  // DATAS ------------------------------------------------------------------------------------------------------------------>
  double currentSpeed = 1.0;
  CSAudioPalyer audioPalyer = CSAudioPalyer.inst;
  Duration readPosition = const Duration();
  bool inLoading = false;

  // INITIALIZERS ----------------------------------------------------------------------------------------------------------->
  @override
  void initState() {
    debugPrint("Initlized -->-----------------------------------");
    audioPalyer.source = widget.audioSource;

    audioPalyer.player.processingStateStream.listen((state) {
      if (audioPalyer.player.playing) {
        if (ProcessingState.idle == state) {
          setState(() => inLoading = false);
        } else if (ProcessingState.buffering == state) {
          setState(() => inLoading = false);
        } else if (ProcessingState.loading == state) {
          inLoading = true;
        } else if (ProcessingState.ready == state) {
          setState(() => inLoading = false);
        } else if (ProcessingState.completed == state) {
          stop();
        }
      }
    });
    super.initState();
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  void dispose() {
    audioPalyer.dispose();
    audioPalyer.playState.value = CSAudioPlayerState.stopped;

    super.dispose();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(CConstants.GOLDEN_SIZE / 2),
        child: Row(children: [
          StreamBuilder<bool>(
            stream: audioPalyer.player.playingStream,
            builder: (context, snapshot) {
              if (inLoading == false) {
                if (snapshot.data == true) {
                  return IconButton(
                    onPressed: pause,
                    icon: const Icon(CupertinoIcons.pause_fill).animate(effects: CTransitionsTheme.model_1),
                  );
                }
                return IconButton(
                  onPressed: play,
                  icon: const Icon(CupertinoIcons.play_arrow),
                );
              }

              return const IconButton(
                onPressed: null,
                icon: SizedBox(height: 18.0, width: 18.0, child: CircularProgressIndicator(strokeCap: StrokeCap.round)),
              );
            },
          ),
          Expanded(
            child: Column(
              children: [
                SliderTheme(
                  data: const SliderThemeData(
                    rangeThumbShape: RoundRangeSliderThumbShape(),
                    trackHeight: 2,
                    trackShape: RoundedRectSliderTrackShape(),
                    inactiveTrackColor: Colors.blueGrey,
                  ),
                  child: StreamBuilder<Duration>(
                    stream: audioPalyer.player.positionStream,
                    builder: (context, snapshot) {
                      double position = snapshot.data?.inSeconds.toDouble() ?? 1;
                      var maxPosition = audioPalyer.player.duration?.inSeconds.toDouble();
                      return Slider(
                        value: position < 1 ? 1 : position,
                        min: 1.0,
                        max: (maxPosition ?? 1.0) < 1.0 ? 1.0 : (maxPosition ?? 1.0),
                        onChanged: (position) {},
                        onChangeEnd: (position) => onPositionChnaged(position),
                        onChangeStart: (position) {},
                        thumbColor: Theme.of(context).colorScheme.primaryContainer,
                      );
                    },
                  ),
                ),
                Row(children: [
                  StreamBuilder<Duration>(
                    stream: audioPalyer.player.positionStream,
                    builder: (context, snapshot) {
                      return Text(
                        "${snapshot.data?.inHours ?? '00'}:"
                        "${snapshot.data?.inMinutes ?? '00'}:"
                        "${snapshot.data?.inSeconds ?? '00'}",
                        style: Theme.of(context).textTheme.labelSmall,
                      );
                    },
                  ),
                  const Spacer(),
                  Text(
                    "${audioPalyer.player.duration?.inHours ?? '00'}:"
                    "${audioPalyer.player.duration?.inMinutes ?? '00'}:"
                    "${audioPalyer.player.duration?.inSeconds ?? '00'}",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ]),
              ],
            ),
          ),
          TextButton(
            onPressed: () => speeder(),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("x$currentSpeed"),
              Text("Vitesse", style: Theme.of(context).textTheme.labelSmall),
            ]),
          ),
        ]),
      ),
    );
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  speeder() => setState(() {
        double speed = 1.0;

        switch (currentSpeed) {
          case .75:
            currentSpeed = 1.0;
            speed = 1.0;
          case 1.0:
            currentSpeed = 1.5;
            speed = 1.25;
          case 1.5:
            currentSpeed = 2.0;
            speed = 1.5;
          case 2.0:
            currentSpeed = .5;
            speed = .75;

          default:
            currentSpeed = 1.0;
            speed = 1.0;
        }

        audioPalyer.speed = speed;
      });

  onPositionChnaged(double position) {
    audioPalyer.seek(Duration(seconds: position.toInt()));
  }

  play() {
    setState(() {
      audioPalyer.play();
      audioPalyer.playState.value = CSAudioPlayerState.playing;
    });
  }

  pause() {
    setState(() {
      audioPalyer.pause();
      audioPalyer.playState.value = CSAudioPlayerState.paused;
    });
  }

  stop() {
    audioPalyer.stop();
    onPositionChnaged(1.0);
  }
}
