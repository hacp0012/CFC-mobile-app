import 'package:cfc_christ/configs/c_constants.dart';
import 'package:cfc_christ/views/layouts/default_layout.dart';
import 'package:cfc_christ/views/screens/user/partials/user_partial_profile_screen.dart';
import 'package:cfc_christ/views/screens/user/profile_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'user.pofile';
  static const String routePath = '/user';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profil utilisateur'),
          actions: [
            TextButton.icon(
              onPressed: () => context.pushNamed(ProfileSettingScreen.routeName),
              icon: const Icon(Icons.edit, size: CConstants.GOLDEN_SIZE * 2),
              iconAlignment: IconAlignment.end,
              label: const Text('Modifier'),
            ),
          ],
        ),
        body: const UserPartialProfileScreen(),
      ),
    );
  }
}
