import 'dart:async';

import 'package:cfc_christ/model_view/validable_mv.dart';
import 'package:flutter/foundation.dart';

class CSValidable {
  // DATAS -------------------------------------------------------------------------------------------------------------------
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  ValueNotifier<Map> list = ValueNotifier<Map>({});

  Timer? _timer;

  // INITIALIZER -------------------------------------------------------------------------------------------------------------
  CSValidable({bool autoload = false}) {
    if (autoload) _periodicLoader();
  }

  void _periodicLoader() => _timer = Timer.periodic(const Duration(seconds: 9), (timer) => load());

  // METHODS -----------------------------------------------------------------------------------------------------------------
  Future<void> load([bool downloadDisponibleAnyway = false]) {
    _checkIfDisponible().then(
      (count) {
        if (count > 0) {
          return _downloadDisponibles();
        } else {
          return Future.value();
        }
      },
      onError: (error) {},
    );

    if (downloadDisponibleAnyway) _downloadDisponibles();

    return Future.value();
  }

  void killTimer() => _timer?.cancel();

  Future<int> _checkIfDisponible() async {
    counter.value = await ValidableMv.chechIfHasNew();
    return Future.value(counter.value);
  }

  Future<void> _downloadDisponibles() async {
    list.value = await ValidableMv.download();
    return Future.value();
  }

  void notify() {}
}
