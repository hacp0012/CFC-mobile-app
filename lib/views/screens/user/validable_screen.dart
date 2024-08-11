import 'package:flutter/material.dart';

class ValidableScreen extends StatefulWidget {
  static const String routeName = 'validables';
  static const String routePath = 'validables';

  const ValidableScreen({super.key});

  @override
  State<ValidableScreen> createState() => _ValidableScreenState();
}

class _ValidableScreenState extends State<ValidableScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validables')),
    );
  }
}
