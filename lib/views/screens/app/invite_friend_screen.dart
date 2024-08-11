import 'package:flutter/material.dart';

class InviteFriendScreen extends StatefulWidget {
  static const String routeName = 'invite_friend';
  static const String routePath = 'invite_friend';

  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invit friend')),
    );
  }
}
