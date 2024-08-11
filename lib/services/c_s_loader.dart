import 'dart:async';

import 'package:cfc_christ/model_view/misc_data_handler_mv.dart';
import 'package:cfc_christ/model_view/pcn_data_handler_mv.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CSLoader {
  CSLoader.load({this.onStart, this.onFinish, this.onStepChange, this.onError}) {
    // Start after 1 second.
    Timer(1.seconds, () => onStart?.call());

    // Start loading at 3 seconds.
    Timer(3.seconds, () => _load());
  }

  final Function()? onStart;
  final Function()? onFinish;
  final Function()? onStepChange;
  final Function()? onError;

  // All loader sequence have a one boolean value here.
  // All falsed values must be true, for end execution and then run onFinish
  // callback.
  final List<bool> _loadSequences = [false, false];

  // Load loader's : >>>
  void _load() {
    _loadPcns();
    _loadMiscs();
  }

  // Load sequence controller :
  // Control if all loader are finished.
  // if not one less then not launch the onFinish collback.
  void _finishSequence(int index) {
    _loadSequences[index] = true;

    // Finish loading.
    if (!_loadSequences.contains(false)) {
      onFinish?.call();
    }
  }

  // LOADERS --------------------------------------------------------- :
  void _loadPcns() {
    PcnDataHandlerMv().download(
      onError: onError,
      onFinish: (data) {
        _finishSequence(0); // IS THE FIRST SEQUENCE.
      },
    );
  }

  void _loadMiscs() {
    MiscDataHandlerMv().download(
        onError: onError,
        onFinish: (data) {
          _finishSequence(1);
        });
  }
}
