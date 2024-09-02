import 'dart:io';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

enum CSAudioRecorderState { stopped, recording, finished, reading, paused }

class CSAudioRecorder {
  CSAudioRecorder() {
    () async {
      await AnotherAudioRecorder.hasPermissions;

      tempFile = "${(await getApplicationCacheDirectory()).path}/audio_recorder_tmp.aac";

      File file = File(tempFile);
      if (await file.exists()) await file.delete();

      _instance = AnotherAudioRecorder(tempFile, audioFormat: defautEncode);
      await _instance?.initialized;
    }();
  }

  // DATAS ------------------------------------------------------------------------------------------------------------------>
  AnotherAudioRecorder? _instance;

  final int _channel = 0;

  late String tempFile;

  AudioFormat defautEncode = AudioFormat.AAC;

  ValueNotifier<CSAudioRecorderState> actionState = ValueNotifier(CSAudioRecorderState.stopped);

  Future<Recording?> get recordState async {
    return await _instance?.current(channel: _channel);
  }

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  void hasPermission(VoidCallback fn) {}

  void start() async {
    // await AnotherAudioRecorder.hasPermissions;

    await _instance?.start();
    actionState.value = CSAudioRecorderState.recording;
  }

  void pause() async {
    await _instance?.pause();
    actionState.value = CSAudioRecorderState.paused;
  }

  void resume() async {
    await _instance?.resume();
    actionState.value = CSAudioRecorderState.recording;
  }

  Future<Recording?> finish() async {
    var result = await _instance?.stop();
    Recording? recording = result;
    actionState.value = CSAudioRecorderState.stopped;

    return recording;
  }

  CSAudioRecorderState? _lastState;
  void listen(String path) {
    _lastState = actionState.value;
    CSAudioPalyer.instance.source = 'file://$path';

    CSAudioPalyer.instance.play();
    actionState.value = CSAudioRecorderState.recording;

    CSAudioPalyer.instance.playState.addListener(() => actionState.value = _lastState ?? actionState.value);
  }

  void stopListen() => CSAudioPalyer.instance.dispose();

  void dispose() {
    stopListen();
    _instance?.stop();
    actionState.removeListener(() {});
  }
}
