import 'package:cfc_christ/views/layouts/empty_layout.dart';
import 'package:flutter/material.dart';

class UserFamilyParentsScreen extends StatefulWidget {
  static const String routeName = 'family.parents';
  static const String routePath = 'parents';

  const UserFamilyParentsScreen({super.key});

  @override
  State<UserFamilyParentsScreen> createState() => _UserFamilyParentsScreenState();
}

class _UserFamilyParentsScreenState extends State<UserFamilyParentsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(title: const Text('Mes Parents')),
      ),
    );
  }
}
