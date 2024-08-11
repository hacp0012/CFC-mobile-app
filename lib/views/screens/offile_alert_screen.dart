import 'package:flutter/material.dart';

class OffileAlertScreen extends StatelessWidget {
  static const String routeName = "offline.alert.screen";
  static const String routePath = "alert/offline";

  const OffileAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerte'), centerTitle: true),
      body: const Center(
        child: Text("Vous n'êtes pas connecté à internet"),
      ),
    );
  }
}
