import 'dart:ui';

import 'package:cfc_christ/app.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/c_database.dart';
import 'package:cfc_christ/services/bg/c_s_background.dart';
import 'package:cfc_christ/services/c_s_boot.dart';
import 'package:cfc_christ/services/notification/c_s_notification.dart';
import 'package:cfc_christ/services/validable/c_s_validable.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:watch_it/watch_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // BG SERVICE.
  CSBackground.initialize();

  // NOTIFICATION.
  CSNotification.initialize();

  // INITALIZER ------------------------------------------------------------------------------------------------------------->
  // CACHE INITIALIZER.
  CApi.initializeCacheStore();

  // DATABASE INITIALIZATION.
  // CDatabase.removeDatabase();
  await CDatabase().initialize();

  // INITIALIZE PREFERENCE SEINGLETON CLASS.
  CAppPreferences().initialize();

  GetIt.I.registerSingleton<CNetworkState>(CNetworkState());
  GetIt.I.registerSingleton<CDefaultState>(CDefaultState());

  // INIT VALIDABLE SERVICE.
  GetIt.I.registerSingleton<CSValidable>(CSValidable(autoload: true));

  // ASKING FOR PERMISSIONS.
  CSBoot.askingForPermissions();

  // RUNING APP SETUP ------------------------------------------------------------------------------------------------------->
  runApp(const Setup());
}
