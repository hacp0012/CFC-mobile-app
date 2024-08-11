import 'package:flutter/material.dart';

class ContactusScreen extends StatefulWidget {
  static const String routeName = 'contactus';
  static const String routePath = 'contactus';

  const ContactusScreen({super.key});

  @override
  State<ContactusScreen> createState() => _ContactusScreenState();
}

class _ContactusScreenState extends State<ContactusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact us'),
      ),
      body: null,
    );
  }
}
