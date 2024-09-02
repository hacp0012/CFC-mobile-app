import 'dart:convert';
import 'dart:io';

import 'package:cfc_christ/database/app_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum CSTtsState { stopped, playing, paused, continued }

class CSTts {
  static CSTts? _instance;
  CSTts._();
  static CSTts get instance => _instance ??= CSTts._();
  static CSTts get inst => instance;

  // -------------------------------------------------------------------------------------------------------------------------
  static const String configsStoreKey = 'CONFIGS_STORE_KEY';

  late FlutterTts _flutterTts;
  bool _canAct = false;

  ValueNotifier<CSTtsState> state = ValueNotifier<CSTtsState>(CSTtsState.stopped);

  dynamic errorLog;

  List<Object?>? engines;
  List? voices;

  double pitch = 1.0;
  double rate = .7;
  double volume = .9;
  String? engine;
  Map<String, String>? voice;

  int? maxSpeechInput;

  Map get _configs {
    String? data = CAppPreferences().instance?.getString(configsStoreKey);

    if (data != null) return jsonDecode(data);

    return {
      'engine': null,
      'rate': .7,
      'pitch': 1.0,
      'volume': .9,
      'voice': null,
    };
  }

  // VoidCallback? onStateChanged;

  String? _textToRead;

  // METHODS ---------------------------------------------------------------------------------------------------------------->
  initiliaze() async {
    _flutterTts = FlutterTts();
    _flutterTts.awaitSpeakCompletion(true);
    _canAct = true;

    Map configs = _configs;
    pitch = configs['pitch'];
    volume = configs['volume'];
    rate = configs['rate'];
    engine = configs['engine'];
    voice = configs['voice'] != null ? {'name': configs['voice']['name'], 'locale':configs['voice']['locale']} : null;

    if (await _flutterTts.isLanguageAvailable("fr-FR")) _flutterTts.setLanguage('fr-FR');

    await _flutterTts.setVolume(volume); // 0.0 - 1.0
    await _flutterTts.setSpeechRate(rate); // 0.0 - 1.0
    await _flutterTts.setPitch(pitch); // 0.0 - 2.0
    await _flutterTts.setEngine(engine ?? await _flutterTts.getDefaultEngine);
    var defaultLanguages = await _flutterTts.getDefaultVoice;
    await _flutterTts.setVoice(
      voice ?? <String, String>{'name': defaultLanguages['name'], 'locale': defaultLanguages['locale']},
    );

    List<dynamic> foundVoices = [];
    for(var voice in await _flutterTts.getVoices) {
      if ((voice['locale'] as String).startsWith(RegExp('fr|en'))) foundVoices.add(voice);
    }
    voices = foundVoices;


    if (Platform.isAndroid) {
      engines = await _flutterTts.getEngines;
      maxSpeechInput = await _flutterTts.getMaxSpeechInputLength;
    }

    _flutterTts.setStartHandler(() => state.value = CSTtsState.playing);
    _flutterTts.setCompletionHandler(() => state.value = CSTtsState.stopped);
    _flutterTts.setCancelHandler(() => state.value = CSTtsState.stopped);
    _flutterTts.setErrorHandler((message) {
      state.value = CSTtsState.stopped;
      errorLog = message;
    });
    _flutterTts.setContinueHandler(() => state.value = CSTtsState.continued);
    _flutterTts.setPauseHandler(() => state.value = CSTtsState.paused);
  }

  void dispose() {
    _flutterTts.stop();
    state.removeListener(() {});
  }

  Future<CSTts> textToRead(String text) async {
    if (_canAct == false) return this;

    _textToRead = text;

    return this;
  }

  play() {
    assert(true, "No implemented [Play]");
  }

  pause() {
    assert(true, "No implemented [Pause]");
  }

  replay() async {
    if (_canAct == false) return;

    var result = await _flutterTts.speak(_textToRead ?? '');
    if (result == 1) state.value = CSTtsState.playing;
  }

  stop() async {
    if (_canAct == false) return;

    var result = await _flutterTts.stop();
    if (result == 1) state.value = CSTtsState.stopped;
  }

  progressWatch(Function(String text, int startOffset, int endOffset, String word) callback) {
    _flutterTts.setProgressHandler(callback);
  }

  // PREFERENCE ------------------------------------------------------------------------------------------------------------->
  updateEngine(String? engine) {
    if (engine != null) {
      _configs['engine'] = engine;

      updateConfigs(_configs);
    }
  }

  updateRate(double rate) {
    if (rate <= 1.0 && rate >= .0) {
      Map configs = _configs;
      configs['rate'] = rate;

      updateConfigs(configs);
    }
  }

  updatePicth(double pitch) {
    if (pitch <= 2.0 && pitch >= .0) {
      var configs = _configs;
      configs['pitch'] = pitch;

      updateConfigs(configs);
    }
  }

  updateVolume(double volume) {
    if (volume <= 1.0 && volume >= .0) {
      _configs['volume'] = volume;

      updateConfigs(_configs);
    }
  }

  updateVoice(Map voice) {
    var configs = _configs;
    configs['voice'] = voice;

    updateConfigs(configs);
  }

  /// Update stored configs in preference :
  updateConfigs(Map configs) {
    pitch = configs['pitch'];
    volume = configs['volume'];
    rate = configs['rate'];
    engine = configs['engine'];
    voice = {'name': configs['voice']['name'], 'locale': configs['voice']['locale']};


    return CAppPreferences().instance?.setString(configsStoreKey, jsonEncode(configs));
  }
}
