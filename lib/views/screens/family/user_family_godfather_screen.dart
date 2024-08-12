import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/material.dart';

class UserFamilyGodfatherScreen extends StatefulWidget {
  static const String routeName = 'family.godfather';
  static const String routePath = 'godfather';

  const UserFamilyGodfatherScreen({super.key});

  @override
  State<UserFamilyGodfatherScreen> createState() => _UserFamilyGodfatherScreenState();
}

class _UserFamilyGodfatherScreenState extends State<UserFamilyGodfatherScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Godfather')),
      ),
    );
  }
}
