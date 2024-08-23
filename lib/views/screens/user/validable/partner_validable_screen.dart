import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PartnerValidableScreen extends StatefulWidget {
  static const String routeName = 'validable.partner';
  static const String routePath = 'partner';

  final GoRouterState? grState;

  const PartnerValidableScreen({super.key, this.grState});

  @override
  State createState() => _PartnerValidableScreenState();
}

class _PartnerValidableScreenState extends State<PartnerValidableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info de comfirmation'), centerTitle: true),

      // body:
      body: const SingleChildScrollView(child: Text("")),
    );
  }
}
