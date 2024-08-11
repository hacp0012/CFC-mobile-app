import 'package:cfc_christ/app.dart';
import 'package:cfc_christ/configs/c_api.dart';
import 'package:cfc_christ/configs/c_network_state.dart';
import 'package:cfc_christ/database/app_preferences.dart';
import 'package:cfc_christ/database/c_database.dart';
import 'package:cfc_christ/states/c_default_state.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Provider.debugCheckInvalidValueType = null;

  // CACHE INITIALIZER.
  CApi.initializeCacheStore();

  // DATABASE INITIALIZATION.
  // CDatabase.removeDatabase();
  await CDatabase().initialize();

  // INITIALIZE PREFERENCE SEINGLETON CLASS.
  CAppPreferences().initialize();

  GetIt.I.registerSingleton<CNetworkState>(CNetworkState());
  GetIt.I.registerSingleton<CDefaultState>(CDefaultState());

  // RUNING APP SETUP --------------------------------------------------------->
  runApp(const Setup());
}
