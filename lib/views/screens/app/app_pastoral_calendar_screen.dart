import 'package:flutter/material.dart';

class AppPastoralCalendarScreen extends StatefulWidget {
  static const String routeName = 'pastoral.calendar';
  static const String routePath = 'calendar/app';

  const AppPastoralCalendarScreen({super.key});

  @override
  State<AppPastoralCalendarScreen> createState() => _AppPastoralCalendarScreenState();
}

class _AppPastoralCalendarScreenState extends State<AppPastoralCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Calendrier pastoral')));
  }
}
