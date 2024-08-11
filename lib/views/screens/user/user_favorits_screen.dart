import 'package:cfc_christ/views/screens/home/partials/home_screen_partial_view_favorits.dart';
import 'package:flutter/material.dart';

class UserFavoritsScreen extends StatefulWidget {
  static const String routeName = 'user.favorits';
  static const String routePath = 'favorits';

  const UserFavoritsScreen({super.key});

  @override
  State<UserFavoritsScreen> createState() => _UserFavoritsScreenState();
}

class _UserFavoritsScreenState extends State<UserFavoritsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),

      // --- Body :
      body: const HomeScreenPartialViewFavorits(),
    );
  }
}
