import 'dart:async';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:cfc_christ/services/c_s_audio_palyer.dart';
import 'package:cfc_christ/services/c_s_audio_recorder.dart';
import 'package:cfc_christ/theme/c_transition_thme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

class CAudioRecoderWidget extends StatefulWidget {
  const CAudioRecoderWidget({super.key, required this.onFinish});

  final Function(String? filePath)? onFinish;

  @override
  State<CAudioRecoderWidget> createState() => _CAudioRecoderWidgetState();
}

class _CAudioRecoderWidgetState extends State<CAudioRecoderWidget> {
  // DATA ------------------------------------------------------------------------------------------------------------------->
  CSAudioRecorder audioRecorder = CSAudioRecorder();
  String? audioFilePath;
  String? fileName;

  Duration recordDuration = const Duration();
  Timer? timer;
  bool inPlayMode = false;
  bool inPauseMode = false;

  // INITIALIZER ------------------------------------------------------------------------------------------------------------>
  _updateState() => setState(() {});
  _recorderTimer() => timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async => setState(() => recordDuration = Duration(seconds: recordDuration.inSeconds + 1)),
      );

  @override
  void initState() {
    () async {
      await AnotherAudioRecorder.hasPermissions;

      audioRecorder.actionState.addListener(_updateState);
    }();

    super.initState();

    CSAudioPalyer.instance.player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) pauseListeningRecorded();
    });
  }

  @override
  void setState(VoidCallback fn) => super.setState(fn);

  @override
  void dispose() {
    audioRecorder.actionState.removeListener(_updateState);
    timer?.cancel();
    audioRecorder.dispose();
    cancelAndReinit();

    super.dispose();
  }

  // VIEW ------------------------------------------------------------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Builder(builder: (context) {
        if (audioRecorder.actionState.value == CSAudioRecorderState.recording ||
            audioRecorder.actionState.value == CSAudioRecorderState.paused) {
          // -- In recording --
          return Row(children: [
            Visibility(
              visible: inPauseMode,
              replacement: IconButton(onPressed: () => pauseRecording(), icon: const Icon(CupertinoIcons.pause_fill)),
              child: IconButton(onPressed: () => resumeRecording(), icon: const Icon(CupertinoIcons.playpause))
                  .animate(effects: CTransitionsTheme.model_1),
            ),
            Expanded(
              child: Text(
                "${recordDuration.inSeconds} Sec ${recordDuration.inMinutes} Min ${recordDuration.inHours} Heure",
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              onPressed: inPauseMode ? null : () => stopRecording(),
              icon: Icon(CupertinoIcons.stop, color: inPauseMode ? null : Theme.of(context).colorScheme.error),
            ),
            IconButton.filledTonal(
              onPressed: () => finishRecordProcess(),
              icon: const Icon(CupertinoIcons.check_mark),
            ),
          ]).animate(effects: CTransitionsTheme.model_1);

          // -- Finish state. --
        } else if (audioRecorder.actionState.value == CSAudioRecorderState.finished ||
            audioRecorder.actionState.value == CSAudioRecorderState.reading) {
          return Row(children: [
            Expanded(
              child: Column(children: [
                const Text("Audio"),
                if (fileName != null)
                  Text(
                    fileName ?? 'Nom du fichier',
                    style: Theme.of(context).textTheme.labelSmall,
                    textAlign: TextAlign.end,
                  )
                else
                  StreamBuilder<Duration>(
                    stream: CSAudioPalyer.inst.player.positionStream,
                    builder: (context, snapshot) {
                      return Text(
                        "${recordDuration.inSeconds - (snapshot.data?.inSeconds ?? 0)} Sec "
                        "${recordDuration.inMinutes - (snapshot.data?.inMinutes ?? 0)} Min "
                        "${recordDuration.inHours - (snapshot.data?.inHours ?? 0)} Heure",
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.end,
                      );
                    },
                  ),
              ]),
            ),
            if (inPlayMode)
              IconButton.filledTonal(
                onPressed: () => pauseListeningRecorded(),
                icon: const Icon(CupertinoIcons.pause_fill),
              )
            else
              IconButton.filledTonal(onPressed: () => listenRecorded(), icon: const Icon(CupertinoIcons.play)),
            IconButton(
              onPressed: inPlayMode ? null : () => cancelAndReinit(),
              icon: const Icon(CupertinoIcons.xmark),
            ),
          ]).animate(effects: CTransitionsTheme.model_1);
        }

        // -- Start --
        return Row(children: [
          IconButton(
              onPressed: () => selectFileFromDisk(),
              icon: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(CupertinoIcons.paperclip),
                Text("Fichier", style: Theme.of(context).textTheme.labelSmall),
              ])),
          const Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Enreigstrer un audio >", textAlign: TextAlign.center),
              Text("< Sélectionnez un fichier audio", textAlign: TextAlign.center),
            ]),
          ),
          IconButton.filledTonal(onPressed: () => startRecording(), icon: const Icon(CupertinoIcons.mic)),
        ]);
      }),
    );
  }

  // METHOD ----------------------------------------------------------------------------------------------------------------->
  startRecording() {
    recordDuration = const Duration();
    _recorderTimer();
    audioRecorder.start();
  }

  stopRecording() {
    timer?.cancel();
    audioRecorder.finish();
  }

  pauseRecording() {
    timer?.cancel();
    setState(() => inPauseMode = true);
    audioRecorder.resume();
  }

  listenRecorded() {
    if (audioFilePath != null) {
      audioRecorder.listen(audioFilePath ?? '');
      inPlayMode = true;
      audioRecorder.actionState.value = CSAudioRecorderState.reading;
    }
  }

  pauseListeningRecorded() {
    setState(() => inPlayMode = false);
    audioRecorder.stopListen();
    // audioRecorder.actionState.value = CSAudioRecorderState.reading;
  }

  finishRecordProcess() async {
    timer?.cancel();
    var audio = await audioRecorder.finish();
    audioFilePath = audio?.path;
    widget.onFinish?.call(audio?.path);
    audioRecorder.actionState.value = CSAudioRecorderState.finished;
  }

  resumeRecording() {
    _recorderTimer();
    audioRecorder.resume();
    setState(() => inPauseMode = false);
    audioRecorder.actionState.value = CSAudioRecorderState.finished;
  }

  cancelAndReinit() {
    timer?.cancel();
    audioFilePath = null;
    fileName = null;
    audioRecorder.stopListen();
    inPlayMode = false;
    audioRecorder.actionState.value = CSAudioRecorderState.stopped;
  }

  selectFileFromDisk() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['acc', 'mp3']);
    if (result != null) {
      setState(() {
        fileName = result.xFiles.first.name;
        audioFilePath = result.xFiles.first.path;
        widget.onFinish?.call(audioFilePath);
        audioRecorder.actionState.value = CSAudioRecorderState.finished;
      });
    }
  }
}
