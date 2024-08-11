import 'package:flutter/material.dart';

class LeaveNoticeScreen extends StatefulWidget {
  static const String routeName = 'leave_notice';
  static const String routePath = 'leave_notice';

  const LeaveNoticeScreen({super.key});

  @override
  State<LeaveNoticeScreen> createState() => _LeaveNoticeScreenState();
}

class _LeaveNoticeScreenState extends State<LeaveNoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laisser votre avis')),
    );
  }
}
