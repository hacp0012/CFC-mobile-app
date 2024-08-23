import 'dart:async';

import 'package:cfc_christ/env.dart';
import 'package:cfc_christ/views/widgets/c_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';

/// Network state class.
class CNetworkState {
  /// Online state.
  ValueNotifier<bool> online = ValueNotifier<bool>(false);

  /// InternetConnectivity instace.
  /// All instance of this are Future.
  InternetConnectivity instance = InternetConnectivity();

  late StreamSubscription _cancel;

  CNetworkState() {
    online.value = Env.APP_NETWORK_OFFLINE_MODE ? true : false;

    _cancel = instance.observeInternetConnection.listen((bool hasInternetAccess) {
      // Work without internet connection.
      if (Env.APP_NETWORK_OFFLINE_MODE) {
        online.value = true;
      } else {
        online.value = hasInternetAccess;
      }
    });
  }

  /// Cancel subscription.
  cancel() {
    _cancel.cancel();
  }

  /// Call [fn] if [onlineState] is true. otherwise show Network message.
  static void ifOnline(BuildContext context, bool onlineState, Function() fn) {
    if (onlineState) {
      fn.call();
    } else {
      CSnackbarWidget(context, content: const Text("Vous n'êtes pas connecté à internet."), defaultDuration: true);
    }
  }
}
