import 'package:flutter/material.dart';

class UserResponsabilityScreen extends StatefulWidget {
  static const String routeName = 'user.responsability';
  static const String routePath = 'responsability';

  const UserResponsabilityScreen({super.key});

  @override
  State<UserResponsabilityScreen> createState() => _UserResponsabilityScreenState();
}

class _UserResponsabilityScreenState extends State<UserResponsabilityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Responsibility')),
    );
  }
}
