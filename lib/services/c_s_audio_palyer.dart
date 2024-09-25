import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

enum CSAudioPlayerState { playing, paused, stopped }

class CSAudioPalyer {
  static CSAudioPalyer? _instance;
  CSAudioPalyer._();
  static CSAudioPalyer get instance => _instance ??= CSAudioPalyer._();
  static CSAudioPalyer get inst => instance;

  // ------------------------------------------------------------------------------------------------------------------------>
  final player = AudioPlayer();
  double volume = 1.0;

  String? playerSectionId;
  bool showBottomPlayer = false;

  ValueNotifier<CSAudioPlayerState> playState = ValueNotifier(CSAudioPlayerState.stopped);

  String? _source;
  String? get source => _source;
  set source(String? src) {
    () async {
      _source = src;

      await stop();
      playState.value = CSAudioPlayerState.stopped;
      if (src != null) {
        await player.setUrl(src);
        await player.setVolume(volume);
      }
    }();
  }

  set speed(double speed) {
    if (player.playing && speed >= .5 && speed <= 2.0) player.setSpeed(speed);
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  Future<void> stop() async {
    if (_source == null) return;

    await player.stop();
    playState.value = CSAudioPlayerState.stopped;
  }

  Future<void> pause() async {
    if (_source == null) return;

    await player.pause();
    playState.value = CSAudioPlayerState.paused;
  }

  Future<void> play() async {
    if (_source == null) return;

    await player.play();
    playState.value = CSAudioPlayerState.playing;
  }

  Future<void> seek(Duration position) async {
    player.seek(position);
  }

  void dispose() async {
    if (_source == null) return;

    // player.stop();
    // player.setSpeed(1.0);
    speed = 1;
    // _source = null;
    playState.removeListener(() {});
  }
}
